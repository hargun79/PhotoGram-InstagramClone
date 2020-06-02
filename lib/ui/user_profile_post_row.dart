import 'package:flutter/material.dart';

class UserProfilePostRow extends StatelessWidget {
  final String _src;
  final String _name;

  UserProfilePostRow(this._name, this._src);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Image.network(_src,
                    width: double.infinity, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      _name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
