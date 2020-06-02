import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main_feed_screen.dart';
import 'package:socialmedia/ui/user_profile_post_row.dart';
import 'package:socialmedia/ui/user_profile_header.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String name, source;
  final _firestore = Firestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("mainFeedPostDetails").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final posts = snapshot.data.documents;
          List<UserProfilePostRow> userProfilePostRows = [];
          for (var post in posts) {
            final name = post.data['name'];
            final source = post.data['heroImageUrl'];
            final userProfilePostRow = new UserProfilePostRow(name, source);
            if (loggedInUser.uid == post.data['userId']) {
              userProfilePostRows.add(userProfilePostRow);
            }
          }
          return ListView(
            children: <Widget>[
              ProfileHeader(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Posts",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: userProfilePostRows,
                ),
              )
            ],
          );
        });
  }
}
