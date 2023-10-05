import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class juryDetailScreen extends StatelessWidget {
  final UserModel jury;

  juryDetailScreen({required this.jury});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information',  style: TextStyle(color: Colors.redAccent)),
      ),
     body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/session2.jpg'), // Chemin de votre image d'arrière-plan
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 25,
              right: 25,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'welcome',
                        //   style: TextStyle(
                        //     fontSize: 22,
                        //     color: const Color.fromRGBO(255, 255, 255, 1),
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // SizedBox(height: 5),
                        // Text(
                        //   student.name,
                        //   style: TextStyle(
                        //     fontSize: 22,
                        //     color: const Color.fromRGBO(255, 255, 255, 1),
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // SizedBox(height: 5,),
                        // Text(
                        //   student.role,
                        //   style: TextStyle(
                        //     fontSize: 22,
                        //     color: const Color.fromRGBO(255, 255, 255, 1),
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ],
                    ),
                    /**CircleAvatar(
                      child: Image.asset(
                        'assets/images/user-3331256_640.png',
                        fit: BoxFit.cover,
                      ),
                    ),**/
                  ],
                ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${jury.name}', style: TextStyle(
                     fontSize: 28,
                           color: const Color.fromRGBO(255, 255, 255, 1),
                           fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 8),
                  Text('Email: ${jury.email}', style: TextStyle(
                      fontSize: 28,
                           color: const Color.fromRGBO(255, 255, 255, 1),
                           fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 8),
                  Text('Age: ${jury.age}' ' ans', style: TextStyle(
                     fontSize: 28,
                           color: const Color.fromRGBO(255, 255, 255, 1),
                           fontWeight: FontWeight.bold,
                  ),),
                  ],
                  ),
                  ),
                  // Ajoutez d'autres détails que vous souhaitez afficher
                ],
              ),
            ),
          ],
      ),
    );
  }
}
