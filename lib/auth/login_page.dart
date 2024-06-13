import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginui/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import http package for making HTTP requests

class LoginPage extends StatefulWidget {
  final void Function() showRegisterPage;

  LoginPage({required this.showRegisterPage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _nameErrorText;
  String? _passwordErrorText;

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.11:3000/api/userl'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'teacherName': _nameController.text.trim(),
            'password': _passwordController.text.trim(),
          }),
        );

        if (response.statusCode == 200) {
          // Parse response to extract user ID
          final Map<String, dynamic> responseData = json.decode(response.body);
          final String userId = responseData['teacherId'].toString();

          // Store user ID using SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', userId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                  child: Text(
                'Login successful',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 1),
            ),
          );
          print('registration: ${response.body}');
        } else {
          print('Unsuccessful login');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: Text('Incorrect username or password')),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Handle exceptions
        print('Exception occurred: $e');
      }
    }
  }

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage('assets/images/1c2246e84f2ded5db9d752acd29d357c.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  // Add the logos
                  Image.asset(
                    'assets/images/dc0a724fcd5fcec5a49c2c53f3e52b5d-removebg-preview.png', // Replace with your logo path
                    height: 250, // Adjust the height as needed
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Add the "Log In" text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Log In',
                        style: GoogleFonts.aladin(
                          fontSize: 35, // Set the desired font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        errorText: _nameErrorText,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            _nameErrorText = 'Please enter your name';
                          });
                          return _nameErrorText;
                        } else {
                          setState(() {
                            _nameErrorText = null;
                          });
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      //textAlign: TextAlign.center,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password...',
                        errorText: _passwordErrorText,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        border: InputBorder.none,
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: Icon(obscureText
                                ? Icons.visibility_off
                                : Icons.visibility)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            _passwordErrorText = 'Please enter your password';
                          });
                          return _passwordErrorText;
                        } else {
                          setState(() {
                            _passwordErrorText = null;
                          });
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        width: 130,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: Text(
                          '  Register now',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
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
