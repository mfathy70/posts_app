import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/constants/colors.dart';
import 'package:login/main.dart';
import 'package:login/providers/user_data_provider.dart';
import 'package:login/screens/Profile_screen.dart';
import 'package:login/screens/home.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: mainColor,
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: textColor,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          NetworkImage(Provider.of<UserData>(context).picUrl!)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      Provider.of<UserData>(context).name!,
                      style: TextStyle(
                        color: thirdColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: TextStyle(
                        fontWeight: FontWeight.w300, color: thirdColor),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Home',
                    style: TextStyle(color: textColor),
                  ),
                  leading: Icon(
                    Icons.home_rounded,
                    color: textColor,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const HomePage())));
                  },
                ),
                ListTile(
                  title: Text(
                    'Profile',
                    style: TextStyle(color: textColor),
                  ),
                  leading: Icon(
                    Icons.person,
                    color: textColor,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "Logout",
                      style: TextStyle(color: textColor),
                    ),
                    leading: Icon(
                      Icons.logout_rounded,
                      color: textColor,
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) => main());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
