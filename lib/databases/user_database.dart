import 'package:firebase_auth/firebase_auth.dart';
import 'package:office/databases/services/fireauth_service.dart';
import 'package:office/databases/firestore_service.dart';
import 'package:office/logic/models/user_exception.dart';

class UserDatabase {
  static final _singleton = UserDatabase._internal();

  factory UserDatabase() {
    return _singleton;
  }

  UserDatabase._internal();

  static Future<Map<String, dynamic>> fetchUserData(String uid) async {
    try {
      return await FirestoreService.ref
          .collection('users')
          .doc(uid)
          .get()
          .then<Map<String, dynamic>>((value) => value.data()!);
    } on FirebaseException catch (e) {
      // int index = 0;
      // String? message = e.message;
      // if (message != null) {
      //   index = message.indexOf('.');
      //   message = message.substring(0, index + 1);
      // }

      throw UserDataException(e.message ?? e.code);
    }
  }

  static Future<void> saveUserData(user, department) async {
    try {
      Map<String, dynamic> update = {
        'uid': user.uid,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'department': department,
        'role': null,
        'empId': "",
      };

      await FirestoreService.ref.collection('users').doc(user.uid).set(update);
    } on FirebaseException catch (e) {
      throw UserDataException(e.code);
    }
  }

  static Future<void> signOut() async {
    try {
      await FireAuthService.ref.signOut();
    } catch (e) {
      throw UserDataException('$e');
    }
  }

  // check if user is already signed in
  static bool get userAlreadySignedIn =>
      FireAuthService.ref.currentUser != null;

  // get currently signed in user from local cache
  static User? get getCurrentlySignedInUser => FireAuthService.ref.currentUser;

  // For registering a new user
  static Future<User?> registerAndSaveUserData({
    required String displayName,
    required String email,
    required String password,
    required String department,
  }) async {
    try {
      UserCredential userCredential =
          await FireAuthService.ref.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload();
        user = getCurrentlySignedInUser!;

        // add user details to firestore
        await saveUserData(user, department);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw UserDataException(e.message ?? e.code);
    }
  }

  // signin function
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // trim inputs of trailing and leading white space;
      email = email.trim();
      password = password.trim();
     

      UserCredential userCredential =
          await FireAuthService.ref.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
     

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
     
      throw UserDataException(e.message ?? e.code);
    }
  }

  static Future<void> signInAndUpdateUserPassword({
    required String newPassword,
    required String oldPassword,
    required String email,
  }) async {
    try {
      User? user;

// as a security check, we signin user again using the email and old password
//to check if it is the owner of the account requesting for the update
      user = await signInUsingEmailPassword(
        email: email,
        password: oldPassword,
      );

// if code can't pass this codition, it implies error message from the
// signIn function would be returned.
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (e) {
      throw UserDataException(e.message ?? e.code);
    }
  }
}
