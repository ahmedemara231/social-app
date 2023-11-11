import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/models/home_models.dart';
import 'package:untitled10/modules/snackBar.dart';
import 'package:untitled10/view_model/home-cubit/states.dart';

class HomeCubit extends Cubit<HomeStates>
{
  HomeCubit(super.initialState);

  static HomeCubit getInstance(context) => BlocProvider.of(context);

  int currentIndex = 0;
  void changeCurrentIndex({
    required int newIndex,
})
  {
    currentIndex = newIndex;
    emit(ChangeCurrentIndexState());
  }

  List<Map<String,dynamic>> posts = [];
  List<String> postsIds = [];

  bool postsLoading = false;
  Future<void> getAllPosts()async
  {
    postsLoading = true;
    emit(HomeLoadingState());

    posts = [];
    postsIds = [];
    await FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) async
    {
      value.docs.forEach((element) {
        posts.add(element.data());
        postsIds.add(element.id);
      });
      postsLoading = false;
      emit(GetPostsSuccessState());
    });
  }

  bool writeCommentsLoading = false;
  Future<void> writeComment({
    required CommentModel commentModel,
})async
  {
    emit(WriteCommentLoadingState());
    writeCommentsLoading = true;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds[commentModel.index])
        .collection('comments')
        .add(
        {
          'comment' : commentModel.comment,
          'time' : commentModel.time,
          'name' : commentModel.name,
          'uId' : commentModel.uId,
          'userProfileImage' : commentModel.profileImage,
        },
    ).then((value)
    {
      emit(WriteCommentSuccessState());
      writeCommentsLoading = false;
    }).catchError((error)
    {
      emit(WriteCommentErrorState());
      log(error.toString());
    });
  }

  List<Map<String,dynamic>?> allComments = [];
  bool getCommentsLoading = false;
  Future<void> getAllComments({
    required int index,
})async
  {
    allComments = [];
    getCommentsLoading = true;

    emit(GetAllCommentsLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds[index])
        .collection('comments')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        allComments.add(element.data());
      });
      emit(GetAllCommentsSuccessState());
      getCommentsLoading = false;
    }).catchError((error)
    {
      emit(GetAllCommentsErrorState());
      log(error.toString());
    });
  }

  List<String> postCommentsIds = [];
  Future<void> getPostCommentsIds({
    required int index,
})async
  {
    postCommentsIds = [];
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds[index])
        .collection('comments')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        postCommentsIds.add(element.id);
      });
      emit(GetCommentsIdsSuccessState());
    }).catchError((error)
    {
      emit(GetCommentsIdsErrorState());
    });
  }

  late int postIndex;
  Future<void> deleteComment({
    required int commentIndex,
    required context,
})async
  {
    log('$postIndex , $commentIndex');
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds[postIndex])
        .collection('comments')
        .doc(postCommentsIds[commentIndex])
        .delete()
        .then((value)
    {
      log('deleted');
      allComments.remove(allComments[commentIndex]);
      postCommentsIds.remove(postCommentsIds[commentIndex]);
      emit(DeleteCommentSuccessState());
      MySnackBar.showSnackBar(context: context, message: 'Deleted');
    }).catchError((error)
    {
      emit(DeleteCommentErrorState());
    });
  }

  // update comment
  // void setState()
  // {
  //   emit(EditCommentLoadingState());
  // }
  // Future<void> editComment({
  //   required String newComment,
  //   required int commentIndex,
  // })async
  // {
  //   await FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postsId[postIndex])
  //       .collection('comments')
  //       .doc(postCommentsIds[commentIndex])
  //       .update(
  //       {
  //         'comment' : newComment,
  //       },
  //   ).then((value)
  //   {
  //     emit(EditCommentSuccessState());
  //   }).catchError((error)
  //   {
  //     emit(EditCommentErrorState());
  //   });
  // }

  Future<void> savePost({
    required SavePostModel savePostModel,
    required context,
})async
  {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(savePostModel.id)
        .collection('savedPosts')
        .doc(postsIds[savePostModel.index])
        .set(
      {
        'postId' : postsIds[savePostModel.index],
        'text' : savePostModel.text,
        'time' : savePostModel.time,
        'userName' : savePostModel.userName,
        'profileImage' : savePostModel.profileImage?? '',
        'photo' : savePostModel.photo?? '',
     },
   ).then((value)
    {
      emit(SavePostSuccessState());
      MySnackBar.showSnackBar(
          context: context,
          message: 'Saved',
          color: Colors.green
      );
    }).catchError((error)
    {
      emit(SavePostErrorState());
    });
  }

  List<String> usersIds = [];

  Future<void> getUsersIds()async
  {
    usersIds = [];
    FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        usersIds.add(element.id);
      });
      emit(GetUserIdsSuccessState());
    });

  }

  Future<void> deletePost({
    required context,
    required int index,
    required String uId,
})async
  {
    await getUsersIds().then((value)
    {
       FirebaseFirestore.instance
          .collection('posts')
          .doc(postsIds[index])
          .delete()
          .then((value)async
      {
        for(int i = 0; i <= usersIds.length ; i++)
        {
          FirebaseFirestore.instance
              .collection('user')
              .doc(usersIds[i])
              .collection('savedPosts')
              .where('postId',isEqualTo: postsIds[index])
              .get()
              .then((value)
          {
            value.docs.forEach((element) {
              element.reference.delete().then((value)
              {
                posts.remove(posts[index]);
                postsIds.remove(postsIds[index]);

                emit(DeletePostSuccessState());
                MySnackBar.showSnackBar(context: context, message: 'Deleted');
                emit(DeletePostSuccessState());
              });
            });
          }).catchError((error)
          {
            emit(DeletePostErrorState());
          });
        }
      }).catchError((error)
      {
        emit(DeletePostErrorState());
      });
    });
  }

  Future<void> editPostCaption({
    required String newText,
    required context,
    required int index,
})async
  {
    await getUsersIds().then((value)
    {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postsIds[index])
          .update(
        {
          'text' : newText,
        },
      ).then((value){
        for(int i = 0; i <= usersIds.length ; i++)
        {
          FirebaseFirestore.instance
              .collection('user')
              .doc(usersIds[i])
              .collection('savedPosts')
              .where('postId',isEqualTo: postsIds[index])
              .get()
              .then((value)
          {
            value.docs.forEach((element) {
              element.reference.update(
                {
                  'text' : newText,
                },
              ).then((value) {
                emit(EditPostCaptionSuccessState());
              });
            });
          }).catchError((error)
          {
            emit(DeletePostErrorState());
          });
        }

      }).catchError((error)
      {
        log(error.toString());
        emit(EditPostCaptionErrorState());
      });
    });
  }

  List<String> postLikes = [];
  Future<void> getAllLikesForPost({
    required int index,
  })async
  {
    postLikes = [];
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds[index])
        .collection('likes')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        postLikes.add(element.id);
      });
      emit(GetLikeSForPost());
    });
  }

  Future<void> like({
    required String uId,
    required int index,
})async
  {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds[index])
        .collection('likes')
        .doc(uId)
        .set(
        {
          'uId' : uId,
          'isLike' : true,
        },
    ).then((value)
    {
      emit(LikeSuccessState());
    }).catchError((error)
    {
      emit(LikeErrorState());
    });
  }

  Future<void> disLike({
    required int index,
    required String uId,
})async
  {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds[index])
        .collection('likes')
        .doc(uId)
        .delete()
        .then((value)
    {
      emit(DisLikeSuccessState());
      log('disLike');
    }).catchError((error)
    {
      emit(DisLikeErrorState());
    });
  }

  // void detectUserLike({
  //   required String uId,
  //   required int index,
  // })
  // {
  //   for(int i = 0; i < postLikes.length; i++)
  //     {
  //       if(uId == postLikes[i])
  //         {
  //            disLike(index: index, uId: uId);
  //            break;
  //         }
  //       else{
  //          like(uId: uId, index: index);
  //          break;
  //       }
  //     }
  // }

}