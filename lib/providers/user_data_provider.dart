import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserData with ChangeNotifier {
  String? name = FirebaseAuth.instance.currentUser?.displayName;
  String? picUrl = FirebaseAuth.instance.currentUser?.photoURL;
  String? email = FirebaseAuth.instance.currentUser?.email;
  String? id = FirebaseAuth.instance.currentUser?.uid;

  void updateUserName(final String updateName) {
    name = updateName;
    notifyListeners();
  }

  void updateUserProfileImage(final String url) {
    picUrl = url;
    notifyListeners();
  }

  void getUserDataFromFacebook() async {
    final userData = await FacebookAuth.instance.getUserData();
    print(userData);
    name = userData['name'];
    name = name;

    picUrl = userData['picture']['data']['url'];
    FirebaseAuth.instance.currentUser?.updatePhotoURL(picUrl);

    email = userData['email'];

    id = userData['id'];

    notifyListeners();
  }

  void getUserDataFromUsername() async {
    email = FirebaseAuth.instance.currentUser?.email;
    final querySnapshot = await FirebaseFirestore.instance
        .collection("user_data")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    print("email $email");
    String userFirstName = querySnapshot.docs[0].data()['first_name'];
    String userLastName = querySnapshot.docs[0].data()['last_name'];
    name = "$userFirstName $userLastName";
    picUrl = FirebaseAuth.instance.currentUser?.photoURL;
    id = FirebaseAuth.instance.currentUser?.uid;
    notifyListeners();
  }

  void getUserDataFromGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();

    final userName = googleUser?.displayName!;
    final profileUrl = googleUser?.photoUrl!;
    final userEmail = googleUser?.email;
    final userId = googleUser?.id;

    picUrl = profileUrl!;
    FirebaseAuth.instance.currentUser?.updatePhotoURL(picUrl);

    name = userName!;

    email = userEmail!;

    id = userId;

    notifyListeners();
  }
}
