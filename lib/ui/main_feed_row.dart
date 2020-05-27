import 'package:socialmedia/utils/main_feed_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainFeedRow extends StatelessWidget {
  final MainFeedPost _post;
  final Function onTap;
  final String _tag;

  MainFeedRow(this._post, this.onTap, this._tag);

  @override
  Widget build(BuildContext context) {
    return _post.title == null
        ? Container()
        : InkWell(
            onTap: onTap,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 12),
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(_post.profilePicUri ??
                              "https://d2c7ipcroan06u.cloudfront.net/wp-content/uploads/2020/04/PM-Modi-speech-2.jpeg")),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_post.username ?? 'Hargun',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600)),
                        Text(_post.time.toString(),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54,
                            )),
                      ],
                    ),
                  ]),
                  Hero(
                    tag: _tag,
                    child: FadeInImage(
                        placeholder: AssetImage("assets/images/blank.png"),
                        image: NetworkImage(_post.heroImageUri),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: 400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 12.0, right: 12.0, bottom: 8.0),
                    child: Text(
                      _post.title ?? 'title',
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, bottom: 12.0, left: 12.0, right: 8.0),
                        child: Container(
                          height: 35,
                          width: 85,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue)),
                          ),
                          child: SvgPicture.asset(
                            "assets/images/hands-and-gestures.svg",
                            width: 24.0,
                            height: 24.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: 34.0,
                        child: Text(
                          _post.likeCount ?? '0',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, bottom: 12.0, right: 8.0),
                        child: Container(
                          height: 35,
                          width: 85,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue)),
                          ),
                          child: SvgPicture.asset(
                            "assets/images/comment.svg",
                            width: 24.0,
                            height: 24.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        _post.commentCount ?? '0',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Colors.black12,
                  )
                ],
              ),
            ),
          );
  }
}