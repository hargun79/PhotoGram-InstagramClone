import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
        body: NewPostScreen());
  }
}

class NewPostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPostScreenState();
  }
}

class NewPostScreenState extends State<NewPostScreen> {
  File _image;
  String _uploadedFileURL;
  bool _validate1 = false;
  bool _validate2 = false;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Caption",
                errorText: _validate1 ? 'Value Can\'t Be Empty' : null,
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
              height: 20,
            ),
            RaisedButton(
              child: Text('Choose File'),
              onPressed: chooseFile,
              color: Colors.lightBlueAccent,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                errorText: _validate2 ? 'Value Can\'t Be Empty' : null,
                hintText: "This field will be generated automatically",
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
                setState(() {
                  if (titleController.text.isEmpty == true ||
                      urlController.text.isEmpty == true) {
                    titleController.text.isEmpty
                        ? _validate1 = true
                        : _validate1 = false;
                    urlController.text.isEmpty
                        ? _validate2 = true
                        : _validate2 = false;
                    return;
                  } else {
                    _firestore
                        .collection('/mainFeedPosts')
                        .add({'name': title, 'heroImageUrl': url});
                    _firestore.collection('/mainFeedPostDetails').add({
                      'name': title,
                      'heroImageUrl': urlController.text,
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
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future chooseFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      showSpinner = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        urlController.text = _uploadedFileURL;
        print(_uploadedFileURL);
        showSpinner = false;
      });
    });
  }
}
