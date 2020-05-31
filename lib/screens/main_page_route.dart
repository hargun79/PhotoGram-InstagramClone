import 'package:socialmedia/main.dart';
import 'package:socialmedia/screens/new_post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/main_feed_screen.dart';
import '../screens/user_profile_route.dart';
import 'edit_profile_route.dart';

class MainPageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPageScreen();
  }
}

class MainPageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageScreenState();
  }
}

class MainPageScreenState extends State<MainPageScreen> {
  int _pageIndex = 0;
  List _screens = [
    {
      "name": "PhotoGram",
      "screen": MainFeedScreen(),
    },
    {
      "name": "New Post",
      "screen": NewPostScreen(),
    },
    {
      "name": "Profile",
      "screen": UserProfileScreen(),
    },
  ];

  void handleClick(String value) {
    switch (value) {
      case 'Edit Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfileScreen()),
        );
        break;
      case 'Sign out':
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewPostRoute();
              }));
            } else {
              setState(() {
                _pageIndex = index;
              });
            }
          },
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Feed")),
            BottomNavigationBarItem(
                icon: Icon(Icons.add), title: Text("New Post")),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                title: Text("Profile")),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          actions: <Widget>[
            PopupMenuButton(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {"Edit Profile", "Sign out"}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
          title: Text(
            _screens[_pageIndex]["name"],
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: _screens[_pageIndex]["screen"]);
  }
}
