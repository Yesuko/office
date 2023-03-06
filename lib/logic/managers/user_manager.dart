import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office/databases/user_database.dart';
import 'package:office/logic/models/user_exception.dart';

import '../models/user.dart';

class UserManager extends ChangeNotifier {
  late CurrentUser _currentUser;
  CurrentUser get currentUser => _currentUser;

  Future<void> _fetchAndConvertToUserObject(String? uid) async {
    try {
      if (uid != null) {
        // set up details for employer and employee
        final Map<String, dynamic> data = await UserDatabase.fetchUserData(uid);

        _currentUser = CurrentUser.withAttributes(
          photoURL: data['photoUrl'],
          empId: data['empId'],
          department: data['department'],
          displayName: data['displayName'],
          uid: data['uid'],
          role: data['role'],
        );
        notifyListeners();
      } else {
        throw const UserManagementException("User data can't be found");
      }
    } catch (e) {
      if (e is UserDataException) {
        rethrow;
      } else {
        rethrow;
      }
    }
  }

  Future<CurrentUser> authenticateUser(
    String? email,
    String? password,
  ) async {
    try {
      User? user = UserDatabase.getCurrentlySignedInUser;
   

      if (user == null) {
       
        if (email != null && password != null) {
         
          user = await UserDatabase.signInUsingEmailPassword(
              email: email, password: password);
         
        }
      }

      await _fetchAndConvertToUserObject(user?.uid);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<CurrentUser> registerNewUser({
    required String displayName,
    required String email,
    required String password,
    required String department,
  }) async {
    try {
      User? user = await UserDatabase.registerAndSaveUserData(
          displayName: displayName,
          email: email,
          password: password,
          department: department);

      await _fetchAndConvertToUserObject(user?.uid);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInAndUpdateUserPassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      UserDatabase.signInAndUpdateUserPassword(
        newPassword: newPassword,
        oldPassword: oldPassword,
        email: email,
      );
    } catch (e) {
      if (e is UserDataException) {
        rethrow;
      } else {
        throw UserManagementException('$e');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await UserDatabase.signOut();
    } catch (e) {
      if (e is UserDataException) {
        rethrow;
      } else {
        throw UserManagementException('$e');
      }
    }
  }
}
