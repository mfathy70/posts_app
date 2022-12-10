import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/main.dart';
import 'package:login/providers/user_data_provider.dart';
import 'package:login/screens/add_post_screen.dart';
import 'package:login/widgets/post_container.dart';
import 'package:login/widgets/side_drawer.dart';
import 'package:provider/provider.dart';
import 'package:login/constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(minutes: 1), (Timer t) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<UserData>(
            builder: ((context, userData, child) => Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(userData.picUrl!),
                    ),
                  ),
                ))),
        title: Consumer<UserData>(
            child: Container(),
            builder: (context, userData, child) {
              return Text('Hi, ${userData.name?.split(' ')[0]} !');
            }),
        backgroundColor: mainColor,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error has occurred"));
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return PostContainer(
                  userName: snapshot.data?.docs[index]['name'] ?? "",
                  picUrl: snapshot.data?.docs[index]['pic'],
                  postContent: snapshot.data?.docs[index]['post'],
                  time: snapshot.data?.docs[index]['time'],
                  postId: snapshot.data?.docs[index]['post_id'],
                );
              },
              itemCount: snapshot.data?.size,
            );
          }
          return const Center(
            child: Text('No Posts'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        },
        backgroundColor: buttonColor,
        child: const Icon(Icons.add),
      ),
      drawer: const SideDrawer(),
    );
  }
}
