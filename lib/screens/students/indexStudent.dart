import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndexStudent extends StatelessWidget {
  final Future<UserModel?> userFuture;

  IndexStudent({required this.userFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.hasError || !userSnapshot.hasData || userSnapshot.data == null) {
            return Center(
              child: Text('Erreur lors de la récupération de l\'utilisateur'),
            );
          } else {
            UserModel currentUser = userSnapshot.data!;

            // Récupérer le champ de code de l'utilisateur
            String userCode = currentUser.code;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Session').where("code", isEqualTo: userCode).snapshots(),
              builder: (context, sessionSnapshot) {
                if (sessionSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!sessionSnapshot.hasData) {
                  return Center(
                    child: Text('Erreur lors de la récupération de la session'),
                  );
                } else {
                  // Supposons que vous vous attendez à un seul document correspondant
                  var sessionDocument = sessionSnapshot.data!.docs.first;
                  var sessionData = sessionDocument.data() as Map<String, dynamic>;

                  // Utilisez les valeurs de la session ici, par exemple :
                  String sessionValue = sessionData['type'];
                  int sessionDate = sessionData['annee'];

                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/soutenance.jpg'), // Remplacez le chemin par l'image souhaitée
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Nom de l\'étudiant : ${currentUser.name}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),  textAlign: TextAlign.center,
                          ),
                          Text(
                            'E-mail de l\'étudiant : ${currentUser.email}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'Parcours de l\'étudiant : ${currentUser.parcours}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'Session : $sessionValue',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'Année : $sessionDate',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          // ... Ajoutez plus d'éléments d'interface utilisateur ici si nécessaire
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
