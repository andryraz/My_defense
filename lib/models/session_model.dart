import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  String id;
  String? title;
  DateTime date;
  String time;
  double duration;
  String location;
  String emailStudent;
  double notes;
  double note1;
  double note2;
  double note3;
  String? code;
  String comments1;
  String comments2;
  String comments3;
  SessionModel({
    required this.id,
    this.title,
    required this.date,
    required this.time,
    required this.duration,
    required this.location,
    required this.emailStudent,
    required this.notes,
    required this.note1,
    required this.note2,
    required this.note3,
    required this.comments2,
    required this.comments1,
    required this.comments3,
    required this.code,
  });
  factory SessionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return SessionModel(
      id: snapshot.id,
      title: data['title'] ?? '',
      date: data['date'].toDate(),
      time: data['time'] ?? '',
      duration: (data['duration'] ?? 0.0).toDouble(), // Utilise 0.0 comme valeur par défaut pour les doubles
      location: data['location'] ?? '',
      emailStudent: data['emailStudent'] ?? '',
      notes: (data['notes'] ?? 0.0).toDouble(), // Utilise 0.0 comme valeur par défaut pour les doubles
      note1: (data['note1'] ?? 0.0).toDouble(), // Utilise 0.0 comme valeur par défaut pour les doubles
      note2: (data['note2'] ?? 0.0).toDouble(), // Utilise 0.0 comme valeur par défaut pour les doubles
      note3: (data['note3'] ?? 0.0).toDouble(), // Utilise 0.0 comme valeur par défaut pour les doubles
      comments1: data['comments1'] ?? '',
      comments2: data['comments2'] ?? '',
      comments3: data['comments3'] ?? '',
      code: data['code'] ?? '',
    );
  }
  Map<String, Object?> ToFirestore() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'time': time,
      'duration': duration,
      'location': location,
      'emailStudent': emailStudent,
      'notes': notes,
      'note1': note1,
      'note2': note2,
      'note3': note3,
      'comments1': comments1,
      'comments2': comments2,
      'comments3': comments3,
      'code': code,
    };
  }

  Map<String, Object?> ToEditFirestore() {
    return {
      'id': id,
      'title': title,
      'date': Timestamp.fromDate(date),
      'time': time,
      'duration': duration,
      'location': location,
      'emailStudent': emailStudent,
      'notes': notes,
      'note1': note1,
      'note2': note2,
      'note3': note3,
      'comments1': comments1,
      'comments2': comments2,
      'comments3': comments3,
      'code': code,
    };
  }
}
