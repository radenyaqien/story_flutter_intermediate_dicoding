import 'package:flutter/material.dart';
import 'package:storyflutter/ui/auth/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              RegisterForm()
            ],
          ),
        ),
      ),
    );
  }
}
