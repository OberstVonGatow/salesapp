import 'package:flutter/material.dart';
import 'package:salesapp/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'E-Mail'),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Passwort'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => AuthService().emailLogin(
                          _nameController.text, _passwordController.text),
                      child: const Text('Login', textAlign: TextAlign.center),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
