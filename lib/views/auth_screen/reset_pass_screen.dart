import 'package:city_guide/utilities/widget_container/form_widget.dart';
import 'package:flutter/material.dart';

import '../../controller/auth_controller.dart';
import '../../utilities/widget_container/achievement_view.dart';

class ResetPassScreen extends StatelessWidget {
  ResetPassScreen({super.key});
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _resetpasscontroller = TextEditingController();

  // Form Key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Reset Password"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey, // Attach form key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: FormContainer(
                  controller: _resetpasscontroller,
                  hinttext: 'Email',
                  passwordfield: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    resetPass(context);
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
                        "Reset",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPass(BuildContext context) async {
    String resetpass = _resetpasscontroller.text;
    try {
      await _auth.resetPassword(resetpass, context);
      showAchievementView(
        context,
        message: 'Password reset email sent successfully!',
        title: 'Success',
        icon: Icons.check_circle,
      );
    } catch (e) {
      showAchievementView(
        context,
        message: e.toString(),
        title: 'Error',
        icon: Icons.dangerous,
      );
    }
  }
}
