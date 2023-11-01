class UserLoginModel
{
  String email;
  String password;

  UserLoginModel({
    required this.email,
    required this.password,
});
}

class UserRegisterModel
{
  String name;
  String email;
  String phone;
  String password;

  UserRegisterModel({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });
}

class UserModel
{
  String name;
  String email;
  String phone;
  String bio;
  String profileImage;
  String coverImage;
  String uId;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.profileImage,
    required this.coverImage,
    required this.uId,
});
}