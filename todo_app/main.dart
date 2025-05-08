import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_app/Screen/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/loginscreen.dart';
import 'Screen/registerscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    // If token is null or empty, show login screen
    if (token == null || token!.isEmpty) {
      return loginscreen(toggleView: () {});
    }

    // Check if token is expired
    try {
      if (!JwtDecoder.isExpired(token!)) {
        return Dashboard(token: token!);
      } else {
        // Token expired - clear it and show login
        _clearToken();
        return loginscreen(toggleView: () {});
      }
    } catch (e) {
      // Handle invalid token format
      debugPrint('Token validation error: $e');
      _clearToken();
      return loginscreen(toggleView: () {});
    }
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: Container(
        height: 400,
        width: 350,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: Image.asset("assets/img.png"),
      ),
      nextScreen: AuthScreen(),
      // Changed to your actual home screen
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLoginScreen = true;

  void toggleView() {
    setState(() => showLoginScreen = !showLoginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          showLoginScreen
              ? loginscreen(toggleView: toggleView)
              : registerscreen(toggleView: toggleView),
    );
  }
}
