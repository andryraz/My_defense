// import 'package:flutter/material.dart';
// import 'package:My_Defense/models/sessionSoutenance.dart';
// import 'package:My_Defense/services/sessionSoutenanceService.dart';

// class IndexTeacher extends StatefulWidget {
//   const IndexTeacher({Key? key}) : super(key: key);

//   @override
//   State<IndexTeacher> createState() => _IndexTeacherState();
// }

// class _IndexTeacherState extends State<IndexTeacher> {
//   final SessionSoutenanceService sessionSoutenanceService =
//       SessionSoutenanceService();
//   bool _dataLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   void _loadData() async {
//     await sessionSoutenanceService.getSessionsStream().first;
//     setState(() {
//       _dataLoaded = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//           image: AssetImage('images/learning.jpg'),  // Replace with your image path
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: _dataLoaded
//               ? Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Nom: Koto',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 24,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Role: President',
//                         style: TextStyle(
//                           fontSize: 24,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Email: koto@gmail.com',
//                         style: TextStyle(
//                           fontSize: 24,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndexTeacher extends StatelessWidget {
  final Future<UserModel?> userFuture;

  IndexTeacher({required this.userFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: userFuture,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (userSnapshot.hasError || !userSnapshot.hasData || userSnapshot.data == null) {
          return Text('Erreur lors de la récupération de l\'utilisateur');
        } else {
          UserModel currentUser = userSnapshot.data!;

          // Récupérer le champ de code de l'utilisateur
          String userCode = currentUser.code;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Session').where("code", isEqualTo: userCode).snapshots(),
            builder: (context, sessionSnapshot) {
              if (sessionSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (!sessionSnapshot.hasData) {
                return Text('Erreur lors de la récupération de la session');
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
                        Text('Nom : ${currentUser.name}',  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        Text('E-mail : ${currentUser.email}',  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        Text('Fonction : ${currentUser.parcours}',  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        Text('Role : ${currentUser.role}',  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        Text('Valeur de la session : $sessionValue',  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        Text('Annee : $sessionDate',  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
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
    );
  }
}
