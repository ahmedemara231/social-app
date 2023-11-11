import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/models/profile_models.dart';
import 'package:untitled10/modules/snackBar.dart';
import 'package:untitled10/view_model/profile/states.dart';
import 'package:untitled10/view_model/sharedPrefs/sharedPrefs.dart';

class ProfileCubit extends Cubit<ProfileStates>
{
  ProfileCubit(super.initialState);
  static ProfileCubit getInstance(context) => BlocProvider.of(context);

  bool postsLoading = false;

  List<Map<String,dynamic>> currentUserPosts = [];
  List<String> currentUserPostsIds = [];
  List<int> currentUserPostsCommentsNumber = [];
  List<int>currentUserPostsLikesNumber = [];

  Future<void> getPostsForCurrentUser({
    required String uId,
})async
  {
    postsLoading = true;
    emit(GetUserPostsLoadingState());

    currentUserPosts = [];
    currentUserPostsIds = [];
    currentUserPostsCommentsNumber = [];
    currentUserPostsLikesNumber = [];

   await FirebaseFirestore.instance
        .collection('posts')
        .where('uId',isEqualTo: uId)
        .get()
        .then((value)async
    {
      value.docs.forEach((element) {
        currentUserPosts.add(element.data());
        currentUserPostsIds.add(element.id);

        element.reference.collection('comments')
        .get()
        .then((value)
        {
          currentUserPostsCommentsNumber.add(value.docs.length);
          emit(GetCommentNumberForEachPostForCurrentUserSuccessState());
        });

        element.reference.collection('likes')
            .get()
            .then((value)
        {
          currentUserPostsLikesNumber.add(value.docs.length);
          emit(GetLikesNumberForEachPostForCurrentUserSuccessState());
        });
      });

      postsLoading = false;
      emit(GetUserPostsSuccessState());
    }).catchError((error)
   {
     emit(GetUserPostsErrorState());
   });
  }

  List<Map<String,dynamic>?> currentUserPostsComments = [];
  Future<void> getPostsCommentsForCurrentUser({
    required String uId,
    required int index,
  })async
  {
    currentUserPostsComments = [];
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(currentUserPostsIds[index])
        .collection('comments')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        currentUserPostsComments.add(element.data());
      });
    });
  }

  Future<void> deletePostFromProfileAndAllPosts({
    required int index,
    required String uId,
    required context,
})async
  {
    FirebaseFirestore.instance
        .collection('posts')
        .where('uId',isEqualTo: uId)
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        if(element.id == currentUserPostsIds[index])
          {
            element.reference.delete();
            currentUserPosts.remove(currentUserPosts[index]);
            currentUserPostsIds.remove(currentUserPostsIds[index]);

            emit(DeletePostFromProfileAndAllPostsSuccessState());
            MySnackBar.showSnackBar(context: context, message: 'Deleted');
          }
        else{
          return;
        }
      });
    }).catchError((error)
    {
      emit(DeletePostFromProfileAndAllPostsErrorState());
    });
  }

  bool darkMode = false;
  Future<void> changeAppTheme(bool value)async
  {
    darkMode = value;
   await SharedPrefs.saveAppTheme(darkMode).then((value)
    {
      emit(SaveAppTheme());
    });
  }

  List<Map<String,dynamic>> savedPosts = [];
  Future<void> getSavedPosts({
    required String uId,
})async
  {
    emit(GetSavedPostsLoadingState());
    savedPosts = [];
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .collection('savedPosts')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        savedPosts.add(element.data());
        emit(GetSavedPostsSuccessState());
      });
    }).catchError((error)
    {
      emit(GetSavedPostsErrorState());
    });
  }

  List<String> savedPostsIds = [];
  Future<void> getSavedPostsIds({
    required String uId,
})async
  {
    savedPostsIds = [];
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .collection('savedPosts')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        savedPostsIds.add(element.id);
      });
    });
  }

  Future<void> deleteSavedPost({
    required DeleteSavedPostModel deletePostModel,
    required context,
})async
  {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(deletePostModel.uId)
        .collection('savedPosts')
        .doc(deletePostModel.postId)
        .delete()
        .then((value)
    {
      savedPosts.remove(savedPosts[deletePostModel.index]);
      savedPostsIds.remove(savedPostsIds[deletePostModel.index]);
      emit(DeleteSavedPostsSuccessState());
      MySnackBar.showSnackBar(
        context: context,
        message: 'Deleted',
      );
    });
  }
  
  Future<void> reportProblem({
    required ReportProblemModel reportProblemModel ,
    required context,
})async
  {
    emit(ReportProblemLoadingState());
    await FirebaseFirestore.instance
        .collection('problems')
        .add(
        {
          'email' : reportProblemModel.email,
          'uId' : reportProblemModel.uId,
          'problem' : reportProblemModel.problem,
          'time' : reportProblemModel.time,
        },
    ).then((value)
    {
      MySnackBar.showSnackBar(
          context: context,
          message: 'Thanks for reporting we will answer ypu soon',
          color: Colors.green
      );
      emit(ReportProblemSuccessState());
    }).catchError((error)
    {
      emit(ReportProblemErrorState());
    });
  }

  List<Map<String,dynamic>> myReports = [];
  Future<void> getMyReports({
    required String uId,
})async
  {
    emit(GetMyReportsLoadingState());
    myReports = [];
    await FirebaseFirestore.instance
        .collection('problems')
        .where('uId' ,isEqualTo: uId)
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        myReports.add(element.data());
      });
      emit(GetMyReportsSuccessState());
    }).catchError((error)
    {
      emit(GetMyReportsErrorState());
    });
  }
}