import 'package:flutter/material.dart';
import '../../models/sessionSoutenance.dart';
import '../../services/session_service.dart';
import 'jurys_screen.dart';
import 'student_detail_screen.dart';
import '../../models/user_model.dart';
import '../../services/student_service.dart';
import 'studentList.dart';

class Index extends StatelessWidget {

  final SessionSoutenanceModel session;

  Index({required this.session});

  final SessionService sessionService = SessionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            // width: double.infinity,
            // height: double.infinity,
            // color: Colors.redAccent,
             decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage('images/soutenance.jpg'), // Chemin de l'image dans les assets
          fit: BoxFit.cover,
          ),
        ),
            child: Center(
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Afficher les informations de session
                  Column(
  children: [
    Text(
      'Année: ${session.annee}',
      style: TextStyle(
        color: Colors.white, // Couleur du texte en blanc
        fontSize: 18, // Taille de la police
        fontWeight: FontWeight.bold, // Gras
      ),
    ),
    Text(
      'Type: ${session.type}',
      style: TextStyle(
        color: Colors.white, // Couleur du texte en blanc
        fontSize: 18, // Taille de la police
        fontWeight: FontWeight.bold, // Gras
      ),
    ),
    Text(
      'Code d\'entrée: ${session.code}',
      style: TextStyle(
        color: Colors.white, // Couleur du texte en blanc
        fontSize: 18, // Taille de la police
        fontWeight: FontWeight.bold, // Gras
      ),
    ),
    FutureBuilder<int>(
      future: sessionService.getNumberOfStudentsInSession('${session.code}'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            'Erreur: ${snapshot.error}',
            style: TextStyle(
              color: Colors.white, // Couleur du texte en blanc
              fontSize: 18, // Taille de la police
              fontWeight: FontWeight.bold, // Gras
            ),
          );
        } else {
          final int numberOfStudents = snapshot.data ?? 0;
          return Center(
            child: Text(
              'Nombre d\'étudiants inscrits : $numberOfStudents',
              style: TextStyle(
                color: Colors.white, // Couleur du texte en blanc
                fontSize: 18, // Taille de la police
                fontWeight: FontWeight.bold, // Gras
              ),
            ),
          );
        }
      },
    ),
  ],
),

                    // Espacement entre les informations de session et les boutons
                    SizedBox(height: 20),
                    // Boutons d'accès aux listes
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Color.fromARGB(255, 5, 12, 66),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StudentList(session: session),
                                ),
                              );
                            },
                            child: Text('Voir la liste des étudiants'),
                          ),
                          Spacer(),
                           SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Color.fromARGB(255, 5, 12, 66),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Juryscreen(session: session),
                                ),
                              );
                            },
                            child: const Text('Voir la liste des Jury'),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ]
              ),
            ),
          ),
        )
    );
  }
}


  
