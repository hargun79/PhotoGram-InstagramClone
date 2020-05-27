import 'package:flutter/material.dart';

bool follow = false;

class AboutSection extends StatefulWidget {
  final String _profileImageUrl;
  final String _name;
  final String _description;

  AboutSection(this._name, this._profileImageUrl, this._description);

  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.lightBlueAccent, spreadRadius: 2, blurRadius: 4),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24.0),
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            CircleAvatar(
                backgroundImage: NetworkImage(widget._profileImageUrl)),
            SizedBox(
              width: 12.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget._name,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
              ],
            ),
            Spacer(),
            Visibility(
              visible: follow ? false : true,
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    follow = !follow;
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Text(
                    "Follow",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: follow ? true : false,
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    follow = !follow;
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    border: Border.all(width: 2.0, color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    "Following",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 24.0,
          ),
          Text(
            widget._description,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 52.0,
          )
        ],
      ),
    );
  }
}
