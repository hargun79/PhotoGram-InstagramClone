import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/authenticate.dart';
import 'main_feed_screen.dart';
import 'package:socialmedia/ui/profile_header_item.dart';
import 'package:socialmedia/ui/user_profile_post_row.dart';
import 'package:socialmedia/ui/status_user_profile.dart';

class ProfileHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileHeaderState();
  }
}

class ProfileHeaderState extends State<ProfileHeader> {
  String _name, _description, _profileImageUrl;
  String _followers, _following, _posts;

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection("users")
        .document(uid)
        .get()
        .then((docSnapshot) {
      setState(() {
        _name = docSnapshot["name"];
        _posts = docSnapshot["postCount"];
        _followers = docSnapshot["followers"];
        _following = docSnapshot["following"];
        _description = docSnapshot["description"];
        _profileImageUrl = docSnapshot["profileImageUrl"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.0, right: 12.0, left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 45.0,
                backgroundImage:
                    NetworkImage(_profileImageUrl ?? "default.jpg"),
              ),
              ProfileHeaderItem(_posts, "Posts"),
              ProfileHeaderItem(_followers, "Followers"),
              ProfileHeaderItem(_following, "Following"),
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            _name == null ? "" : _name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
          ),
          Status(_description),
        ],
      ),
    );
  }
}

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
