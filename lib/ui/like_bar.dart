import 'package:flutter/material.dart';
import 'main_feed_row_like_button.dart';
import 'package:provider/provider.dart';

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
        elevation: 20,
        margin: EdgeInsets.only(bottom: 0.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              LikeButton(widget._postId, widget._likeCount),
              SizedBox(
                width: 12.0,
              ),
              Text(widget._likeCount + " Likes"),
              //Text(
              //  '${Provider.of<MainFeedPostDetailsRoute>(context, listen: false).createState()}' +
              //    " Likes")
            ],
          ),
        ),
      ),
    );
  }
}
