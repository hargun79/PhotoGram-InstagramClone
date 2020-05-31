import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/utils/constants.dart';
import 'main_feed_screen.dart';

String username;
String profileImageUrl;
String description;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firestore = Firestore.instance;
  String number;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  final TextEditingController _controller3 = new TextEditingController();
  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection("users")
        .document(loggedInUser.uid)
        .get()
        .then((docSnapshot) {
      setState(() {
        username = docSnapshot["name"];
        description = docSnapshot["description"];
        profileImageUrl = docSnapshot["profileImageUrl"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Username',
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _controller1..text = username,
                textAlign: TextAlign.left,
                onChanged: (value) {
                  username = value;
                },
                decoration: kTextFieldDecoration,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Profile Image',
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _controller2..text = profileImageUrl,
                textAlign: TextAlign.left,
                onChanged: (value) {
                  profileImageUrl = value;
                },
                decoration: kTextFieldDecoration,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Status',
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _controller3..text = description,
                textAlign: TextAlign.left,
                onChanged: (value) {
                  description = value;
                },
                decoration: kTextFieldDecoration,
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                child: Text('Submit'),
                color: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: () {
                  _firestore
                      .collection('/users')
                      .document(loggedInUser.uid)
                      .updateData({
                    'name': username,
                    'profileImageUrl': profileImageUrl,
                    'description': description
                  });
                  _controller1.clear();
                  _controller2.clear();
                  _controller3.clear();
                  FocusScope.of(context).unfocus();
                  _displaySnackBar(context);
                },
              ),
            ],
          ),
        ));
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Profile Updated'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
