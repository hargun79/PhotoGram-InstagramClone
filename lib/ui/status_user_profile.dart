import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  final String _text;

  Status(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text != null && _text.length > 0
          ? _text
          : "Please add a description about yourself",
      style: TextStyle(fontSize: 14.0),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }
}
