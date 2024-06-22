// screens/auth_screen.dart
import 'package:flutter/material.dart';
import '../components/auth_form.dart';
import '../components/error_message.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_errorMessage != null) ErrorMessage(message: _errorMessage!),
              AuthForm(
                emailController: _emailController,
                passwordController: _passwordController,
                onError: (message) {
                  setState(() {
                    _errorMessage = message;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
