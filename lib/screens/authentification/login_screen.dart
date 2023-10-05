import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/loader/loader.dart';
import '../../models/customTextField.dart';
import '../../main.dart';
import '../../services/auth_service.dart';
import '../../utils/navigation.dart';

class LoginScreen extends StatefulWidget {
  final Function visible;
  LoginScreen(this.visible);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoaderVisible = false;

  final AuthService _authService = AuthService();
  CustomTextField emailText =
      CustomTextField(title: 'Email', placeholder: 'Votre adresse email');
  TextEditingController controller = TextEditingController();
  bool isPasswordVisible =
      false; // Initialise l'état de la visibilité du mot de passe à false
  String searchKeyword = '';
  bool isSearchEmpty = true;

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    emailText.error = "Veuillez entrer votre adresse email";

    return Scaffold(
      body: Container(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Page d\' Authentification',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          emailText.textFormField(),
                          const SizedBox(
                            height: 10,
                          ),
                          // passText.textFormField(),

                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                isSearchEmpty = value.isEmpty;
                                searchKeyword =
                                    value; // Mettez à jour le mot-clé de recherche à chaque changement
                              });
                            },
                            controller: controller,
                            validator: (e) => e?.isEmpty ?? true
                                ? 'Veuillez entrer votre Mot de passe'
                                : null,
                            obscureText:
                                !isPasswordVisible, // Utilise l'état inversé pour définir obscureText
                            decoration: InputDecoration(
                              hintText: '*****',
                              labelText: 'Mot de passe',
                              labelStyle:
                                  const TextStyle(color: Colors.redAccent),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                              suffixIcon: isSearchEmpty
                                  ? null
                                  : InkWell(
                                      // Utilisez InkWell pour rendre l'icône cliquable
                                      onTap: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                      child: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String email = emailText.value;
                              String password = controller.text;

                              // Affiche le loader
                              setState(() {
                                _isLoaderVisible = true;
                              });

                              if (_key.currentState?.validate() ?? false) {
                                QuerySnapshot<Object?> loginData =
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .where('email', isEqualTo: email)
                                        .limit(1)
                                        .get();

                                if (loginData.docs.isNotEmpty) {
                                  User? user = await _authService
                                      .signInWithEmail(email, password);

                                  if (user != null) {
                                    // Gère la connexion réussie
                                    await handleLoggedInUser(true, context);
                                  } else {
                                    // Mot de passe incorrect
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Mot de passe incorrect. Veuillez réessayer.',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  // Adresse email n'existe pas dans la base de données
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Aucun utilisateur trouvé avec cet email. Veuillez vous inscrire.',
                                      ),
                                    ),
                                  );
                                }
                              }

                              // Masque le loader
                              setState(() {
                                _isLoaderVisible = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent.withOpacity(.7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Se connecter',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Avez-vous un compte?'),
                              TextButton(
                                onPressed: widget.visible as void Function()?,
                                child: const Text(
                                  'S\' inscrire',
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
            ],
          ),
          Visibility(child: Loader(), visible: _isLoaderVisible),
        ]),
      ),
    );
  }
}

void handleFirebaseError(BuildContext context, dynamic error) {
  String errorMessage =
      "Une erreur s'est produite lors de la connexion. Veuillez réessayer.";

  if (error is FirebaseAuthException) {
    if (error.code == 'user-not-found') {
      errorMessage = "Aucun utilisateur trouvé avec cet email.";
    } else if (error.code == 'wrong-password') {
      errorMessage = "Mot de passe incorrect pour cet utilisateur.";
    } else if (error.code == 'invalid-email') {
      errorMessage = "Format d'adresse email invalide.";
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
    ),
  );
}
