import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Méthode pour s'inscrire avec une adresse e-mail et un mot de passe
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      print("Erreur lors de l'inscription : $e");
      return null;
    }
  }

  // Méthode pour se connecter avec une adresse e-mail et un mot de passe
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      print("Erreur lors de la connexion : $e");
      return null;
    }
  }

  // Méthode pour recupérer l'utilisateur actuellement connecté avec ses informations dans firebase firestore
  Future<UserModel?> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Récupérer les données de l'utilisateur à partir de firestore ou l'email is test@test
        QuerySnapshot<Object?> userData = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        return UserModel(
          id: '',
          name: userData.docs[0].get('name'),
          email: user.email!,
          role: userData.docs[0].get('role'),
          age: 22,
          password: '',
          parcours: userData.docs[0].get('parcours'),
          code: userData.docs[0].get('code'),
        );
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
      return null;
    }
  }

  // Méthode pour se déconnecter
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Erreur lors de la déconnexion : $e");
    }
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    try {
      final User? user = _auth.currentUser;
      return user != null;
    } catch (e) {
      print("Error checking user login status: $e");
      return false;
    }
  }

}
