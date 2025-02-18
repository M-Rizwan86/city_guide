import 'package:city_guide/controller/auth_controller.dart';
import 'package:city_guide/utilities/widget_container/achievement_view.dart';
import 'package:city_guide/views/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';

import '../../utilities/widget_container/form_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();

  // Global Key for Form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Signup Page"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey, // Attach the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Signup",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                FormContainer(
                  prefixicon: Icons.person,
                  controller: _namecontroller,
                  hinttext: 'Name',
                  passwordfield: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                FormContainer(
                  prefixicon: Icons.email,
                  controller: _emailcontroller,
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
                  controller: _passcontroller,
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
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // Only proceed if form validation passes
                      signupFun();
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
                          "Signup",
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
                    const Center(child: Text("Already have an account? ")),
                    InkWell(
                      child: const Text(
                        " Sign In",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                                (route) => false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signupFun() async {
    String name = _namecontroller.text;
    String email = _emailcontroller.text;
    String password = _passcontroller.text;

    await _auth.signupWithEamilandPassword(name, email, password, context).whenComplete((){
      showAchievementView(context, message: 'Login to continue', title: "please", icon: Icons.check);
    });
  }
}
