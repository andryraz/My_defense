import 'package:flutter/material.dart';
import '../../models/customTextField.dart';
import '../../models/sessionSoutenance.dart';
import 'jury_detail_screen.dart';
import '../../models/user_model.dart';
import '../../services/jury_service.dart';

class Juryscreen extends StatefulWidget {
  final SessionSoutenanceModel session;

  Juryscreen({required this.session});

  @override
  _JuryscreenState createState() => _JuryscreenState();
}

class _JuryscreenState extends State<Juryscreen> {
  String generateUniqueId() {
    DateTime now = DateTime.now();
    String id = '${now.microsecondsSinceEpoch}';
    return id;
  }

  final JuryService juryService = JuryService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController parcoursController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  CustomTextField passText = CustomTextField(
    title: 'Mot de passe',
    placeholder: '*****',
    ispass: true,
  );
  String selectedRole = ''; // Stocke le rôle sélectionné par l'utilisateur

  List<String> roleOptions = ['Président', 'Rapporteur', 'Examinateur'];
  // Fonction appelée lorsque l'utilisateur sélectionne une option de rôle
  void onRoleSelected(String? role) {
    setState(() {
      selectedRole = role ?? ''; // Si role est null, utilisez une chaîne vide
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listes des jurys', style: TextStyle(color: Colors.redAccent)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Ajouter un jury'),
                    content: SingleChildScrollView(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: parcoursController,
                          decoration: InputDecoration(labelText: 'Parcours'),
                        ),
                        SizedBox(height: 16),
                        passText.textFormField(),
                        TextField(
                          controller: roleController,
                          decoration: InputDecoration(labelText: 'Role'),
                        ),
                      ],
                    ),),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          String name = nameController.text.trim();
                          String email = emailController.text.trim();
                          int age = 0;
                          String parcours = parcoursController.text.trim();
                          String password = passText.value;
                          String role = roleController.text.trim();

                          UserModel jury = UserModel(
                            id: generateUniqueId(),
                            name: name,
                            email: email,
                            age: age,
                            password: password,
                            role: role,
                            parcours: parcours,
                            code: '${widget.session.code}',
                          );

                          juryService.addJury(jury);

                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Jury enregistré'),
                                content: Text(
                                    'Le jury a été enregistré avec succès.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Enregistrer'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Annuler'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Ajouter un jury'),
          ),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: juryService.getJurys('${widget.session.code}'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<UserModel> jurys = snapshot.data!;
                  if (jurys.isEmpty) {
                    return Center(
                      child: Text("Il n'y a pas encore de jury inscrits."),
                    );
                  }
                  return ListView.builder(
                    itemCount: jurys.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.all(16),
                        color: Colors.blue,
                        child: ListTile(
                          title: Text(
                            jurys[index].name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Text(
                                jurys[index].email,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                jurys[index].role,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => juryDetailScreen(
                                        jury: jurys[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.white,
                                onPressed: () {
                                  _showEditDialog(context, jurys[index]);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.white,
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, jurys[index]);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserModel jury) {
    TextEditingController idController = TextEditingController(text: jury.id);
    TextEditingController nameController = TextEditingController(text: jury.name);
    TextEditingController emailController = TextEditingController(text: jury.email);
    TextEditingController ageController = TextEditingController(text: jury.age.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name:'),
              TextField(
                controller: nameController,
              ),
              SizedBox(height: 16),
              Text('Email:'),
              TextField(
                controller: emailController,
              ),
              SizedBox(height: 16),
              Text('Age:'),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                String id = idController.text.trim();
                String newName = nameController.text.trim();
                String newEmail = emailController.text.trim();
                int newAge = int.tryParse(ageController.text) ?? 0;

                UserModel jury = UserModel(
                  id: id,
                  name: newName,
                  email: newEmail,
                  age: newAge,
                  password: '',
                  role: '',
                  parcours: '',
                  code: '',
                );
                JuryService juryService = JuryService();

                juryService.updateJury(jury);

                Navigator.pop(context);
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, UserModel jury) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer ce jury ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await juryService.deleteJury(jury.id);
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Suppression réussie'),
                      content: Text('Un jury a été supprimé avec succès.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }
}
