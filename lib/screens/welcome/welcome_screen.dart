import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';
import '../../utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/custom_button.dart';
import '../../models/user_model.dart'; // Replace with the actual file path

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel? user = userProvider.user ?? null;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue sur My defense!' + (user != null ? ' ${user.name}' : ''),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Voulez-vous voir les guides de l\'utilisation de cet Apps?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            Icon(
              Icons.school,
              size: 80,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  icon: Icons.play_arrow,
                  text: 'Tutoriel',
                  onPressed: () {
                    // Redirect to tutorial screen
                    // Add your navigation code here
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TutorialPage1()));
                  },
                ),
                SizedBox(width: 20),
                CustomButton(
                  icon: Icons.arrow_forward,
                  text: 'Ignorer',
                  onPressed: () {
                    redirectUserToHome(
                        user ??
                            UserModel(
                                id: 'id',
                                name: 'name',
                                email: 'email',
                                role: 'role',
                                password: 'password',
                                age: 2,
                                parcours: 'parcours',
                                code:'code',),

                        context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Les landingpage de l'homescreen

class TutorialPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(228, 86, 110, 1), Color.fromRGBO(232, 105, 55, 1)],                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Objectifs de l\'application',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                '.Planifiez les dates et les horaires des sessions soutenances.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '.Affectez les évaluateurs et les étudiants aux sessions.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '.Suivez les avancées et les résultats des soutenances.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: Colors.white, size: 10),
                  SizedBox(width: 10),
                  Icon(Icons.circle, color: Colors.grey.withOpacity(0.5), size: 10),
                  SizedBox(width: 10),
                  Icon(Icons.circle, color: Colors.grey.withOpacity(0.5), size: 10),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialPage2()));
                },
                child: Text('Suivant'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TutorialPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(228, 86, 110, 1), Color.fromRGBO(232, 105, 55, 1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Avantages de l\'application',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Découvrez les avantages et les bénéfices de cette application pour optimiser la gestion de vos soutenances.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: Colors.grey.withOpacity(0.5), size: 10),
                  SizedBox(width: 10),
                  Icon(Icons.circle, color: Colors.white, size: 10),                  
                  SizedBox(width: 10),
                  Icon(Icons.circle, color: Colors.grey.withOpacity(0.5), size: 10),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialPage3()));
                },
                child: Text('Suivant'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TutorialPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel? user = userProvider.user ?? null;  
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(228, 86, 110, 1), Color.fromRGBO(232, 105, 55, 1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Instructions d\'utilisation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Suivez les instructions pour tirer le meilleur parti de cette application dans la gestion de vos soutenances.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: Colors.grey.withOpacity(0.5), size: 10),
                  SizedBox(width: 10),
                  Icon(Icons.circle, color: Colors.grey.withOpacity(0.5), size: 10),
                  SizedBox(width: 10),
                  Icon(Icons.circle, color: Colors.white, size: 10),
                ],
              ),
              SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                        redirectUserToHome(
                        user ??
                            UserModel(
                                id: 'id',
                                name: 'name',
                                email: 'email',
                                role: 'role',
                                password: 'password',
                                age: 2,
                                parcours: 'parcours',
                                code:'code',),

                        context);              },
              child: Text('Commencer'),
            ),
            ],
          ),
        ],
      ),
    );
  }
}
