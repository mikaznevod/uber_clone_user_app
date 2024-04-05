import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project_uber_clone/Models/user_models.dart';
import 'package:test_project_uber_clone/authentication/authenticate.dart';
import 'package:test_project_uber_clone/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //the user data that the provider proides this can be a user data or can be null.
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}
