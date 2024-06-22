// components/auth_form.dart
import 'package:flutter/material.dart';
import '../components/hover_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(String) onError;

  const AuthForm({
    required this.emailController,
    required this.passwordController,
    required this.onError,
  });

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _trySubmit(bool isLogin) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (isLogin) {
          // Handle login
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: widget.emailController.text,
            password: widget.passwordController.text,
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Handle registration
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: widget.emailController.text,
            password: widget.passwordController.text,
          );
          Navigator.pushReplacementNamed(context, '/home');
        }
      } on FirebaseAuthException catch (e) {
        widget.onError(e.message ?? 'An error occurred');
      }
    } else {
      widget.onError('Invalid form');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: widget.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.blue),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: widget.passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.blue),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: HoverButton(
                  onPressed: () => _trySubmit(false),
                  child: Text('Register', textAlign: TextAlign.center),
                ),
              ),
              SizedBox(width: 10), // Space between buttons
              Expanded(
                child: HoverButton(
                  onPressed: () => _trySubmit(true),
                  child: Text('Login', textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
