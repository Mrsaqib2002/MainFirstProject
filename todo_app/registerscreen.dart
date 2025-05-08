import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class registerscreen extends StatefulWidget {
  final Function toggleView;

  registerscreen({required this.toggleView});

  @override
    State<registerscreen> createState() => registrationState();
}

class registrationState extends State<registerscreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool _securepassword = true;

  bool _isnotvalid = false;

  void registeruser() async {
    if (_formKey.currentState!.validate()) {
      var regbody = {
        "email": emailController.text,
        "password": passwordController.text,
      };
      try {
        var response = await http.post(
            Uri.parse('http://192.168.48.111:4000/registration'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regbody)
        );

        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['status']);

        if (jsonResponse['status']) {
          widget.toggleView();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonResponse['message'] ?? "Registration failed"))
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Network error: ${e.toString()}"))
        );
      }
    }
  }
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
                SizedBox(
                  height: 80,
                ),
                CircleAvatar(
                  radius: 100,
                  child: Image.asset("assets/img.png"),
                ),
                SizedBox(height: 25),

                Text(
                  'Sign Up',
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
                        )),
                  ),
                ),
                SizedBox(height: 25),

                // Sign Up Button

                InkWell(
                  onTap: () {
                    registeruser();
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
                        "Signup",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
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
                        'You have an account?',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
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
