import 'package:flutter/material.dart';
import 'package:login/providers/user_data_provider.dart';
import 'package:provider/provider.dart';
import '../methods/google_login.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        signInWithGoogle()
            .then((value) => context.read<UserData>().getUserDataFromGoogle());
      },
      icon: Image.asset('assets/images/google.png', scale: 35),
      label: Text(
        'Google',
        style: TextStyle(
            color: Color.fromARGB(255, 3, 121, 218),
            fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.all(10),
      ),
    );
  }
}
