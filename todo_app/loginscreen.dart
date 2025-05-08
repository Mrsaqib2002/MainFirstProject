import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard.dart';

class loginscreen extends StatefulWidget {
  final Function toggleView;

  const loginscreen({super.key, required this.toggleView});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isnotvalid = false;
  bool _securepassword = false;
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initsherepref();
    });
  }

  Future<void> initsherepref() async {
    pref = await SharedPreferences.getInstance();
  }
  void _Login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final regbody = {
          "email": emailController.text.trim(),
          "password": passwordController.text,
        };

        // 1. Add timeout and proper error handling
        final response = await http.post(
          Uri.parse('http://192.168.48.111:4000/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regbody),
        ).timeout(Duration(seconds: 30));

        // 2. Better response parsing
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('Full response: $jsonResponse');

        // 3. Case-sensitive field check and null safety
        if (response.statusCode == 200 && (jsonResponse['Status'] == true || jsonResponse['status'] == true)) {
          final mytoken = jsonResponse['token'] as String;
          debugPrint('Token received: $mytoken');

          // 4. Ensure SharedPreferences is ready
          await pref.setString('token', mytoken);

          // 5. Proper navigation with context check
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => Dashboard(token: mytoken)),
                  (route) => false,
            );
          }
        } else {
          // 6. Better error feedback
          final errorMsg = jsonResponse['message'] ??
              jsonResponse['Message'] ??
              'Login failed (Status: ${jsonResponse['Status'] ?? jsonResponse['status']})';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg)),
          );
        }
      } on TimeoutException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection timeout')),
        );
      } catch (e) {
        debugPrint('Login error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  // void _Login() async {
  //   if (_formKey.currentState!.validate()) {
  //     final regbody = {
  //       "email": emailController.text.trim(),
  //       "password": passwordController.text,
  //     };
  //
  //     try {
  //       final response = await http.post(
  //         Uri.parse('http://10.0.2.2:4000/login'),
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode(regbody),
  //       ).timeout(const Duration(seconds: 5));
  //
  //       final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
  //       debugPrint('Full Response: $jsonResponse');
  //       debugPrint('Status Code: ${response.statusCode}');
  //
  //       if (response.statusCode == 200) {
  //         if (jsonResponse['status'] == true) {
  //           final mytoken = jsonResponse['token'] as String;
  //
  //           debugPrint('Token received: $mytoken'); // Debug print
  //
  //           await pref.setString("token", mytoken);
  //
  //           debugPrint('Before navigation');
  //
  //           Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (context) => Dashboard(token: mytoken)),
  //                 (route) => false,
  //           );
  //           debugPrint('After navigation');
  //           debugPrint("Token Length: ${mytoken.length}");
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text(jsonResponse['message'] ?? "Login failed")),
  //           );
  //         }
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Server error: ${response.statusCode}")),
  //         );
  //       }
  //     } on TimeoutException {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Request timeout")),
  //       );
  //     } catch (e) {
  //       debugPrint('Error during login: $e'); // Debug print
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error: ${e.toString()}")),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                CircleAvatar(radius: 100, child: Image.asset("assets/img.png")),
                SizedBox(height: 25),

                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                // Email Field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    errorText: _isnotvalid ? "Enter UserName" : null,
                    errorStyle: TextStyle(
                      // <-- Yeh error style customize karega
                      color: Colors.red,
                      fontSize: 16, // Font size badhayein
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  //   validator: (val) => val!.isEmpty ? 'Enter email' : null,
                ),
                SizedBox(height: 15),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    errorText: _isnotvalid ? "Enter Password" : null,
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 16, // Font size badhayein
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _securepassword = !_securepassword;
                        });
                      },
                      icon: Icon(
                        _securepassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFF2F0F6D),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Sign Up Button
                InkWell(
                  onTap: () {
                    _Login();
                  },
                  child: Container(
                    height: 55,
                    width: 380,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                        "SignIn",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Switch to Sign In
                TextButton(
                  onPressed: () => widget.toggleView(),
                  child: Row(
                    children: [
                      Text(
                        'Do Not have an account?',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
