import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/Auth/pass_reset.dart';
import 'package:login/Auth/signup.dart';
import 'package:login/constants/colors.dart';
import 'package:login/providers/user_data_provider.dart';
import 'package:login/widgets/facebook_button.dart';
import 'package:login/widgets/google_button.dart';
import 'package:login/widgets/text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future validateAndSubmit(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (firebaseAuthException) {
      errorMessages(errorMessage: firebaseAuthException.code, context: context);
      print(firebaseAuthException);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 500,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  color: mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ]),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 38,
                        ),
                      )),
                  const SizedBox(height: 20),
                  textfield(
                      controller: emailController,
                      label: 'E-mail',
                      secure: false),
                  textfield(
                    controller: passwordController,
                    label: 'Password',
                    secure: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ResetPassword()));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: SizedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: thirdColor),
                          ),
                          onPressed: () {
                            validateAndSubmit(context).then((value) => context
                                .read<UserData>()
                                .getUserDataFromUsername());
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      )),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Does not have account?'),
              TextButton(
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 18, color: buttonColor),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignUp()));
                },
              ),
            ],
          ),
          SizedBox(
            height: 276,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign in with',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [GoogleButton(), FacebookButton()],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void errorMessages({required String errorMessage, context}) {
  switch (errorMessage) {
    case 'unknown':
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
        ),
      );
      break;
    case 'user-not-found':
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There is no account registerd with this email'),
        ),
      );
      break;
    case 'wrong-password':
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong Password !'),
        ),
      );
      break;
    case 'invalid-email':
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email format.'),
        ),
      );
      break;
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error!'),
        ),
      );
      break;
  }
}
