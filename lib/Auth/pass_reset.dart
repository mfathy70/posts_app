import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/constants/colors.dart';
import '../widgets/text_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();

  Future resetpassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim())
          .then(
            (value) => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: thirdColor,
                title: const Text('Reset Password'),
                content: const Text(
                    'A password reset link has been sent to your email, please check your inbox.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        color: buttonColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
    } on FirebaseAuthException catch (firebaseAuthException) {
      errorMessages(errorMessage: firebaseAuthException.code, context: context);
      print(firebaseAuthException);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 380,
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
                    Row(
                      children: [
                        IconButton(
                            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: textColor,
                              size: 30,
                            )),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(0, 30, 10, 10),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 30,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    textfield(
                      controller: emailController,
                      label: 'E-mail',
                      secure: false,
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
                              'Reset',
                              style: TextStyle(fontSize: 18, color: thirdColor),
                            ),
                            onPressed: () {
                              resetpassword();
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

void errorMessages({required String errorMessage, context}) {
  switch (errorMessage) {
    case 'unknown':
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email'),
        ),
      );
      break;
    case 'invalid-email':
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email format'),
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
  }
}
