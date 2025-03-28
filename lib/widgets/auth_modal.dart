import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthModal extends StatefulWidget {
  final Function(String)? onLoginSuccess;

  const AuthModal({Key? key, this.onLoginSuccess}) : super(key: key);

  @override
  _AuthModalState createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _toggleFormMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _submitForm() async {
    // Form validation
    if (_usernameController.text.trim().isEmpty) {
      _showErrorSnackBar('Username is required');
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      _showErrorSnackBar('Password is required');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        // Login: Check if username and password match in Firestore
        final snapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: _usernameController.text.trim())
            .where('password', isEqualTo: _passwordController.text.trim())
            .get();

        if (snapshot.docs.isEmpty) {
          _showErrorSnackBar('Invalid username or password');
        } else {
          _showSuccessSnackBar('Login Successful');
          
          // Call the login success callback if provided
          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!(_usernameController.text.trim());
          }
          
          Navigator.pop(context); // Close modal after successful login
        }
      } else {
        // Signup: Check if username already exists
        final existingUser = await _firestore
            .collection('users')
            .where('username', isEqualTo: _usernameController.text.trim())
            .get();

        if (existingUser.docs.isNotEmpty) {
          _showErrorSnackBar('Username already exists');
          return;
        }

        // Save username and password in Firestore
        await _firestore.collection('users').add({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        _showSuccessSnackBar('Account Created Successfully');
        
        // Call the login success callback if provided
        if (widget.onLoginSuccess != null) {
          widget.onLoginSuccess!(_usernameController.text.trim());
        }
        
        Navigator.pop(context); // Close modal after successful signup
      }

      // Clear controllers
      _usernameController.clear();
      _passwordController.clear();
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isLogin ? 'Login' : 'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 24),

            // Username Field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              obscureText: _obscurePassword,
            ),
            SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _isLogin ? 'Login' : 'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            SizedBox(height: 16),

            // Toggle between Login and Signup
            TextButton(
              onPressed: _toggleFormMode,
              child: Text(
                _isLogin ? 'Create an Account' : 'Already have an account? Login',
                style: TextStyle(
                  color: Colors.green.shade800,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}