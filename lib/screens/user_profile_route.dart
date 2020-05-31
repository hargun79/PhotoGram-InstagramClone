import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/authenticate.dart';
import 'main_feed_screen.dart';

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
    Firestore.instance
        .collection("mainFeedPostDetails")
        .document(uid)
        .get()
        .then((docSnapshot) {
      setState(() {
        if (loggedInUser.uid == docSnapshot["userId"]) {
          name = docSnapshot["name"];
          source = docSnapshot["heroImageUrl"];
        }
      });
    });
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
                backgroundImage: NetworkImage(_profileImageUrl ??
                    "https://d2c7ipcroan06u.cloudfront.net/wp-content/uploads/2020/04/PM-Modi-speech-2.jpeg"),
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

class Status extends StatelessWidget {
  final String _text;

  Status(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text != null && _text.length > 0
          ? _text
          : "Please add a description about yourself",
      style: TextStyle(fontSize: 14.0),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class UserProfilePostRow extends StatelessWidget {
  final String _src;
  final String _name;

  UserProfilePostRow(this._name, this._src);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Image.network(_src,
                    width: double.infinity, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      _name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class ProfileHeaderItem extends StatelessWidget {
  final String _count;
  final String _label;

  ProfileHeaderItem(this._count, this._label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            _count == null ? "0" : _count.toString(),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          ),
          Text(_label),
        ],
      ),
    );
  }
}
