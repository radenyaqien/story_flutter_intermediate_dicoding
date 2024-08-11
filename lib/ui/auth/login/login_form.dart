import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/ui/auth/provider/auth_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card.outlined(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              child: context.watch<AuthProvider>().isLoadingLogin
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Upload'),
            ),
          ],
        ),
      )),
    );
  }
}
