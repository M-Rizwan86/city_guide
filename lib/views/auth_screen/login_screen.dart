import 'dart:async';

import 'package:city_guide/utilities/widget_container/achievement_view.dart';
import 'package:city_guide/views/User_panel/Main_page.dart';
import 'package:city_guide/views/admin_panel/admin_screen.dart';
import 'package:city_guide/views/auth_screen/reset_pass_screen.dart';
import 'package:city_guide/views/auth_screen/signup_screen.dart';
import 'package:flutter/material.dart';

import '../../controller/auth_controller.dart';
import '../../controller/user_controller.dart';
import '../../utilities/widget_container/form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final UserController userController = UserController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Global Key for Form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login Page"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey, // Attach the form key here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                FormContainer(
                  prefixicon: Icons.email,
                  controller: _emailController,
                  hinttext: 'Email',
                  passwordfield: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                FormContainer(
                  prefixicon: Icons.password,
                  controller: _passController,
                  hinttext: 'Password',
                  passwordfield: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // If validation passes, proceed with sign-in
                      signInFun();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(child: Text("Don't Have an account? ")),
                    InkWell(
                      child: const Text(
                        " create an Account",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(child: Text("Forget Password? ")),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPassScreen()));
                        },
                        child: const Text(
                          "Reset Password ",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInFun() async {
    String email = _emailController.text.trim();
    String password = _passController.text.trim();

    try {
      // Sign in using Firebase Authentication
      final user = await _auth.signinWithEmailAndPassword(
        email,
        password,
        context,
      );

      // Check if the user is successfully authenticated
      if (user != null) {
        // Check if the user is an admin
        if (email == "admin@gmail.com" && password == "admin123") {
          debugPrint("Admin is valid");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminScreen(),
            ),
            (route) => false,
          );
        } else {
          debugPrint("Regular user is valid");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
            (route) => false,
          );
        }
      } else {
        // Show error if authentication failed
        showAchievementView(
          context,
          message: "Invalid email or password",
          title: "Authentication Failed",
          icon: Icons.cancel_outlined,
        );
        _passController.clear();
      }
    } catch (e) {
      // Handle Errors (e.g., incorrect credentials, network issues)
      debugPrint("Error: $e");
      showAchievementView(
        context,
        message: e.toString(),
        title: "Error Occurred",
        icon: Icons.dangerous,
      );
    }
  }
}
