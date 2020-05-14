import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String _profileImageUrl;
  final String _name;
  final String _description;

  AboutSection(this._name, this._profileImageUrl, this._description);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24.0),
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage(_profileImageUrl)),
            SizedBox(
              width: 12.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Text(
                  "Follow",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 24.0,
          ),
          Text(_description),
          SizedBox(
            height: 52.0,
          )
        ],
      ),
    );
  }
}
