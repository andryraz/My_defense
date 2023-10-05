import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../screens/students/event_screen_student.dart';
import '../../screens/teacher/EventTeacher.dart';
import '../../screens/teacher/indexTeacher.dart';
import '../../services/auth_service.dart';
import '../../services/student_service.dart';
import '../../main.dart';

import '../admin/event/event_screen.dart';
import '../students/indexStudent.dart';
import '../students/planningStudent.dart';
import '../students/noteStudent.dart';

class TeacherHomeScreen extends StatefulWidget {
  final String title;
  final List<String> items;

  TeacherHomeScreen({required this.title, required this.items});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  int _currentIndex = 0;
  int _counter = 0;
  late Future<UserModel?> _currentUserFuture;
  late List<Widget> _widgetOptions; // Declare the list without initialization

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _currentUserFuture = _authService.getCurrentUser();

    // Initialize _widgetOptions after _currentUserFuture is assigned
    _widgetOptions = <Widget>[
      IndexTeacher(userFuture: _currentUserFuture),
      EventScreenTeacher(userFuture: _currentUserFuture),
    ];
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0, 
              backgroundImage: AssetImage('images/memory.png'),// Ajustez la taille de l'avatar en // Chemin de l'image dans les assets
            ),
            SizedBox(width: 30), // Add some spacing between avatar and title
      Text(
        'Jury', // Replace with your desired title
        style: TextStyle(fontSize: 24, color: Colors.redAccent), // Adjust the font size as needed
      ),
          ],
        ),
        actions: [
          // Bouton de déconnexion dans l'app bar
          IconButton(
            icon: Row(
              children: [
                Icon(Icons.exit_to_app),
                SizedBox(width: 4),
                Text('Déconnexion'),
              ],
            ),
            onPressed: () => {
              _authService.signOut(),
              // use material page route to redirect to the sign in screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              ),
            },
          ),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_currentIndex)),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('A propos'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.event),
            title: Text('Planning'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class Resultpage extends StatelessWidget {
  const Resultpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}