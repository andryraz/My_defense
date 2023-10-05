import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:My_Defense/components/loader/loader.dart';
import 'package:My_Defense/models/sessionSoutenance.dart';
import 'package:My_Defense/models/session_model.dart';
import 'package:My_Defense/models/user_model.dart';
import 'package:My_Defense/services/session_service.dart';
import 'package:intl/intl.dart';

import '../../services/auth_service.dart';
import '../../services/jury_service.dart';
import '../../services/sessionSoutenanceService.dart';
import 'noteStudent.dart';

class EventScreenStudent extends StatefulWidget {
  final Future<UserModel?> userFuture;

  EventScreenStudent({required this.userFuture});

  @override
  _EventScreenStudentState createState() => _EventScreenStudentState();
}

final SessionSoutenanceService sessionSoutenanceService =
    SessionSoutenanceService();

class _EventScreenStudentState extends State<EventScreenStudent> {
  late CollectionReference sessionsCollection;
  late String? userCode = null;
  late String userEmail;
  late String userName;
  late String userParcours;
  final TextEditingController _titleController = TextEditingController();
  final SessionService _sessionService = SessionService();
  final user = FirebaseAuth.instance.currentUser;
  final JuryService juryService = JuryService();
  late Future<UserModel?> _currentUserFuture;
  List<Widget> _widgetOptions = [];
  final AuthService _authService = AuthService();

  Color _getRandomColor() {
    final List<Color> colors = [
     Colors.redAccent
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
        userEmail = user.email;
        userName = user.name;
        userParcours = user.parcours;
        userCode = user.code;
        setState(() {}); // Triggers a rebuild after obtaining userCode
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getRandomColor();

    if (userCode != null) {
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

                      if (userEmail == session.emailStudent) {
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
                                        child: StreamBuilder<
                                            List<SessionSoutenanceModel>>(
                                          stream: sessionSoutenanceService
                                              .getSession(userCode),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List<SessionSoutenanceModel>
                                                  session = snapshot.data!;
                                              if (session.isEmpty) {
                                                return Center(
                                                  child: Text("Error."),
                                                );
                                              }
                                              return ListView.builder(
                                                itemCount: session.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(
                                                      'AVIS DE SOUTENANCE ${session[index].type.toUpperCase()}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  );
                                                },
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Parcours: ' + userParcours,
                                           style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                        'Titre: ' + session.title.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          // fontSize: 18, // Taille de police
                                          // // Souligné// Couleur du soulignage
                                          // decorationStyle: TextDecorationStyle.dotted, // Style du soulignage
                                          // letterSpacing: 1.5, // Espacement entre les lettres
                                          // // Style de police (italique)
                                          // shadows: [
                                          //   Shadow(
                                          //     color: Colors.grey,
                                          //     offset: Offset(2, 2),
                                          //     blurRadius: 3,
                                          //   ),
                                          // ], // Ombre du texte
                                        ),
                                      ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'Par: ' + userName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                          child: Text(
                                            'Membres de jury:',
                                            style: TextStyle(
                                            decoration: TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                               fontSize: 16, 
                                                fontStyle: FontStyle.italic,
                                            ),
                                             textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        StreamBuilder<List<UserModel>>(
                                          stream: juryService.getJurysRole(
                                              userCode,
                                              'président'), // Remplacez 'Président' par le rôle souhaité
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }

                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Erreur de chargement des données du jury.');
                                            }

                                            if (snapshot.hasData &&
                                                snapshot.data!.isNotEmpty) {
                                              List<UserModel> presidents =
                                                  snapshot.data!;
                                              String presidentsText = presidents
                                                  .map((jury) =>
                                                      '${jury.name}, ${jury.parcours}')
                                                  .join(', ');

                                              return Text(
                                                  'Président du jury: $presidentsText',  style: TextStyle(
                                             
                                              fontWeight: FontWeight.bold,
                                               
                                               
                                            ),);
                                            } else {
                                              return Text(
                                                  'Aucun Président du jury trouvé.');
                                            }
                                          },
                                        ),
                                        SizedBox(height: 5),
                                        StreamBuilder<List<UserModel>>(
                                          stream: juryService.getJurysRole(
                                              userCode,
                                              'examinateur'), // Remplacez 'Examinateur' par le rôle du membre du jury que vous souhaitez afficher
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }

                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Erreur de chargement des données du jury.');
                                            }

                                            if (snapshot.hasData &&
                                                snapshot.data!.isNotEmpty) {
                                              List<UserModel> examinateurs =
                                                  snapshot.data!;
                                              String examinateursText = examinateurs
                                                  .map((jury) =>
                                                      '${jury.name}, ${jury.parcours}')
                                                  .join(', ');

                                              return Text(
                                                  'Examinateurs: $examinateursText',  style: TextStyle(
                                             
                                              fontWeight: FontWeight.bold,
                                               
                                               
                                            ),);
                                            } else {
                                              return Text(
                                                  'Aucun Examinateur trouvé.');
                                            }
                                          },
                                        ),
                                        SizedBox(height: 5),
                                        StreamBuilder<List<UserModel>>(
                                          stream: juryService.getJurysRole(
                                              userCode,
                                              'rapporteur'), // Remplacez 'Rapporteur' par le rôle du membre du jury que vous souhaitez afficher
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }

                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Erreur de chargement des données du jury.');
                                            }

                                            if (snapshot.hasData &&
                                                snapshot.data!.isNotEmpty) {
                                              List<UserModel> rapporteurs =
                                                  snapshot.data!;
                                              String rapporteursText = rapporteurs
                                                  .map((jury) =>
                                                      '${jury.name}, ${jury.parcours}')
                                                  .join(', ');

                                              return Text(
                                                  'Rapporteurs: $rapporteursText',  style: TextStyle(
                                             
                                              fontWeight: FontWeight.bold,
                                               
                                               
                                            ),);
                                            } else {
                                              return Text(
                                                  'Aucun Rapporteur trouvé.');
                                            }
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Date: ' +
                                              DateFormat('dd-MM-yyyy')
                                                  .format(session.date), style: TextStyle(
                                             
                                              fontWeight: FontWeight.bold,
                                               
                                               
                                            ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Heure: ' +
                                              DateTime.parse(session.time)
                                                  .toLocal()
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')[1]
                                                  .substring(0, 5), style: TextStyle(
                                             
                                              fontWeight: FontWeight.bold,
                                               
                                               
                                            ),
                                        ), 
                                        SizedBox(height: 5),
                                        Text(
                                          'Lieu: ' +
                                              session.location.toString(),  style: TextStyle(
                                             
                                              fontWeight: FontWeight.bold,
                                               
                                               
                                            ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Durée: ' +
                                              session.duration.toString() +
                                              ' heures',  style: TextStyle(
                                             
                                              fontWeight: FontWeight.bold,
                                               
                                               
                                            ),
                                        ),
                                        SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  )
                : ListView.builder(
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

                      if (session.title?.isEmpty ?? true) {
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
                                        'Date: ' +
                                            DateFormat('dd-MM-yyyy')
                                                .format(session.date),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Heure: ' +
                                              DateTime.parse(session.time)
                                                  .toLocal()
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')[1]
                                                  .substring(0, 5),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Durée: ' +
                                              session.duration.toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Inscription'),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller: TextEditingController(
                                                            text: DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(session
                                                                    .date)),
                                                        decoration:
                                                            InputDecoration(
                                                                labelText:
                                                                    'Date'),
                                                        readOnly: true,
                                                      ),
                                                      SizedBox(height: 16),
                                                      TextField(
                                                        controller:
                                                            TextEditingController(
                                                          text: DateTime.parse(
                                                                  session.time)
                                                              .toLocal()
                                                              .toLocal()
                                                              .toString()
                                                              .split(' ')[1]
                                                              .substring(0, 5),
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                                labelText:
                                                                    'Heure'),
                                                        readOnly: true,
                                                      ),
                                                      TextField(
                                                        controller:
                                                            _titleController,
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                'Entrez votre thème',
                                                            labelText: 'Thème'),
                                                      ),
                                                      SizedBox(height: 16),
                                                    ],
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        String newTitle =
                                                            _titleController
                                                                .text
                                                                .trim();
                                                        String email =
                                                            userEmail; // Récupérer l'email de l'utilisateur

                                                        await _sessionService
                                                            .updateTitle(
                                                                sessionData.id,
                                                                newTitle,
                                                                email);

                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Inscription réussie'),
                                                              content: Text(
                                                                  'Une soutenance a bien été réservée.'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      'OK'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text('Valider'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Annuler'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('S\'inscrire'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
          },
        ),
        floatingActionButton: Tooltip(
          message: 'Voir mes notes',
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteStudent(userFuture: _currentUserFuture), // Index 2 correspond à NoteStudent dans _widgetOptions
                ),
              );
            },
            child: Icon(Icons.bar_chart),
          ),
        ),
      );
    } else {
      // Affichez une indication de chargement ou un message d'attente si userCode n'est pas encore initialisé.
      return Loader(); // Remplacez Loader() par le widget que vous souhaitez afficher en attendant l'initialisation de userCode.
    }
  }
}
