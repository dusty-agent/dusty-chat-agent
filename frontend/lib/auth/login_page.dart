import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  // 로그인 로직 작성
  Future<void> signIn(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 로그인 성공 시 프로필 페이지로 이동
      Navigator.pushReplacementNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message; // Set error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email Input Field
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText:
                    _errorMessage != null && !_isLoading ? _errorMessage : null,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),

            // Password Input Field
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText:
                    _errorMessage != null && !_isLoading ? _errorMessage : null,
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),

            // Login Button
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      // Validate input fields
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        setState(() {
                          _errorMessage = 'Please fill in all fields.';
                        });
                      } else if (!EmailValidator.validate(
                          emailController.text)) {
                        setState(() {
                          _errorMessage = 'Invalid email format.';
                        });
                      } else {
                        signIn(emailController.text.trim(),
                            passwordController.text.trim());
                      }
                    },
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Login'),
            ),

            SizedBox(height: 16),

            // Sign Up Redirect
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
