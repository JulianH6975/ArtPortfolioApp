import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final AuthService _auth = AuthService();
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (isLogin) {
        // Perform login
        var result = await _auth.signIn(email, password);
        if (result != null) {
          // Navigate to home screen
          print("Logged in successfully");
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to log in. Please try again.')),
          );
        }
      } else {
        // Perform sign up
        var result = await _auth.signUp(email, password);
        if (result != null) {
          // Navigate to home screen
          print("Signed up successfully");
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to sign up. Please try again.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(isLogin ? 'Login' : 'Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(isLogin
                    ? 'Need an account? Sign Up'
                    : 'Have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
