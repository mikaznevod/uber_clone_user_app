//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_project_uber_clone/Global/global_var.dart';
import 'package:test_project_uber_clone/Services/auth.dart';
import 'package:test_project_uber_clone/authentication/singup_screen.dart';
import 'package:test_project_uber_clone/home.dart';
import 'package:test_project_uber_clone/methods/CommonMethods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  //ref for the authservices class
  final AuthServices _auth = AuthServices();
  //form key
  final _formkey = GlobalKey<FormState>();
  //email password states
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assests/images/logo.png'),
            const Text(
              'Login to User\'s Account',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            //text fields
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        //email
                        TextFormField(
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 25,
                          decoration: const InputDecoration(
                            labelText: "Email address",
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          validator: (val) => val?.isEmpty == true
                              ? "Enter a valid email"
                              : null,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        //password
                        TextFormField(
                          controller: passwordTextEditingController,
                          obscureText: true,
                          maxLength: 25,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          validator: (val) => val?.isEmpty == true
                              ? "Enter a valid email"
                              : null,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        ElevatedButton(
                            onPressed: () async {
                              //    cMethods.checkConnectivity(context);
                              User? result = await _auth
                                  .loginUsingEmailPassword(email, password);
                              if (result != null) {
                                DatabaseReference usersRef = FirebaseDatabase
                                    .instance
                                    .ref()
                                    .child("users")
                                    .child(result.uid);
                                usersRef.once().then((snap) {
                                  if (snap.snapshot.value != null) {
                                    if ((snap.snapshot.value
                                            as Map)["blockStatus"] ==
                                        "no") {
                                      userName =
                                          (snap.snapshot.value as Map)["name"];

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => HomePage()));
                                    } else {
                                      _auth.SignOut();
                                      cMethods.displaySnackbar(
                                          "You are blocked by admin", context);
                                    }
                                  } else {
                                    cMethods.displaySnackbar(
                                        "Your data not loaded", context);
                                  }
                                });
                                //AIzaSyBRS6AS38mgij20Q2iPfLCgveSJEXpVEfs
                              } else {
                                _auth.SignOut();
                                cMethods.displaySnackbar(
                                    "Problem occured while login. Please try again",
                                    context);
                              }

                              // if (result == null) {
                              //   setState(() {
                              //     error =
                              //         "Could not signin with those credentials";
                              //   });
                              // } else {

                              // }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding: EdgeInsets.symmetric(horizontal: 80)),
                            child: const Text('Login')),
                        const SizedBox(
                          height: 30,
                        ),

                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding: EdgeInsets.symmetric(horizontal: 80)),
                            child: const Text('Google Login')),

                        //login in anonymously
                        ElevatedButton(
                            onPressed: () async {
                              dynamic result = await _auth.signInAnonymously();
                              if (result == Null) {
                                print('error in sign in anonymously ');
                              } else {
                                print('sign in anonymously ');
                                print(result.uid);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding: EdgeInsets.symmetric(horizontal: 80)),
                            child: const Text('Sign in Anonymously')),

                        //login ------> signUp button
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => SignUpScreen())));
                            },
                            child: const Text(
                              'Don\'t have an Account? SignUp Here',
                              style: TextStyle(color: Colors.grey),
                            )),

                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
