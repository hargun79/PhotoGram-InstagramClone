import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/utils/main_feed_post.dart';
import '../ui/main_feed_row.dart';
import '../screens//post_details_route.dart';

class MainFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("mainFeedPostDetails").snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData)
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text("Loading..."),
          );
        return ListView.builder(
          itemCount: snapshots.data.documents.length,
          itemBuilder: (context, index) => MainFeedRow(
                  MainFeedPost.fromSnapshot(snapshots.data.documents[index]),
                  () {
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
