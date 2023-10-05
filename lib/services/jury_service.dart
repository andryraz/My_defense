import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/jury_model.dart';
import '../models/user_model.dart';
import '../utils/random.dart';

class JuryService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _jurysCollection =  FirebaseFirestore.instance.collection('Users');

  Future<void> addJury(UserModel jury) async {
    try {
      //final String password = RandomUtils.generatePassword();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: jury.email, password: jury.password);

      await _jurysCollection.doc(jury.id).set({
        'name': jury.name,
        'email': jury.email,
        'age': jury.age,
        'role': jury.role,
        'password': jury.password,
        'parcours': jury.parcours,
        'code': jury.code,
      });
    } catch (e) {
      print(' Error adding jury: $e');
    }
  }

// TODO: Ajout des champs si necessaire
  Stream<List<UserModel>> getJurys(code) {
    return _jurysCollection.where("role", whereIn: ["président", "rapporteur", "examinateur"]).where("code", isEqualTo: code).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel(
                id: doc.id,
                name: doc['name'],
                email: doc['email'],
                age: doc['age'],
                password: '',
                role: doc['role'],
                parcours: '',
                code: '',
              ))
          .toList();
    });
  }

  Stream<List<UserModel>> getJurysRole(code, role) {
    return _jurysCollection.where("role", isEqualTo: role).where("code", isEqualTo: code).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel(
        id: doc.id,
        name: doc['name'],
        email: doc['email'],
        age: doc['age'],
        password: '',
        role: doc['role'],
        parcours: doc['parcours'],
        code: '',
      ))
          .toList();
    });
  }

// TODO: A tester
  Future<void> updateJury(UserModel jury) async {
    await _jurysCollection.doc(jury.id).update({
      'name': jury.name,
      'email': jury.email,
      'age': jury.age,
    });
  }

  Future<void> deleteJury(String id) async {
    await _jurysCollection.doc(id).delete();
  }
}
