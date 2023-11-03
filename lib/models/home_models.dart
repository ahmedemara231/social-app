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
  String id;
  String text;
  String time;
  String? photo;
  String userName;
  String profileImage;
  int index;

  SavePostModel({
    required this.id,
    required this.text,
    this.photo,
    required this.time,
    required this.userName,
    required this.profileImage,
    required this.index,
});
}