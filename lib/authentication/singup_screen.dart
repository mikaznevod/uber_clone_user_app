import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:test_project_uber_clone/Widgets/loading_dialog.dart';
import 'package:test_project_uber_clone/authentication/login_screen.dart';
import 'package:test_project_uber_clone/home.dart';
import 'package:test_project_uber_clone/methods/CommonMethods.dart';
import 'package:test_project_uber_clone/Services/auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneNumberTextEditingController =
      TextEditingController();
  CommonMethods cMethods = CommonMethods();
  final AuthServices _auth = AuthServices();

  String email = "";
  String username = "";
  String password = "";
  String phoneNumber = "";
  String error = "";

  signUpFormValidation() {
    if (userNameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackbar(
          "your name must be atleast 4 or more characters.", context);
    } else if (userPhoneNumberTextEditingController.text.trim().length < 9) {
      cMethods.displaySnackbar(
          "your name must be atleast 10 or more characters.", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackbar("please write valid email.", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackbar(
          "your password must be atleast 6 or more characters.", context);
    }
  }

  @override
  Widget build(BuildContext dcontext) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assests/images/logo.png'),
            const Text(
              'Create a User\'s Account',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            //text fields
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                child: Column(
                  children: [
                    //Username
                    TextFormField(
                      controller: userNameTextEditingController,
                      keyboardType: TextInputType.text,
                      maxLength: 25,
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      validator: (val) =>
                          val?.isEmpty == true ? "Enter a valid email" : null,
                      onChanged: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                    ),

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
                      validator: (val) =>
                          val?.isEmpty == true ? "Enter a valid email" : null,
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

                    //Password
                    TextFormField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      validator: (val) =>
                          val?.isEmpty == true ? "Enter a valid email" : null,
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
                      height: 10,
                    ),

                    //phone number
                    TextFormField(
                      controller: userPhoneNumberTextEditingController,
                      keyboardType: TextInputType.phone,
                      maxLength: 15,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      validator: (val) =>
                          val?.isEmpty == true ? "Enter a valid email" : null,
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    //SignUp with details
                    ElevatedButton(
                        onPressed: () async {
                          //  cMethods.checkConnectivity(context);
                          // signUpFormValidation();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => LoadingDialog(
                                messageText: "Wait till you registering"),
                          );
                          dynamic result = await _auth.registerWithDetails(
                              email, password, username, phoneNumber);

                          if (result == null) {
                            setState(() {
                              error = "Please enter the valid credentials";
                            });
                          } else {
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => HomePage()));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 80)),
                        child: const Text('Sign Up')),

                    const SizedBox(
                      height: 30,
                    ),

                    //google button
                    ElevatedButton(
                        onPressed: () {
                          // cMethods.checkConnectivity(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 80)),
                        child: const Text('Google Button')),

                    //Signup ---> Login toggle button
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const LoginScreen())));
                        },
                        child: const Text(
                          'Already have an Account? Login Here',
                          style: TextStyle(color: Colors.grey),
                        )),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
