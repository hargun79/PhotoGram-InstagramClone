import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/post_details_route.dart';
import 'package:provider/provider.dart';

String likeCount1;
int likeCount2;

final pageKey = GlobalKey<MainFeedPostDetailsPageState>();

class LikeButton extends StatefulWidget {
  final String postId;
  String likeCount;
  LikeButton(this.postId, this.likeCount);
  @override
  State<StatefulWidget> createState() {
    return LikeButtonState(postId, likeCount);
  }
}

class LikeButtonState extends State<LikeButton> {
  final String postId;
  String likeCount;
  LikeButtonState(this.postId, this.likeCount);
  final _firestore = Firestore.instance;
  String src = "assets/images/hands-and-gestures.svg";

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('/mainFeedPostDetails')
        .document(postId)
        .get()
        .then((DocumentSnapshot snapshot) {
      likeCount1 = snapshot.data['likeCount'];
      likeCount2 = int.parse(likeCount1);
      print(likeCount2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.blue)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {
        setState(() {
          Firestore.instance
              .collection('/mainFeedPostDetails')
              .document(postId)
              .get()
              .then((DocumentSnapshot snapshot) {
            likeCount1 = snapshot.data['likeCount'];
            likeCount2 = int.parse(likeCount1);
            print(likeCount2);
          });
          likeCount2 += 1;
          _firestore
              .collection('/mainFeedPostDetails')
              .document(postId)
              .updateData({'likeCount': likeCount2.toString()});
          //Provider.of<MainFeedPostDetailsPageState>(context, listen: false)
          //  .likeCount;
        });
      },
      child: SvgPicture.asset(
        src,
        width: 24.0,
        height: 24.0,
      ),
    );
  }
}
