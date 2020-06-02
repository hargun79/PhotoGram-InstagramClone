import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/ui/status_user_profile.dart';
import 'package:socialmedia/ui/profile_header_item.dart';
import 'package:socialmedia/screens/main_feed_screen.dart';

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
        .document(loggedInUser.uid)
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
