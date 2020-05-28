import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String title;
String url;
String userDescription;
String profilePicUri;
String postCount1;
int postCount2;

TextEditingController titleController = TextEditingController();
TextEditingController urlController = TextEditingController();

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
final _auth = FirebaseAuth.instance;

class NewPostRoute extends StatefulWidget {
  @override
  _NewPostRouteState createState() => _NewPostRouteState();
}

class _NewPostRouteState extends State<NewPostRoute> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        _firestore
            .collection('/users')
            .document(loggedInUser.uid)
            .get()
            .then((DocumentSnapshot snapshot) {
          postCount1 = snapshot.data['postCount'];
          postCount2 = int.parse(postCount1);
          profilePicUri = snapshot.data['profileImageUrl'];
          userDescription = snapshot.data['description'];
          print(postCount2);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Add New Post"),
      ),
      body: NewPostScreen(),
    );
  }
}

class NewPostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPostScreenState();
  }
}

class NewPostScreenState extends State<NewPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Caption",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
            ),
            onChanged: (value) {
              title = value;
            },
          ),
          SizedBox(
            height: 50,
          ),
          TextField(
            controller: urlController,
            decoration: InputDecoration(
              hintText: "Post URL",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
            ),
            onChanged: (value) {
              url = value;
            },
          ),
          SizedBox(
            height: 50,
          ),
          FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () {
              _firestore
                  .collection('/mainFeedPosts')
                  .add({'name': title, 'heroImageUrl': url});
              _firestore.collection('/mainFeedPostDetails').add({
                'name': title,
                'heroImageUrl': url,
                'status': "Status",
                'username': loggedInUser.displayName,
                'profilePicUrl': profilePicUri,
                'commentCount': '0',
                'likeCount': '0',
                'userId': loggedInUser.uid,
                'userDescription': userDescription,
                'time': DateTime.now()
              });
              postCount2 += 1;
              //postCount2.toString();
              _firestore
                  .collection('/users')
                  .document(loggedInUser.uid)
                  .updateData({'postCount': postCount2.toString()});
              FocusScope.of(context).unfocus();
              titleController.clear();
              urlController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
