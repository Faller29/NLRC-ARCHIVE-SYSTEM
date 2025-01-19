import 'package:flutter/material.dart';
import 'package:nlrc_archive/data/themeData.dart';
import 'package:nlrc_archive/screens/home_page.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<LoginWidget> createState() => _logInWidgetPage();
}

class _logInWidgetPage extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in...')),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.7),
      elevation: 8.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Shimmer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 4,
                    child: TextFieldWidget(
                      controller: _usernameController,
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: _usernameController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _usernameController.clear();
                                });
                              },
                            )
                          : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 4,
                    child: TextFieldWidget(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _login(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent),
                    onPressed: _login,
                    child: Text(
                      'Log In',
                      style: txtBttBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
