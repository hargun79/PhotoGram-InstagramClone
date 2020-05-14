class Post {
  String _id;
  String _title;
  String _description;
  List<String> _imageUrls;
  List<String> _steps;
  List<String> _ingredients;
  DateTime _dateTime;
  List<String> _reviewIds;

  String _userName;
  String _userId;
  String _userProfileImageUrl;

  Post(
      {String id,
        String title,
        String description,
        List<String> imageUrls,
        String userProfileImageUrl,
        String userName}) {
    this._id = id;
    this._title = title;
    this._description = description;
    this._imageUrls = imageUrls;
    this._userProfileImageUrl = userProfileImageUrl;
    this._userName = userName;
  }
}
