import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:My_Defense/models/user_model.dart';
import 'package:My_Defense/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../models/sessionSoutenance.dart';
import '../../../models/session_model.dart';

import 'package:table_calendar/table_calendar.dart';
import '../../../services/session_service.dart';
import 'edit_event.dart';
import '../../../models/event.dart';
import 'event_item.dart';
import '../event/add_event.dart';

class EventScreen extends StatefulWidget {
   final SessionSoutenanceModel session;
     EventScreen({required this.session});
 
  @override
  State<EventScreen> createState() => _EventScreenState();

  getEventsForDay(DateTime selectedDate) {}
}

class _EventScreenState extends State<EventScreen> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<SessionModel>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;

    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('Sessions')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
            fromFirestore: SessionModel.fromFirestore,
            toFirestore: (event, options) => event.ToFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List<SessionModel> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  void updateSelectedDate(DateTime newDate) {
    setState(() {
      _selectedDay = newDate;
    });
  }

  // Inside the build method of EventScreen
  Future<void> _navigateToAddEventScreen() async {
    final shouldReload = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEvent(
          firstDate: _firstDay,
          lastDate: _lastDay,
          selectedDate: _selectedDay,
          updateSelectedDate: updateSelectedDate,
            session:widget.session,
        ),
      ),
    );

    if (shouldReload ?? false) {
      _loadFirestoreEvents(); // Reload events if shouldReload is true
    }
  }

  Future<void> onDelete(SessionModel event) async {
    try {
      final delete = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Delete Event?"),
          content: const Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("Yes"),
            ),
          ],
        ),
      );
      if (delete ?? false) {
        await SessionService().deleteSession(event.id);
        _loadFirestoreEvents();
      }
    } catch (e) {
      print('onDelete Error: $e');
    }
  }

  Future<void> _redirectToSessionDetails(SessionModel session) async {
    final res = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditEvent(
          firstDate: _firstDay,
          lastDate: _lastDay,
          sessionModel: session,
          updateSelectedDate: updateSelectedDate,
        ),
      ),
    );
    if (res ?? false) {
      _loadFirestoreEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel? user = userProvider.user ?? null;

    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            eventLoader: _getEventsForTheDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _loadFirestoreEvents();
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              print(_events[selectedDay]);
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(
                color: Colors.red,
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.red,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(day.toString()),
                );
              },
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 6.0,
                ),
                itemCount: _getEventsForTheDay(_selectedDay).length,
                itemBuilder: (context, index) {
                  final event = _getEventsForTheDay(_selectedDay)[index];
                  return GestureDetector(
                    onTap: () async {
                      _redirectToSessionDetails(event);
                    },
                    child: EventItem(
                      event: event,
                      onDelete: () async {
                        onDelete(event);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: (user != null && user.role == 'admin')
          ? FloatingActionButton(
              onPressed: () async {
                _navigateToAddEventScreen();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
