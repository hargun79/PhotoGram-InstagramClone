import 'dart:async';
import 'package:socialmedia/utils/authenticate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                      hintText: "Email Address",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black12),
                          borderRadius:
                              BorderRadius.all(Radius.circular(6.0)))),
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black12),
                          borderRadius:
                              BorderRadius.all(Radius.circular(6.0)))),
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
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)))),
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
                        hintText: "Profile Image Url",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)))),
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
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)))),
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
                              SnackBar(content: Text('Something went wrong!'));
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
}
