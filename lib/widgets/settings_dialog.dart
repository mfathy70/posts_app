import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/constants/colors.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';
import 'manage_account_button.dart';

Future<void> dialogBuilder(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: thirdColor,
          title: Row(
            children: [
              Consumer<UserData>(
                  builder: ((context, userData, child) => Container(
                        padding: const EdgeInsets.fromLTRB(0, 5, 15, 5),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(userData.picUrl!),
                        ),
                      ))),
              Consumer<UserData>(
                  child: Container(),
                  builder: (context, userData, child) {
                    return Text(
                      userData.name!,
                      style: TextStyle(color: textColor),
                    );
                  }),
            ],
          ),
          content: Consumer<UserData>(
              builder: (context, userData, child) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('E-mail : ${userData.email}'),
                      ElevatedButton.icon(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          GoogleSignIn().signOut();
                          FacebookAuth.instance.logOut();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: textColor,
                        ),
                        label: Text(
                          'Sign out',
                          style: TextStyle(color: textColor),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(width: 1, color: textColor),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
        );
      });
}
