class CommentModel
{
  String comment;
  String name;
  String time;
  String uId;
  String profileImage;
  int index;

  CommentModel({
    required this.comment,
    required this.name,
    required this.time,
    required this.uId,
    required this.profileImage,
    required this.index,
});
}

class SavePostModel
{
  String text;
  String time;
  String? photo;
  String userName;
  String posterId;
  String uId;
  String profileImage;
  int index;

  SavePostModel({
    required this.text,
    this.photo,
    required this.time,
    required this.userName,
    required this.uId,
    required this.posterId,
    required this.profileImage,
    required this.index,
});
}