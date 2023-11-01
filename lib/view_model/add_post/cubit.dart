import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled10/modules/snackBar.dart';
import 'package:untitled10/view_model/add_post/states.dart';
import '../../models/addPost_model.dart';

class AddPostCubit extends Cubit<AddPostStates> {
  AddPostCubit(super.initialState);
  static AddPostCubit getInstance(context) => BlocProvider.of(context);

  Future<void> addPostWithoutPhoto({
    required AddPostModel addPostModel,
    required context,
})async
  {
    emit(AddPostLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .add(
        {
          'text' : addPostModel.text,
          'time' : addPostModel.time,
          'uId' : addPostModel.uId,
          'userProfileImage' : addPostModel.userProfileImage,
          'userName' : addPostModel.userName,
        },
    ).then((value)
    {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(value.id)
          .collection('likes')
          .add({})
          .then((value)
      {
        emit(AddPostWithoutPhotoSuccessState());
        MySnackBar.showSnackBar(
          context: context,
          message: 'Posted Successfully',
          color: Colors.green,
        );
      });
    }).catchError((error)
    {
      MySnackBar.showSnackBar(
        context: context,
        message: 'Error',
        color: Colors.red,
      );
      emit(AddPostWithoutPhotoErrorState());
    });
  }


  final ImagePicker picker = ImagePicker();
   XFile? image;
   File? selectedImage;
   late String imagePostName;
  Future<void> selectImageForPost({
    required ImageSource source,
})async
  {
        image = await picker.pickImage(
        source: source,
    ).then((value)
    {
      if(value != null)
      {
        selectedImage = File(value.path);
        imagePostName = Uri.file(value.path).pathSegments.last;
        print(value.path);
        emit(SelectImageForPostSuccessState());
      }
    }).catchError((error)
    {
      emit(SelectImageForPostErrorState());
    });
  }

  Future<void> addPostWithPhoto({
    required AddPostModel addPostModel,
    required File pickedImage,
    required context,
  })async
  {
    emit(AddPostLoadingState());
    FirebaseStorage.instance
    .ref('postsImages/')
    .child(imagePostName)
    .putFile(pickedImage)
    .then((value)
    {
      value.ref
          .getDownloadURL()
          .then((value) async
       {
         await FirebaseFirestore.instance
             .collection('posts')
             .add(
           {
             'userName' : addPostModel.userName,
             'userProfileImage' : addPostModel.userProfileImage,
             'text' : addPostModel.text,
             'photo' : value,
             'time' : addPostModel.time,
             'uId' : addPostModel.uId,
           },
         ).then((value)
         {
           FirebaseFirestore.instance
           .collection('posts')
           .doc(value.id)
           .collection('likes')
           .add({})
           .then((value)
           {
             emit(AddPostWithPhotoSuccessState());
             MySnackBar.showSnackBar(
               context: context,
               message: 'Posted Successfully',
               color: Colors.green,
             );
           });
         }).catchError((error)
         {
           MySnackBar.showSnackBar(
             context: context,
             message: 'Error',
             color: Colors.red,
           );
           emit(AddPostWithPhotoErrorState());
         });
       },
      );
    });
  }

  void deleteSelectingPhoto()
  {
    selectedImage = null;
    emit(DeleteSelectedImage());
  }
}
