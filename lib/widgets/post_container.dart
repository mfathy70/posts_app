import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/constants/colors.dart';
import 'package:login/providers/user_data_provider.dart';
import 'package:login/widgets/edit_post.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostContainer extends StatelessWidget {
  const PostContainer({
    Key? key,
    required this.userName,
    required this.picUrl,
    required this.postContent,
    required this.time,
    required this.postId,
  }) : super(key: key);

  final String userName;
  final String picUrl;
  final String postContent;
  final Timestamp time;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            color: containerColor,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(picUrl),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.bold),
                      ),
                      Text(timeago.format(time.toDate()),
                          style: TextStyle(color: Colors.grey[600]))
                    ],
                  ),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .get(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      var postMap = snapshot.data!.data();
                      final userId = postMap!['user_id'];
                      if (userId ==
                          Provider.of<UserData>(context, listen: false).id) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Editpost(
                            postContent: postContent,
                            postId: postId,
                          ),
                        );
                      }
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            color: containerColor,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(postContent),
              ],
            ),
          )
        ],
      ),
    );
  }
}
