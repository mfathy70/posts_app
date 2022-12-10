import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:login/constants/colors.dart';
import 'package:login/providers/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserData userData = UserData();
  bool showPassword = false;
  String imageUrl = " ";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.text = Provider.of<UserData>(context, listen: false).name!;
      emailController.text =
          Provider.of<UserData>(context, listen: false).email!;
    });
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      Reference ref = FirebaseStorage.instance.ref().child('profilepic.jpg');

      await ref.putFile(File(image!.path));
      ref.getDownloadURL().then((value) {
        print(value);
        setState(() {
          imageUrl = value;
          userData.updateUserProfileImage(imageUrl);
          FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
          print(FirebaseAuth.instance.currentUser?.photoURL);
        });
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<UserData>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: mainColor,
        title: const Text('Profile'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: textColor,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: textColor,
              )),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
          child: Column(
            children: [
              Center(
                child: Consumer<UserData>(
                  builder: (context, userData, child) => Stack(
                    children: [
                      GestureDetector(
                        onTap: () => pickImage(),
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 4,
                                blurRadius: 20,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 10),
                              )
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(userData.picUrl!),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: buttonColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 3,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              )),
                          child: Icon(
                            Icons.camera_enhance_rounded,
                            color: thirdColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              editProfileTextField(context, "Full Name",
                  Provider.of<UserData>(context).name!, nameController, false),
              editProfileTextField(
                  context,
                  "E-mail",
                  Provider.of<UserData>(context).email!,
                  emailController,
                  false),
              editProfileTextField(context, "Phone Number", 'ex: +201234567891',
                  phoneController, false),
              editProfileTextField(
                  context, "Password", "**********", passwordController, true),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 14, letterSpacing: 2.2, color: textColor),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        updateName();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: thirdColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateName() {
    FirebaseAuth.instance.currentUser!.updateDisplayName(nameController.text);
    userData.updateUserName(nameController.text);
    print(FirebaseAuth.instance.currentUser?.displayName);
  }

  Widget editProfileTextField(
      BuildContext context,
      String label,
      String placeholder,
      TextEditingController textEditingController,
      bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        controller: textEditingController,
        obscureText: isPassword ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: showPassword
                      ? const Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        )
                      : const Icon(Icons.remove_red_eye_outlined),
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }
}
