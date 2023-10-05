import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/student_model.dart';
import '../models/user_model.dart';
import '../utils/random.dart';

class StudentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference _sessionsCollection = FirebaseFirestore.instance.collection('Sessions');

  Future<void> addStudent(UserModel student) async {
    try {
      //final String password = RandomUtils.generatePassword();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: student.email, password: student.password);

      await _studentsCollection.doc(student.id).set({
        'name': student.name,
        'email': student.email,
        'age': student.age,
        'role': 'student',
        'password': student.password,
        'code': student.code,
        'parcours': student.parcours
      });
    } catch (e) {
      print(' Error adding student: $e');
    }
  }

  Stream<List<UserModel>> getStudents(code) {
    return _studentsCollection.where("role", isEqualTo: "student").where("code", isEqualTo: code).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel(
        id: doc.id,
        name: doc['name'],
        email: doc['email'],
        age: doc['age'],
        password: '',
        role: '',
        parcours: '',
        code: '',
      ))
          .toList();
    });
  }


  Future<void> updateStudent(UserModel student) async {
    await _studentsCollection.doc(student.id).update({
      'name': student.name,
      'email': student.email,
      'age': student.age,
    });
  }

  Future<void> deleteStudent(String id) async {
    await _studentsCollection.doc(id).delete();
  }

  Stream<List<UserModel>> searchStudents(String code, String searchKeyword) {
    return _studentsCollection
        .where("role", isEqualTo: "student")
        .where("name", arrayContains: searchKeyword)
        .where("code", isEqualTo: code)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel(
        id: doc.id,
        name: doc['name'],
        email: doc['email'],
        age: doc['age'],
        password: '',
        role: '',
        parcours: '',
        code: '',
      ))
          .toList();
    });
  }


}
