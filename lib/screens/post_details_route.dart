import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/ui/about_section.dart';
import 'package:socialmedia/ui/like_bar.dart';
import 'package:socialmedia/ui/comment_bar.dart';
import 'main_feed_screen.dart';

String postCount;

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

  @override
  void initState() {
    super.initState();
    heroImageHeight = 400;
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
    Firestore.instance
        .collection("users")
        .document(loggedInUser.uid)
        .get()
        .then((document) {
      postCount = document["postCount"];
    });
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
                          Visibility(
                            visible: loggedInUser.uid == userId ? true : false,
                            child: FlatButton(
                              onPressed: () {
                                String postCount1 = postCount;
                                int postCount2 = int.parse(postCount1);
                                postCount2 -= 1;
                                postCount1 = postCount2.toString();
                                Firestore.instance
                                    .collection('/users')
                                    .document(loggedInUser.uid)
                                    .updateData({'postCount': postCount1});
                                Firestore.instance
                                    .collection("mainFeedPostDetails")
                                    .document(widget._id)
                                    .delete();
                                Navigator.pop(context);
                              },
                              child: Text('Delete Post'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)),
                            ),
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
                color: Colors.white,
              ),
              username == null
                  ? SizedBox.shrink()
                  : Visibility(
                      visible: loggedInUser.uid != userId,
                      child: AboutSection(
                          username,
                          profilePicUri ??
                              'https://d2c7ipcroan06u.cloudfront.net/wp-content/uploads/2020/04/PM-Modi-speech-2.jpeg',
                          userDescription),
                    ),
              Container(
                height: 52.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
        likeCount == null ? SizedBox.shrink() : LikeBar(likeCount, widget._id),
      ],
    );
  }
}
