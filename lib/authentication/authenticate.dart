import 'package:flutter/material.dart';
import 'package:test_project_uber_clone/authentication/login_screen.dart';
import 'package:test_project_uber_clone/authentication/singup_screen.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
