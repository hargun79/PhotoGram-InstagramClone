import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/utils/main_feed_post.dart';
import 'package:socialmedia/ui/main_feed_row.dart';
import 'package:socialmedia/screens/post_details_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseUser loggedInUser;
final _auth = FirebaseAuth.instance;

class MainFeedScreen extends StatefulWidget {
  @override
  _MainFeedScreenState createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("mainFeedPostDetails")
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData)
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text("Loading..."),
          );
        return ListView.builder(
          itemCount: snapshots.data.documents.length,
          itemBuilder: (context, index) => MainFeedRow(
              MainFeedPost.fromSnapshot(snapshots.data.documents[index]), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainFeedPostDetailsRoute(
                        snapshots.data.documents[index].documentID,
                        snapshots.data.documents[index]["name"],
                        snapshots.data.documents[index]["heroImageUrl"],
                        "heroImageTag" + index.toString())));
          }, "heroImageTag" + index.toString()),
        );
      },
    );
  }
}
