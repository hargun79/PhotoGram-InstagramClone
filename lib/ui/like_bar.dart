import 'package:flutter/material.dart';
import 'main_feed_row_like_button.dart';

class LikeBar extends StatefulWidget {
  final String _likeCount;
  final String _postId;

  LikeBar(this._likeCount, this._postId);

  @override
  _LikeBarState createState() => _LikeBarState();
}

class _LikeBarState extends State<LikeBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 50,
        margin: EdgeInsets.only(bottom: 0.0),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.white70,
              blurRadius: 50.0,
            ),
          ]),
          width: MediaQuery.of(context).size.width * 0.4,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
          //color: Colors.white,
          child: LikeButton(widget._postId, widget._likeCount),
        ),
      ),
    );
  }
}
