import 'package:provider/provider.dart';
import 'package:socialmedia/screens/signup_route.dart';
import 'package:flutter/material.dart';
import 'screens/main_page_route.dart';
import 'utils/authenticate.dart' as auth;

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "OpenSans",
          textTheme: TextTheme(
              subtitle:
                  TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700))),
      home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    auth.isLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {
        setLoggedIn();
      }
    });
  }

  void setLoggedIn() {
    setState(() {
      _loggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loggedIn ? MainPageRoute() : SignUpRoute(setLoggedIn);
  }
}
