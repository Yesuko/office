import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final _singleton = FirestoreService._internal();

  factory FirestoreService() {
    return _singleton;
  }

  FirestoreService._internal();

  static final FirebaseFirestore _fb = FirebaseFirestore.instance;

  static FirebaseFirestore get ref => _fb;
}
