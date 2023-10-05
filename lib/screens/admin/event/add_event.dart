import 'package:flutter/material.dart';
import '../../../components/pickers/date_picker.dart';
import '../../../components/pickers/time_picker.dart';
import '../../../models/sessionSoutenance.dart';
import '../../../services/session_service.dart';
import '../../../utils/random.dart';
import '../../../models/session_model.dart';

class AddEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime selectedDate;
  final Function(DateTime) updateSelectedDate;
  final SessionSoutenanceModel session;

  const AddEvent({
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.updateSelectedDate,
    required this.session,
  });

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  SessionService _sessionService = SessionService();
  bool _isLoaderVisible = false;

  DateTime currentDate = DateTime.now();
  DateTime selectedTime = DateTime.now();

  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _lcoationController = TextEditingController();

  @override
  void initState() {
    currentDate = widget.selectedDate;
    super.initState();
  }

  void updateCurrentDate(DateTime newDate) {
    setState(() {
      currentDate = newDate;
    });
    widget.updateSelectedDate(newDate);
  }

  void updateSelectedTime(DateTime newTime) {
    setState(() {
      selectedTime = newTime;
    });
  }

  @override
  void dispose() {
    _durationController.dispose();
    _lcoationController.dispose();
    super.dispose();
  }

  // create a function to validate the form and save the data
  void _saveEvent() async {
    try {
      final String duration = _durationController.text;
      final String location = _lcoationController.text;

      setState(() {
        _isLoaderVisible = true;
      });

      // check if the form is valid
      if (duration.isNotEmpty && location.isNotEmpty) {
        await _sessionService.addSession(SessionModel(
          id: RandomUtils.generateId(),
          title: '',
          date: currentDate,
          time: selectedTime.toString(),
          duration: double.parse(duration),
          location: location,
          emailStudent: '',
          notes: 0,
          note1: 0,
          note2: 0,
          note3: 0,
          comments1: '',
          comments2: '',
          comments3: '',
          code: widget.session.code,
        ));

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text(
                  'La session a été ajoutée avec succès à la base de données.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        setState(() {
          _isLoaderVisible = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        _isLoaderVisible = false;
      });

      print('AddEvent Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un évènement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatePicker(
                selectedDate: widget.selectedDate,
                updateSelectedDate: updateCurrentDate),
            SizedBox(height: 16),
            TimePicker(
                selectedTime: selectedTime,
                updateSelectedTime: updateSelectedTime),
            SizedBox(height: 16),
            Column(
              children: [
                // Ajoute un espace entre les widgets
                Text(
                  'Durée en heure',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Durée:   '),
                    Expanded(
                      child: TextField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Entrez la durée',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children: [
                // Ajoute un espace entre les widgets
                Text(
                  'Lieu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lieu:      '),
                    Expanded(
                      child: TextField(
                        controller: _lcoationController,
                        decoration: InputDecoration(
                          hintText: 'Entrez le lieu',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveEvent();
              },
              child: Text('Ajouter', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
