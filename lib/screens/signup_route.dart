import 'dart:io';
import 'dart:async';
import 'package:socialmedia/utils/authenticate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialmedia/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController profileImageUrlController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
String errorMessage;
final _scaffoldKey = GlobalKey<ScaffoldState>();

class SignUpRoute extends StatelessWidget {
  final Function _setLoggedIn;

  SignUpRoute(this._setLoggedIn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'PhotoGram',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w100),
                ),
                Icon(
                  Icons.photo_camera,
                  size: 40,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
            ),
            SignUpScreen(_setLoggedIn)
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  final Function _setLoggedIn;

  SignUpScreen(this._setLoggedIn);

  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> {
  bool _nameFieldIsVisible = false;
  bool _obscureText = true;
  File _image;
  String _uploadedFileURL;
  bool showSpinner = false;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Text(
                  _nameFieldIsVisible ? "Sign Up" : "Sign In",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100),
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email Address", border: kBorderDecoration),
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextField(
                  obscureText: _obscureText,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: kBorderDecoration,
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        !_obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Visibility(
                  visible: _nameFieldIsVisible ? true : false,
                  child: TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        hintText: "Username", border: kBorderDecoration),
                  ),
                ),
                SizedBox(
                  height: _nameFieldIsVisible ? 24.0 : 0,
                ),
                Visibility(
                  visible: _nameFieldIsVisible ? true : false,
                  child: TextField(
                    controller: profileImageUrlController,
                    decoration: InputDecoration(
                        hintText: "Profile Image Url(Generated automatically)",
                        border: kBorderDecoration),
                  ),
                ),
                SizedBox(
                  height: _nameFieldIsVisible ? 24.0 : 0,
                ),
                Visibility(
                  visible: _nameFieldIsVisible ? true : false,
                  child: RaisedButton(
                    child: Text('Choose File'),
                    onPressed: chooseFile,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                SizedBox(
                  height: _nameFieldIsVisible ? 24.0 : 0,
                ),
                Visibility(
                  visible: _nameFieldIsVisible ? true : false,
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: "Status", border: kBorderDecoration),
                  ),
                ),
                SizedBox(
                  height: _nameFieldIsVisible ? 24.0 : 0,
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blue)),
                    child: Text(_nameFieldIsVisible ? "Sign Up" : "Sign In"),
                    onPressed: () {
                      _nameFieldIsVisible
                          ? signUpWithEmail(
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                              profileImageUrlController.text,
                              descriptionController.text,
                              widget._setLoggedIn)
                          : signInWithEmail(
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                              widget._setLoggedIn);
                      FocusScope.of(context).unfocus();
                      Timer(Duration(seconds: 3), () {
                        nameController.clear();
                        passwordController.clear();
                        emailController.clear();
                        profileImageUrlController.clear();
                        descriptionController.clear();
                        _displaySnackBar(BuildContext context) {
                          final snackBar =
                              SnackBar(content: Text("Something went wrong!"));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }

                        _displaySnackBar(context);
                      });
                    }),
                SizedBox(
                  height: 24.0,
                ),
                FlatButton(
                  child: Text(_nameFieldIsVisible == true
                      ? "Already have an account? Sign in"
                      : "Don't have an account? Sign up"),
                  onPressed: () {
                    setState(() {
                      _nameFieldIsVisible = !_nameFieldIsVisible;
                    });
                  },
                )
              ],
            ),
          ),
        ],
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
        profileImageUrlController.text = _uploadedFileURL;
        print(_uploadedFileURL);
        showSpinner = false;
      });
    });
  }
}
