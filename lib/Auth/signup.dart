import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/constants/colors.dart';
import '../widgets/text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  Future createAccount() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then(
        (_) async {
          await FirebaseFirestore.instance.collection('user_data').add({
            "email": emailController.text,
            "first_name": firstnameController.text,
            "last_name": lastnameController.text,
          }).then((value) async {
            await FirebaseAuth.instance.currentUser?.updatePhotoURL(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1200px-User-avatar.svg.png');
            await FirebaseAuth.instance.currentUser?.updateDisplayName(
                firstnameController.text + ' ' + lastnameController.text);
          });
          Navigator.of(context).pop();
        },
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
            height: 580,
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
                ],
              ),
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
                            'Sign up',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 38,
                            ),
                          )),
                    ],
                  ),
                  textfield(
                      controller: firstnameController,
                      label: 'First name',
                      secure: false),
                  textfield(
                      controller: lastnameController,
                      label: 'Last name',
                      secure: false),
                  textfield(
                      controller: emailController,
                      label: 'E-mail',
                      secure: false),
                  textfield(
                    controller: passwordController,
                    label: 'Password',
                    secure: true,
                  ),
                  SizedBox(height: 50),
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
                            'Sign up',
                            style: TextStyle(fontSize: 18, color: thirdColor),
                          ),
                          onPressed: () {
                            createAccount();
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
              const Text('Already have an account?'),
              TextButton(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: buttonColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void errorMessages({required String errorMessage, context}) {
  switch (errorMessage) {
    case 'unknown':
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter email and password')));
      break;
    case 'invalid-email':
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid email format!')));
      break;
    case 'weak-password':
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password should be at least 6 characters')));
      break;
    case 'email-already-in-use':
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'This email address is already in use by another account.')));
      break;
    default:
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error!')));
      break;
  }
}
