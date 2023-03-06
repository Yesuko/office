import 'package:firebase_auth/firebase_auth.dart';

class FireAuthService {
  static final _singleton = FireAuthService._internal();

  factory FireAuthService() {
    return _singleton;
  }

  FireAuthService._internal();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseAuth get ref => _auth;

  // initial confiiguration to indicate where to point to to access data for app
  
}
