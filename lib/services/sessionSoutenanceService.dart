import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/sessionSoutenance.dart';

import '../models/session_model.dart';
import '../utils/random.dart';

class SessionSoutenanceService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _sessionSoutenanceCollection =
  FirebaseFirestore.instance.collection('Session');

  Future<void> addSession(SessionSoutenanceModel session) async {
    try {
      await _sessionSoutenanceCollection.add({
        'annee': session.annee,
        'type': session.type,
        'code': session.code,
      });
    } catch (e) {
      print('Error adding session: $e');
    }
  }

  // TODO: Ajout des champs si necessaire
  Stream<List<SessionSoutenanceModel>> getSessionsStream() {
    return _sessionSoutenanceCollection.snapshots().map((snapshot) {
      // Mapper les documents en objets SessionModel
      return snapshot.docs
          .map((doc) =>
          SessionSoutenanceModel(
            id: doc.id,
            annee: doc[
            'annee'],
            // Assurez-vous que 'annee' est du type attendu dans SessionModel
            type: doc[
            'type'],
            // Assurez-vous que 'type' est du type attendu dans SessionModel
            code: doc[
            'code'], // Assurez-vous que 'code' est du type attendu dans SessionModel
          ))
          .toList();
    });
  }

  Stream<List<SessionSoutenanceModel>> getSession(String? code) {
    return _sessionSoutenanceCollection
        .where("code", isEqualTo: code)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
          SessionSoutenanceModel(
            id: doc.id,
            annee: doc['annee'],
            type: doc['type'],
            code: doc['code'],
          ))
          .toList();
    });
  }
}