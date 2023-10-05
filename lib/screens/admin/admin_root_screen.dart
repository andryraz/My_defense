import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import '../../models/sessionSoutenance.dart';
import '../../main.dart';
import '../../services/auth_service.dart';
import '../admin/event/event_screen.dart';

import 'homePage_admin.dart';

class AdminRootScreen extends StatefulWidget {

  final SessionSoutenanceModel session;
  AdminRootScreen({required this.session});

  @override
  State<AdminRootScreen> createState() => _AdminRootScreenState();
}

class _AdminRootScreenState extends State<AdminRootScreen> {
  int _currentIndex = 0;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();

    // Initialize the _widgetOptions list here using the State's widget property
    _widgetOptions = [
      Index(session: widget.session), // Called when you press the "Home" icon // Called when you press the "Home" icon
      EventScreen(session: widget.session), // Called when you press the "Users" icon
      Text('Index 2: School'),
      Text('Index 4: Settings'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        //  automaticallyImplyLeading: false,
        title: CircleAvatar(
          radius: 20.0, // Ajustez la taille de l'avatar en conséquence
          backgroundImage: AssetImage('images/memory.png'), // Chemin de l'image dans les assets
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
            title: Text('Listes'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.event),
            title: Text('Planning'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          // BottomNavyBarItem(
          //   icon: Icon(Icons.bar_chart),
          //   title: Text(
          //     'resultat ',
          //   ),
          //   activeColor: Colors.pink,
          //   textAlign: TextAlign.center,
          // ),
          // BottomNavyBarItem(
          //   icon: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   activeColor: Colors.blue,
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
