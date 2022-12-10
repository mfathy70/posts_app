import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/constants/colors.dart';
import 'package:login/providers/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController postController = TextEditingController();

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
        title: const Text('Add Post'),
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
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 33, 82))),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var uuid = const Uuid().v1();
              print(uuid);
              await FirebaseFirestore.instance
                  .collection("posts")
                  .doc(uuid)
                  .set({
                "post": postController.text,
                "name": Provider.of<UserData>(context, listen: false).name,
                "pic": Provider.of<UserData>(context, listen: false).picUrl,
                'time': DateTime.now(),
                'user_id': Provider.of<UserData>(context, listen: false).id,
                'post_id': uuid
              }).then((value) => Navigator.pop(context));
            },
            style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
            child: Text(
              'Post',
              style: TextStyle(color: thirdColor),
            ),
          )
        ],
      ),
    );
  }
}
