import 'package:cloud_firestore/cloud_firestore.dart';

class MainFeedPostDetails {
  String _title,
      _status,
      _username,
      _profilePicUri,
      _heroImageUri,
      _userId,
      _id,
      _userDescription;
  String _likeCount, _viewCount, _commentCount;
  DateTime _dateTime;

  MainFeedPostDetails.fromDocumentId(String id) {
    Firestore.instance
        .collection("mainFeedPostDetails")
        .document(id)
        .get()
        .then((document) {
      if (document.exists) {
        this._title = document["name"];
        this._status = document["status"];
        this._username = document["username"];
        this._profilePicUri = document["profilePicUrl"];
        this._heroImageUri = document["heroImageUrl"];
        this._commentCount = document["commentCount"];
        this._likeCount = document["likeCount"];
        this._id = document.documentID;
        this._userId = document["userId"];
        this._userDescription = document["userDescription"];
        this._dateTime = document["time"];
      }
    });
  }

  get commentCount => _commentCount;

  get viewCount => _viewCount;

  get likeCount => _likeCount;

  get userDescription => _userDescription;

  get userId => _userId;

  get id => _id;

  get heroImageUri => _heroImageUri;

  get profilePicUri => _profilePicUri;

  get username => _username;

  get status => _status;

  String get title => _title;

  get dateTime => _dateTime;
}
