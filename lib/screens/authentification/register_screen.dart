import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/customTextField.dart';

import '../../models/user_model.dart';
import '../../services/student_service.dart';

class RegisterScreen extends StatefulWidget {
  final Function visible;
  RegisterScreen(this.visible);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String generateUniqueId() {
    DateTime now = DateTime.now();
    String id = '${now.microsecondsSinceEpoch}';
    return id;
  }


  CustomTextField nomText =
      CustomTextField(title: 'Nom', placeholder: 'Entrer votre nom');
  CustomTextField emailText =
      CustomTextField(title: 'Email', placeholder: 'Votre adresse email');
  CustomTextField parcoursText =
      CustomTextField(title: 'parcours', placeholder: 'Votre Parcours');
  CustomTextField sessionCode = CustomTextField(
      title: 'Code de session', placeholder: 'Votre code de session');
  CustomTextField passText = CustomTextField(
      title: 'Mot de passe', placeholder: '*****', ispass: true);
  CustomTextField confirmPassText = CustomTextField(
      title: 'Confirmer mot de passe', placeholder: '*****', ispass: true);

  final StudentService studentService = StudentService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    emailText.error = "Veuillez remplir ce champ";
    passText.error = "Veuillez remplir ce champ";
    parcoursText.error = "Veuillez remplir ce champ";
    sessionCode.error = "Veuillez remplir ce champ";
    confirmPassText.error = "Veuillez remplir ce champ";

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Page d\' inscription',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  nomText.textFormField(),
                  const SizedBox(
                    height: 10,
                  ),
                  parcoursText.textFormField(),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Votre age',
                      labelText: 'age',
                      labelStyle: const TextStyle(color: Colors.redAccent),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  emailText.textFormField(),
                  const SizedBox(
                    height: 10,
                  ),
                  sessionCode.textFormField(),
                  const SizedBox(
                    height: 10,
                  ),
                  passText.textFormField(),
                  const SizedBox(
                    height: 10,
                  ),
                  confirmPassText.textFormField(),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String nom = nomText.value;
                      String parcours = parcoursText.value;
                      int age = int.tryParse(ageController.text) ?? 0;
                      String email = emailText.value;
                      String code = sessionCode.value;
                      String password = passText.value;
                      String confirmPassword = confirmPassText.value;

                      if (_key.currentState?.validate() ?? false) {
                        if (password == confirmPassword) {
                          // Vérifier le code de session dans Firebase
                          QuerySnapshot<Object?> sessionData =
                              await FirebaseFirestore.instance
                                  .collection('Session')
                                  .where('code', isEqualTo: code)
                                  .limit(1)
                                  .get();

                          if (sessionData.docs.isNotEmpty) {
                            // Utilisez userData.docs.isNotEmpty au lieu de sessionSnapshot.exists
                            UserModel student = UserModel(
                              id: generateUniqueId(), // Remplacez par l'ID de l'étudiant (vous pouvez générer un ID unique ici ou laisser vide si Firebase se chargera de le générer)
                              name: nom,
                              email: email,
                              age: age,
                              password: password,
                              role: 'student',
                              parcours: parcours,
                              code: code,
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
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => MyApp(),
                                          ),
                                        );
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Le code de session n'existe pas dans la base de données
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Code de session incorrect')),
                            );
                          }
                        } else {
                          // Les mots de passe ne correspondent pas
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Les mots de passe ne correspondent pas')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent.withOpacity(.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'S\' inscrire',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Avez-vous dejà un compte?'),
                      TextButton(
                        onPressed: widget.visible as void Function()?,
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
