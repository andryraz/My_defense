import 'package:flutter/material.dart';
import '../../models/customTextField.dart';
import '../../models/sessionSoutenance.dart';
import '../../screens/admin/student_detail_screen.dart';
import '../../models/user_model.dart';
import '../../services/student_service.dart';

class StudentList extends StatefulWidget {
  final SessionSoutenanceModel session;

  StudentList({required this.session});

  @override
  _CrudStudentListState createState() => _CrudStudentListState();
}

class _CrudStudentListState extends State<StudentList> {
  String generateUniqueId() {
    DateTime now = DateTime.now();
    String id = '${now.microsecondsSinceEpoch}';
    return id;
  }

  final StudentService studentService = StudentService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController parcoursController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  CustomTextField passText = CustomTextField(
      title: 'Mot de passe', placeholder: '*****', ispass: true);
  CustomTextField confirmPassText = CustomTextField(
      title: 'Confirmer mot de passe', placeholder: '*****', ispass: true);
  bool isSearchEmpty = true;
  String searchKeyword = '';

  void _sendSearchQuery() {
    if (searchKeyword.isNotEmpty) {
      // Mettez à jour l'interface utilisateur avec les résultats de la recherche
      // Par exemple, utilisez une ListView.builder pour afficher les résultats sous forme de cartes
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Résultats de la recherche'),
            content: StreamBuilder<List<UserModel>>(
              stream: studentService.searchStudents(
                  '${widget.session.code}', searchKeyword),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<UserModel> students = snapshot.data!;
                  if (students.isEmpty) {
                    return Center(
                      child: Text("Aucune résultat."),
                    );
                  }
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4, // Ajout d'une ombre pour la carte
                        color: Color.fromARGB(
                            255, 118, 189, 224), // Couleur de la carte
                        margin: EdgeInsets.all(16), // Espacement
                        child: ListTile(
                          // leading: Image.asset("assets/images/logo.png"),
                          title: Text(
                            students[index].name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            students[index].email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                color: Colors.white,
                                onPressed: () {
                                  // View student details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentDetailScreen(
                                        student: students[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Erreur lors de la recherche');
                } else {
                  return CircularProgressIndicator(); // Affichez un indicateur de chargement pendant la recherche
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Fermer'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listes des etudiants',
            style: TextStyle(color: Colors.redAccent)),
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
                    title: Text('Ajouter un etudiant'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Nom'),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          TextField(
                            controller: parcoursController,
                            decoration: InputDecoration(labelText: 'Parcours'),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Age'),
                          ),
                          SizedBox(height: 16),
                          passText.textFormField(),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          String nom = nameController.text.trim();
                          String parcours = parcoursController.text.trim();
                          int age = int.tryParse(ageController.text) ?? 0;
                          String email = emailController.text.trim();
                          String password = passText.value;

                          UserModel student = UserModel(
                            id: generateUniqueId(),
                            name: nom,
                            email: email,
                            age: age,
                            password: password,
                            role: 'student',
                            parcours: parcours,
                            code: '${widget.session.code}',
                          );

                          studentService.addStudent(student);

                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Étudiant enregistré'),
                                content: Text(
                                    'L\'étudiant a été enregistré avec succès.'),
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
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent.withOpacity(.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
            child: Text('Ajouter un étudiant'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              //Affichage etudiants
              stream: studentService.getStudents('${widget.session.code}'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<UserModel> students = snapshot.data!;
                  if (students.isEmpty) {
                    return Center(
                      child: Text("Il n'y a pas encore d'étudiants inscrits."),
                    );
                  }
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4, // Ajout d'une ombre pour la carte
                        color: Color.fromARGB(
                            255, 118, 189, 224), // Couleur de la carte
                        margin: EdgeInsets.all(16), // Espacement
                        child: ListTile(
                          // leading: Image.asset("assets/images/logo.png"),
                          title: Text(students[index].name),
                          subtitle: Text(students[index].email),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  // View student details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentDetailScreen(
                                        student: students[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showEditDialog(context, students[index]);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Afficher une boîte de dialogue de confirmation
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                            'Voulez-vous vraiment supprimer cet élément ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              studentService.deleteStudent(
                                                  students[index].id);
                                              Navigator.pop(
                                                  context); // Fermer la boîte de dialogue de confirmation
                                              // Afficher une boîte de dialogue de succès
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Suppression réussie'),
                                                    content: Text(
                                                        'L\'élément a été supprimé avec succès.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Fermer la boîte de dialogue de succès
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
          TextField(
            onChanged: (value) {
              setState(() {
                isSearchEmpty = value.isEmpty;
                searchKeyword = value; // Mettez à jour le mot-clé de recherche à chaque changement
              });
            },
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: isSearchEmpty
                  ? null
                  : InkWell(
                      // Utilisez InkWell pour rendre l'icône cliquable
                      onTap: () {
                        // Effectuez l'action souhaitée lorsque l'utilisateur clique sur l'icône
                        _sendSearchQuery();
                      },
                      child: Icon(Icons.send),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void _showEditDialog(BuildContext context, UserModel student) {
  TextEditingController idController = TextEditingController(text: student.id);
  TextEditingController nameController =
      TextEditingController(text: student.name);
  TextEditingController emailController =
      TextEditingController(text: student.email);
  TextEditingController ageController =
      TextEditingController(text: student.age.toString());

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

              UserModel student = UserModel(
                id: id,
                name: newName,
                email: newEmail,
                age: newAge,
                password: '',
                role: '',
                parcours: '',
                code: '',
              );
              StudentService studentService = StudentService();

              studentService.updateStudent(student);

              Navigator.pop(context);
            },
            child: Text('Enregistrer'),
          ),
        ],
      );
    },
  );
}
