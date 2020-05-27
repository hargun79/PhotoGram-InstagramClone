import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/ui/about_section.dart';
import 'package:socialmedia/ui/like_bar.dart';
import 'package:socialmedia/ui/comment_bar.dart';

FirebaseUser loggedInUser;

class MainFeedPostDetailsRoute extends StatefulWidget {
  final String _id;
  final String _heroImageUri;
  final String _tag;
  final String _title;

  MainFeedPostDetailsRoute(
      this._id, this._title, this._heroImageUri, this._tag);

  @override
  _MainFeedPostDetailsRouteState createState() =>
      _MainFeedPostDetailsRouteState();
}

class _MainFeedPostDetailsRouteState extends State<MainFeedPostDetailsRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text(
            "PhotoGram",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: MainFeedPostDetailsPage(
            widget._id,
            widget._title,
            widget._heroImageUri,
            widget._tag,
            MediaQuery.of(context).size.width));
  }
}

class MainFeedPostDetailsPage extends StatefulWidget {
  final String _id;
  final double screenWidth;
  final String _tag;
  final String _heroImageUri;
  final String _title;

  MainFeedPostDetailsPage(
    this._id,
    this._title,
    this._heroImageUri,
    this._tag,
    this.screenWidth,
  );

  @override
  State<StatefulWidget> createState() {
    return MainFeedPostDetailsPageState();
  }
}

class MainFeedPostDetailsPageState extends State<MainFeedPostDetailsPage> {
  double heroImageHeight;
  String description,
      title,
      status,
      username,
      profilePicUri,
      heroImageUri,
      userId,
      userDescription,
      postId,
      commentCount,
      likeCount;

  String get likecount {
    return likeCount;
  }

  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    heroImageHeight = widget.screenWidth / 1.3;
    Firestore.instance
        .collection("mainFeedPostDetails")
        .document(widget._id)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          title = document["name"];
          status = document["status"];
          username = document["username"];
          heroImageUri = document["heroImageUrl"];
          commentCount = document["commentCount"];
          likeCount = document["likeCount"];
          userId = document["userId"];
          postId = document.documentID;
          profilePicUri = document["profilePicUrl"];
          userDescription = document["userDescription"];
          print(username);
        });
      }
    });
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
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Hero(
                tag: widget._tag,
                child: Image(
                  image: NetworkImage(widget._heroImageUri),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: heroImageHeight,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            widget._title,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 20),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                    ],
                  )),
              commentCount == null
                  ? SizedBox.shrink()
                  : CommentsBar(widget._id, commentCount),
              Container(
                height: 52.0,
                color: Colors.black12,
              ),
              username == null
                  ? SizedBox.shrink()
                  : AboutSection(
                      username,
                      profilePicUri ??
                          'https://d2c7ipcroan06u.cloudfront.net/wp-content/uploads/2020/04/PM-Modi-speech-2.jpeg',
                      userDescription),
            ],
          ),
        ),
        likeCount == null ? SizedBox.shrink() : LikeBar(likeCount, widget._id),
      ],
    );
  }
}
