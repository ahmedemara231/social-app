class ReportProblemModel
{
  String email;
  String uId;
  String problem;
  String time;

  ReportProblemModel({
    required this.email,
    required this.uId,
    required this.problem,
    required this.time,
});
}

class DeleteSavedPostModel
{
   String uId;
   String postId;
   int index;

   DeleteSavedPostModel({
     required this.uId,
     required this.postId,
     required this.index,
});
}