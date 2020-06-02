import 'package:flutter/material.dart';

class ProfileHeaderItem extends StatelessWidget {
  final String _count;
  final String _label;

  ProfileHeaderItem(this._count, this._label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            _count == null ? "0" : _count.toString(),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          ),
          Text(_label),
        ],
      ),
    );
  }
}
