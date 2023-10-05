import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../components/pickers/date_picker.dart';
import '../../../components/pickers/time_picker.dart';
import '../../../services/session_service.dart';
import '../../../utils/auth.dart';
import '../../../utils/dates.dart';
import '../../../utils/random.dart';
import '../../../models/session_model.dart';

class EditEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final SessionModel sessionModel;
  final Function(DateTime) updateSelectedDate;

  const EditEvent({
    required this.firstDate,
    required this.lastDate,
    required this.sessionModel,
    required this.updateSelectedDate,
  });

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  SessionService _sessionService = SessionService();
  bool _isLoaderVisible = false;

  DateTime currentDate = DateTime.now();
  DateTime selectedTime = DateTime.now();

  late TextEditingController _durationController;
  late TextEditingController _lcoationController;
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late TextEditingController _note1Controller;
  late TextEditingController _note2Controller;
  late TextEditingController _note3Controller;
  late TextEditingController _comments1Controller;
  late TextEditingController _comments3Controller;
  late TextEditingController _comments2Controller;
  late TextEditingController _codeController;

  @override
  void initState() {
    currentDate = widget.sessionModel.date;
    _durationController = TextEditingController(
      text: widget.sessionModel.duration.toString(),
    );
    _lcoationController = TextEditingController(
      text: widget.sessionModel.location,
    );
    _titleController = TextEditingController(
      text: widget.sessionModel.title,
    );
    _notesController = TextEditingController(
      text: widget.sessionModel.notes.toString(),
    );
    _comments1Controller = TextEditingController(
      text: widget.sessionModel.comments1,
    );
    _comments2Controller = TextEditingController(
      text: widget.sessionModel.comments2,
    );
    _comments3Controller = TextEditingController(
      text: widget.sessionModel.comments3,
    );
    _codeController = TextEditingController(
      text: widget.sessionModel.code,
    );
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
    _titleController.dispose();
    _notesController.dispose();
    _comments1Controller.dispose();
    _comments2Controller.dispose();
    _comments3Controller.dispose();
    super.dispose();
  }

  // create a function to validate the form and save the data
  void _saveEvent() async {
    try {
      if (isAdmin(context)) {
        _editEvent();
      } else if (isStudent(context)) {
        _registerEvent();
      } else if (isTeacher(context)) {
        _noteEvent();
      }
    } on Exception catch (e) {
      setState(() {
        _isLoaderVisible = false;
      });

      print('EditEvent Error: $e');
    }
  }

  Future<void> _editEvent() async {
    final String duration = _durationController.text;
    final String location = _lcoationController.text;

    setState(() {
      _isLoaderVisible = true;
    });

    // check if the form is valid
    if (duration.isNotEmpty && location.isNotEmpty) {
      final res = SessionModel(
        id: widget.sessionModel.id,
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
        code: widget.sessionModel.code,
      );

      await _sessionService.updateSession(
        res,
      );

      setState(() {
        _isLoaderVisible = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('La session a été mise à jour avec succès.'),
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
    }
  }

  Future<void> _registerEvent() async {
    final String duration = _durationController.text;
    final String location = _lcoationController.text;
    final String title = _titleController.text;

    setState(() {
      _isLoaderVisible = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    // check if the form is valid
    if (user != null && duration.isNotEmpty && location.isNotEmpty) {
      final res = SessionModel(
        id: widget.sessionModel.id,
        title: title,
        date: currentDate,
        time: selectedTime.toString(),
        duration: double.parse(duration),
        location: location,
        emailStudent:
            user.uid, // Utiliser l'ID de l'utilisateur actuel s'il existe
        notes: 0,
        note1: 0,
        note2: 0,
        note3: 0,
        comments1: '',
        comments2: '',
        comments3: '',
        code: widget.sessionModel.code,
      );

      await _sessionService.updateSession(
        res,
      );

      setState(() {
        _isLoaderVisible = false;
      });

      Navigator.pop(context, true);
    } else {
      setState(() {
        _isLoaderVisible = false;
      });
      print("Utilisateur non connecté ou données manquantes");
    }
  }

  Future<void> _noteEvent() async {
    final String duration = _durationController.text;
    final String location = _lcoationController.text;
    final String title = _titleController.text;
    final String notes = _notesController.text;
    final String note1 = _note1Controller.text;
    final String note2 = _note2Controller.text;
    final String note3 = _note3Controller.text;
    final String comments1 = _comments1Controller.text;
    final String comments2 = _comments2Controller.text;
    final String comments3 = _comments3Controller.text;

    setState(() {
      _isLoaderVisible = true;
    });

    // check if the form is valid
    if (duration.isNotEmpty && location.isNotEmpty) {
      final res = SessionModel(
        id: widget.sessionModel.id,
        title: title,
        date: currentDate,
        time: selectedTime.toString(),
        duration: double.parse(duration),
        location: location,
        emailStudent: '',
        notes: double.parse(notes),
        note1: double.parse(note1),
        note2: double.parse(note2),
        note3: double.parse(note3),
        comments1: comments1,
        comments2: comments2,
        comments3: comments3,
        code: '',
      );

      await _sessionService.updateSession(
        res,
      );

      setState(() {
        _isLoaderVisible = false;
      });

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ('Modifier un evenement'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatePicker(
                enabled: isAdmin(context),
                selectedDate: widget.sessionModel.date,
                updateSelectedDate: updateCurrentDate),
            SizedBox(height: 16),
            TimePicker(
                enabled: isAdmin(context),
                selectedTime: DateUtil.parseDateTime(widget.sessionModel.time),
                updateSelectedTime: updateSelectedTime),
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
                          hintText: 'Entrez le lieu...',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                    Text('Lieu:       '),
                    Expanded(
                      child: TextField(
                        controller: _lcoationController,
                        decoration: InputDecoration(
                          hintText: 'Entrez le lieu...',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                // Ajoute un espace entre les widgets
                Text(
                  'Informations Sur le Soutenance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      DataTable(
                        columns: [
                          DataColumn(label: Text('Titre')),
                          DataColumn(label: Text('Note 1')),
                          DataColumn(label: Text('Note 2')),
                          DataColumn(label: Text('Note 3')),
                          DataColumn(label: Text('Total')),
                          DataColumn(label: Text('Mention')),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              TextField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  hintText: '',
                                ),
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: _notesController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: _notesController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: _notesController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: _notesController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            DataCell(Text('')),
                          ])
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                // Ajoute un espace entre les widgets
                Text(
                  'Commentaires du Président des Jury (1)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Note:   '),
                    Expanded(
                      child: TextField(
                        controller: _comments1Controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Vide',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                // Ajoute un espace entre les widgets
                Text(
                  'Commentaires de  l\' Examinateur (2)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Note:   '),
                    Expanded(
                      child: TextField(
                        controller: _comments2Controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Vide',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                // Ajoute un espace entre les widgets
                Text(
                  'Commentaires du Rapporteur (3)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Note:   '),
                    Expanded(
                      child: TextField(
                        controller: _comments3Controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Vide',
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
              child: Text('Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}
