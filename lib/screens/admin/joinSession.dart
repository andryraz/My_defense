import 'package:flutter/material.dart';
import '../../models/sessionSoutenance.dart';
import '../../screens/admin/admin_root_screen.dart';
import '../../services/sessionSoutenanceService.dart';

import '../../components/loader/loader.dart';

class joinSessionPage extends StatelessWidget {
  final SessionSoutenanceService sessionSoutenanceService = SessionSoutenanceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: AssetImage('images/memory.png'),
            ),
            Text(
              '             Session',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.redAccent)
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/session4.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<List<SessionSoutenanceModel>>(
                stream: sessionSoutenanceService.getSessionsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<SessionSoutenanceModel> sessions = snapshot.data!;
                    return ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              title: Text(
                                sessions[index].type,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              subtitle: Text(
                                sessions[index].annee.toString(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AdminRootScreen(session: sessions[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Une erreur est survenue');
                  } else {
                    return Loader();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


