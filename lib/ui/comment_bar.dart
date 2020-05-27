import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment_row.dart';
import 'package:firebase_auth/firebase_auth.dart';

String comment;
String commentCount1;
int commentCount2;
String profileImageUrl;

bool _showComments = false;

FirebaseUser loggedInUser;

final _auth = FirebaseAuth.instance;

final TextEditingController _controller = new TextEditingController();

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
  void initState() {
    _showComments = false;
    Firestore.instance
        .collection('/mainFeedPostDetails')
        .document(widget._id)
        .get()
        .then((DocumentSnapshot snapshot) {
      commentCount1 = snapshot.data['commentCount'];
      commentCount2 = int.parse(commentCount1);
      print(commentCount2);
    });
    getCurrentUser();
    super.initState();
  }

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
