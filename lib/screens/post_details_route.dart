import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/ui/comment_row.dart';
import 'package:socialmedia/ui/about_section.dart';
import 'package:socialmedia/ui/like_bar.dart';

String comment;
String commentCount1;
int commentCount2;
String profileImageUrl;

final TextEditingController _controller = new TextEditingController();

bool _showComments = false;

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
    _showComments = false;
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
    Firestore.instance
        .collection('/mainFeedPostDetails')
        .document(widget._id)
        .get()
        .then((DocumentSnapshot snapshot) {
      commentCount1 = snapshot.data['commentCount'];
      commentCount2 = int.parse(commentCount1);
      print(commentCount2);
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

class CommentsBar extends StatefulWidget {
  final String _commentCount;
  final String _id;

  CommentsBar(this._id, this._commentCount);

  @override
  State<StatefulWidget> createState() {
    return CommentsBarState();
  }
}

class CommentsBarState extends State<CommentsBar> {
  final _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 1.0,
          color: Colors.black12,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add a comment",
                      contentPadding: EdgeInsets.all(8.0)),
                  onChanged: (value) {
                    comment = value;
                    Firestore.instance
                        .collection('/users')
                        .document(loggedInUser.uid)
                        .get()
                        .then((DocumentSnapshot snapshot) {
                      profileImageUrl = snapshot.data['profileImageUrl'];
                      print(profileImageUrl);
                    });
                  },
                ),
              ),
              FlatButton(
                child: Text('Submit'),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: () {
                  _firestore.collection('/comments').add({
                    'username': loggedInUser.displayName,
                    'userId': loggedInUser.uid,
                    'userProfilePicUrl': profileImageUrl,
                    'body': comment,
                    'postId': widget._id,
                    'dateTime': DateTime.now()
                  });
                  setState(() {
                    commentCount2 += 1;
                    _firestore
                        .collection('/mainFeedPostDetails')
                        .document(widget._id)
                        .updateData({'commentCount': commentCount2.toString()});
                    FocusScope.of(context).unfocus();
                    _controller.clear();
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    String commentCount1 = widget._commentCount;
                    int commentCount2 = int.parse(commentCount1);
                    if (commentCount2 > 0) {
                      _showComments = true;
                      print(_showComments);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: Text(
                      widget._commentCount + " comments",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible: _showComments,
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("comments").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
              final comments = snapshot.data.documents;
              List<CommentRow> commentRows = [];
              for (var comment in comments) {
                final userId = comment.data['userId'];
                final username = comment.data['username'];
                final profilePicUrl = comment.data['userProfilePicUrl'];
                final body = comment.data['body'];
                final dateTime = comment.data['dateTime'].toDate();
                final commentRow = new CommentRow(
                    userId, username, profilePicUrl, body, dateTime);
                if (widget._id == comment.data['postId']) {
                  commentRows.add(commentRow);
                  commentRows.sort((a, b) => b.date.compareTo(a.date));
                }
              }
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                child: ListView(
                  shrinkWrap: true,
                  children: commentRows,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
