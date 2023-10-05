// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/session_model.dart';

// class SessionService {
//   final CollectionReference _sessionCollection =
//   FirebaseFirestore.instance.collection('Sessions');

//   Future<void> addSession(SessionModel session) async {
//     try {
//       await _sessionCollection.doc().set(session.ToFirestore());
//     } catch (e) {
//       print(' Error adding session: $e');
//     }
//   }

//   Stream<List<SessionModel>> getSession() {
//     // Écoute les snapshots de la collection de sessions
//     return _sessionCollection.snapshots().map((snapshot) {
//       // Transforme chaque document snapshot en une liste d'objets SessionModel
//       return snapshot.docs.map((doc) {
//         return SessionModel(
//           id: doc.id,
//           title: doc['title'] ?? '',
//           date: doc['date'].toDate() ?? '',
//           time: doc['time'] ?? '',
//           duration: doc['duration'] ?? '',
//           location: doc['location'] ?? '',
//           emailStudent: doc['emailStudent'] ?? '',
//           notes: doc['notes'] ?? '',
//           comments1: doc['comments1'] ?? '',
//           comments2: doc['comments2'] ?? '',
//           comments3: doc['comments3'] ?? '',
//           code: doc['code'] ?? '',
//         );
//       }).toList();
//     });
//   }

//   Future<void> updateSession(SessionModel session) async {
//     try {
//       await _sessionCollection.doc(session.id).update(session.ToFirestore());
//     } catch (e) {
//       print('Error updating session: $e');
//     }
//   }

//   Future<void> deleteSession(String id) async {
//     try {
//       await _sessionCollection.doc(id).delete();
//     } catch (e) {
//       print('Error deleting session: $e');
//     }
//   }

//   Future<void> updateTitle(String sessionId, String newTitle, String email) async {
//     try {
//       await _sessionCollection.doc(sessionId).update({
//         'title': newTitle,
//         'emailStudent': email, // Ajoutez l'ID de l'étudiant à la session
//       });
//     } catch (e) {
//       print('Error updating title: $e');
//     }
//   }

// }

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/session_model.dart';

class SessionService {
  final CollectionReference _sessionCollection =
  FirebaseFirestore.instance.collection('Sessions');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> addSession(SessionModel session) async {
    try {
      await _sessionCollection.doc().set({
        ...session.ToFirestore(),
        'note1': session.note1 ?? 0.0,
        'note2': session.note2 ?? 0.0,
        'note3': session.note3 ?? 0.0,
    });
    } catch (e) {
      print(' Error adding session: $e');
    }
  }

  Stream<List<SessionModel>> getSession() {
    // Écoute les snapshots de la collection de sessions
    return _sessionCollection.snapshots().map((snapshot) {
      // Transforme chaque document snapshot en une liste d'objets SessionModel
      return snapshot.docs.map((doc) {
        return SessionModel(
          id: doc.id,
          title: doc['title'] ?? '',
          date: doc['date'].toDate() ?? '',
          time: doc['time'] ?? '',
          duration: doc['duration'] ?? 0,
          location: doc['location'] ?? '',
          emailStudent: doc['emailStudent'] ?? '',
          notes: doc['notes'] ?? '',
          note1: doc['note1'] ?? '',
          note2: doc['note2'] ?? '',
          note3: doc['note3'] ?? '',
          comments1: doc['comments1'] ?? '',
          comments2: doc['comments2'] ?? '',
          comments3: doc['comments3'] ?? '',
          code: doc['code'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> updateSession(SessionModel session) async {
    try {
      await _sessionCollection.doc(session.id).update(session.ToFirestore());
    } catch (e) {
      print('Error updating session: $e');
    }
  }

  Future<void> deleteSession(String id) async {
    try {
      await _sessionCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting session: $e');
    }
  }

  Future<void> updateTitle(String sessionId, String newTitle, String email) async {
    try {
      await _sessionCollection.doc(sessionId).update({
        'title': newTitle,
        'emailStudent': email, // Ajoutez l'ID de l'étudiant à la session
      });
    } catch (e) {
      print('Error updating title: $e');
    }
  }

  Future<void> updateNotesPresident(String sessionId, double notes, String comments) async {
    try {
      await _sessionCollection.doc(sessionId).update({
        'note1': notes,
        'comments1': comments, // Ajoutez le commentaire à la session
      });
    } catch (e) {
      print('Error updating notes: $e');
    }
  }

  Future<void> updateNotesRapporteur(String sessionId, double notes, String comments) async {
    try {
      await _sessionCollection.doc(sessionId).update({
        'note2': notes,
        'comments2': comments, // Ajoutez le commentaire à la session
      });
    } catch (e) {
      print('Error updating notes: $e');
    }
  }

  Future<void> updateNotesExaminateur(String sessionId, double notes, String comments) async {
    try {
      await _sessionCollection.doc(sessionId).update({
        'note3': notes,
        'comments3': comments, // Ajoutez le commentaire à la session
      });
    } catch (e) {
      print('Error updating notes: $e');
    }
  }

  Future<int> getNumberOfStudentsInSession(String sessionCode) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('Users')
          .where('code', isEqualTo: sessionCode)
          .where('role', isEqualTo: 'student')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération du nombre d\'étudiants: $e');
      return 0; // Gérer les erreurs ici
    }
  }

}