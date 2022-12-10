import 'package:flutter/material.dart';
import 'package:login/methods/facebook_login.dart';
import 'package:provider/provider.dart';
import '../Auth/login.dart';
import 'package:login/providers/user_data_provider.dart';

class FacebookButton extends StatelessWidget {
  const FacebookButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        signInWithFacebook().then(
            (value) => context.read<UserData>().getUserDataFromFacebook());
      },
      icon: Image.asset('assets/images/facebook.png', scale: 35),
      label: Text('Facebook',
          style:
              TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.all(10),
      ),
    );
  }
}
