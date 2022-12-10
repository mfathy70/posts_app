import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/constants/colors.dart';
import 'package:login/screens/edit_post_screen.dart';

class Editpost extends StatefulWidget {
  final String postContent;
  final String postId;
  const Editpost({
    Key? key,
    required this.postContent,
    required this.postId,
  }) : super(key: key);

  @override
  State<Editpost> createState() => _EditpostState();
}

class _EditpostState extends State<Editpost> {
  var items = ['Edit', 'Delete'];

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: mainColor,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: mainColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      alignment: Alignment.centerLeft),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPostScreen(
                                          post: widget.postContent,
                                          postId: widget.postId,
                                        ),
                                      ),
                                    ).then((value) => Navigator.pop(context));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: buttonColor,
                                  ),
                                  label: Text(
                                    'Edit post',
                                    style: TextStyle(color: buttonColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      alignment: Alignment.centerLeft),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(widget.postId)
                                        .delete()
                                        .then(
                                            (value) => Navigator.pop(context));
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: buttonColor,
                                  ),
                                  label: Text(
                                    'Delete post',
                                    style: TextStyle(color: buttonColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        icon: const Icon(Icons.more_horiz));
  }
}
