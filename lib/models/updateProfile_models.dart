class UpdateUserDataModel
{
   String? uId;
   String name;
   String email;
   String phone;
   String bio;


   UpdateUserDataModel({
     this.uId,
     required this.name,
     required this.email,
     required this.phone,
     required this.bio,
});
}