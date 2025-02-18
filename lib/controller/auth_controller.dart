import 'package:city_guide/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/auth_screen/login_screen.dart';
import '../utilities/widget_container/achievement_view.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signupWithEamilandPassword(String username, String email,
      String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // await _firestore.collection("Users").doc(_auth.currentUser!.uid).set(
      //     {"id": _auth.currentUser!.uid, 'name': username, "email": email});
      UserModel userModel = UserModel(
          uId: credential.user!.uid,
          username: username,
          email: email,
          isAdmin: false);

      await _firestore.collection('Users').doc(credential.user!.uid).set(userModel.toMap());
      Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));

      return credential.user;
    }  catch (e) {
      showAchievementView(context,
          title: 'Error',
          message: 'An unexpected error occurred: $e',
          icon: Icons.error_outline);
    }
    return null;
  }

  Future<User?> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).whenComplete(() {
        showAchievementView(context,
            message: 'Email sent Successfully',
            title: 'Success',
            icon: Icons.check);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showAchievementView(context,
            title: 'Error',
            message: 'No user found for this email.',
            icon: Icons.error_outline);
      } else {
        showAchievementView(context,
            title: 'Error',
            message: 'Error occurred: ${e.message}',
            icon: Icons.error_outline);
      }
    }
    return null;
  }

  Future<User?> signinWithEmailAndPassword(
      String email, String password, BuildContext context, ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showAchievementView(context,
            title: 'Alert',
            message: 'Invalid Email or Password.',
            icon: Icons.cancel_outlined);
      } else {
        return null;

      }
    }
    return null;
  }

  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate the user to the login screen or a welcome screen

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      // Handle sign-out error
      debugPrint("Error signing out: $e");
    }
  }
}
