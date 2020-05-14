import 'package:flutter/material.dart';

class CommentRow extends StatelessWidget {
  final String _userId, _username, _profilePicUrl, _body;
  final DateTime _date;

  CommentRow(this._userId, this._username, this._profilePicUrl, this._body,
      this._date);

  DateTime get date {
    return _date;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.black12, width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(backgroundImage: NetworkImage(_profilePicUrl)),
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_username,
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(_date.toString()),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(_body),
          ),
        ],
      ),
    );
  }
}
