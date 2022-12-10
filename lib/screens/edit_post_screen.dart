import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/constants/colors.dart';

class EditPostScreen extends StatefulWidget {
  final String post;
  final String postId;
  const EditPostScreen({
    super.key,
    required this.post,
    required this.postId,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  TextEditingController postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    postController.text = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: textColor,
            )),
        title: const Text('Edit Post'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                label: Text('Post Content'),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 33, 82),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 33, 82),
                  ),
                ),
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 33, 82),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .update({'post': postController.text}).then(
                      (value) => Navigator.pop(context));
            },
            style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
            child: Text(
              'Edit',
              style: TextStyle(color: thirdColor),
            ),
          )
        ],
      ),
    );
  }
}
