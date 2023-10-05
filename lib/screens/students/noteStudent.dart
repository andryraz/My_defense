import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/loader/loader.dart';
import '../../models/session_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import 'package:intl/intl.dart';

class NoteStudent extends StatefulWidget {
  final Future<UserModel?> userFuture;

  NoteStudent({required this.userFuture});

  @override
  _NoteStudentState createState() => _NoteStudentState();
}

class _NoteStudentState extends State<NoteStudent> {
  late CollectionReference sessionsCollection;
  late String? userCode = null;
  late String? userEmail = null;
  final user = FirebaseAuth.instance.currentUser;
  late Future<UserModel?> _currentUserFuture;
  List<Widget> _widgetOptions = [];
  final AuthService _authService = AuthService();

  Color _getRandomColor() {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.teal,
    ];
    final randomIndex = Random().nextInt(colors.length);
    return colors[randomIndex];
  }

  @override
  void initState() {
    super.initState();
    _currentUserFuture = _authService.getCurrentUser();
    sessionsCollection = FirebaseFirestore.instance.collection('Sessions');

    widget.userFuture.then((user) {
      if (user != null) {
        userCode = user.code;
        userEmail = user.email;
        setState(() {}); // Triggers a rebuild after obtaining userCode
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getRandomColor();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            sessionsCollection.where("code", isEqualTo: userCode).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Il n\' y a pas encore une session disponible'),
            );
          }

          final List<SessionModel> sessions =
              snapshot.data!.docs.map((sessionData) {
            return SessionModel(
              id: sessionData.id,
              title: sessionData['title'],
              date: (sessionData['date'] as Timestamp).toDate(),
              time: sessionData['time'],
              duration: sessionData['duration'].toDouble(),
              location: sessionData['location'],
              emailStudent: sessionData['emailStudent'],
             notes: sessionData['notes'].toDouble(),
              note1: sessionData['note1'].toDouble(),
              note2: sessionData['note2'].toDouble(),
              note3: sessionData['note3'].toDouble(),
              comments1: sessionData['comments1'],
              comments2: sessionData['comments2'],
              comments3: sessionData['comments3'],
              code: sessionData['code'],
            );
          }).toList();

          final bool hasMatchingSession =
              sessions.any((session) => userEmail == session.emailStudent);

          return hasMatchingSession
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final sessionData = snapshot.data!.docs[index];
                    final session = SessionModel(
                      id: sessionData.id,
                      title: sessionData['title'],
                      date: (sessionData['date'] as Timestamp).toDate(),
                      time: sessionData['time'],
                      duration: sessionData['duration'].toDouble(),
                      location: sessionData['location'],
                      emailStudent: sessionData['emailStudent'],
                      notes: sessionData['notes'].toDouble(),
              note1: sessionData['note1'].toDouble(),
              note2: sessionData['note2'].toDouble(),
              note3: sessionData['note3'].toDouble(),
                      comments1: sessionData['comments1'],
                      comments2: sessionData['comments2'],
                      comments3: sessionData['comments3'],
                      code: sessionData['code'],
                    );

                    if (session.notes != null &&
                        session.comments1.isNotEmpty &&
                        session.comments2.isNotEmpty &&
                        session.comments3.isNotEmpty &&
                        userEmail == session.emailStudent) {

                      double moyenne =
                          (session.note3 + session.note2 + session.note1) / 3;
                      String mention;

                      if (moyenne >= 16) {
                        mention = 'Très bien';
                      } else if (moyenne >= 14) {
                        mention = 'Bien';
                      } else if (moyenne >= 12) {
                        mention = 'Assez bien';
                      } else {
                        mention = 'Passable';
                      }

                      String moyenneArrondie = moyenne.toStringAsFixed(2);

                      return Card(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              margin: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Résultat de votre Soutenance',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            // Ajoute un espace entre les widgets
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: <Widget>[
                                                  DataTable(
                                                    columns: [
                                                      DataColumn(
                                                          label:
                                                              Text('Note 1')),
                                                      DataColumn(
                                                          label:
                                                              Text('Note 2')),
                                                      DataColumn(
                                                          label:
                                                              Text('Note 3')),
                                                      DataColumn(
                                                          label: Text('Total')),
                                                      DataColumn(
                                                          label:
                                                              Text('Mention')),
                                                    ],
                                                    rows: [
                                                      DataRow(cells: [

                                                        DataCell(
                                                          Text(
                                                            '${session.note1.toString()}',
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            '${session.note2.toString()}',
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            '${session.note3.toString()}',
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            '$moyenneArrondie / 20',
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                              '$mention'),
                                                        )
                                                      ])
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Commentaire du président du Jury (1): ' +
                                              session.comments1,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Commentaire de votre rapporteur (2): ' +
                                              session.comments2,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Commentaire de votre examinateur (3): ' +
                                              session.comments3,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    } else if(session.notes == null &&
                        session.comments1.isEmpty &&
                        session.comments2.isEmpty &&
                        session.comments3.isEmpty &&
                        userEmail == session.emailStudent){
                      return Card(
                        child: Center(
                          child: Text(
                              "Vous avez déjà inscrit, On attend la réponse du jury"),
                        ),
                      );
                    }
                    ;
                  },
                )
              : Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => _widgetOptions[1], // Index 2 correspond à NoteStudent dans _widgetOptions
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text:
                            "Veuillez-vous vous inscrire à une soutenance pour avoir une note",
                        style: TextStyle(
                          color: Colors.black, // Couleur du texte
                          fontSize: 16.0, // Taille du texte
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: " Inscription",
                            style: TextStyle(
                              color: Colors.blue, // Couleur du lien
                              decoration: TextDecoration
                                  .underline, // Soulignement du lien
                              fontSize: 16.0, // Taille du lien
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
