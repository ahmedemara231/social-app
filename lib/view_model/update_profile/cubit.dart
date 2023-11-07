import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled10/modules/snackBar.dart';
import 'package:untitled10/view_model/update_profile/states.dart';
import '../../models/updateProfile_models.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileStates>
{
  UpdateProfileCubit(super.initialState);

  static UpdateProfileCubit getInstance(context)=> BlocProvider.of(context);

  late File selectedCoverImage;
  late String imageCoverName;
  Future<void> updateCoverImage({
    required String uId,
    required context,
    required ImageSource method,
  })async
  {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: method).then((value)
    {
      selectedCoverImage = File(value!.path);
      imageCoverName = Uri.file(value.path).pathSegments.last;
      FirebaseStorage.instance
          .ref('coverImages/')
          .child(imageCoverName)
          .putFile(selectedCoverImage)
          .then((value)
      {
        value.ref.getDownloadURL().then((value)
        {
          FirebaseFirestore.instance
              .collection('user')
              .doc(uId)
              .update(
            {
              'coverImage' : value,
            },
          ).then((value)
          {
            MySnackBar.showSnackBar(
              context: context,
              message: 'Updated Successfully',
              color: Colors.green,
            );
          });
        });
      });
    });

  }


  late File selectedProfileImage;
  late String imageProfileName;
  late String newProfileImageUrl;
  Future<void> updateProfileImage({
    required String uId,
    required ImageSource method,
    required context,
})async
  {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: method)
        .then((value) {
      selectedProfileImage = File(value!.path);
      imageProfileName = Uri
          .file(value.path)
          .pathSegments
          .last;
      FirebaseStorage.instance
          .ref('profileImages/')
          .child(imageProfileName)
          .putFile(selectedProfileImage)
          .then((value) {
        value.ref.getDownloadURL().then((value)
        {
          newProfileImageUrl = value;
          FirebaseFirestore.instance
              .collection('user')
              .doc(uId)
              .update(
            {
              'profileImage': value,
            },
          ).then((value) {
            // update profileImage in posts
            FirebaseFirestore.instance
                .collection('posts')
                .where('uId', isEqualTo: uId)
                .get().then((value) {
              value.docs.forEach((element) {
                element.reference.update(
                  {
                    'userProfileImage': newProfileImageUrl
                  },
                ).then((value)
                {
                  MySnackBar.showSnackBar(
                      context: context,
                      message: 'Updated successfully',
                      color: Colors.green
                  );
                });
              });
            });

            // update profileImage in all comments
            FirebaseFirestore.instance
            .collection('posts')
            .get()
            .then((value)
            {
              value.docs.forEach((element) {
                element.reference
                    .collection('comments')
                    .where('uId',isEqualTo: uId)
                    .get()
                    .then((value)
                {
                  value.docs.forEach((element) {
                    element.reference.update(
                        {
                          'userProfileImage' : newProfileImageUrl,
                        },
                    );
                  });
                });
              });
            });
          });
        });
      });
     }
    );
  }

  Future<void> updateUserData({
    required UpdateUserDataModel updateUserDataModel,
    required context,
  })async
  {
    emit(UpdateUserDataLoadingState());
    await FirebaseFirestore.instance
        .collection('user')
        .doc(updateUserDataModel.uId)
        .update(
      {
        'name' : updateUserDataModel.name,
        'email' : updateUserDataModel.email,
        'phone' : updateUserDataModel.phone,
        'bio' : updateUserDataModel.bio
      },
    ).then((value)async
    {
      // await updateEmail(newEmail: email, context: context);
       FirebaseFirestore.instance
      .collection('posts')
      .where('uId',isEqualTo: updateUserDataModel.uId)
      .get()
      .then((value)
      {
        value.docs.forEach((element) {
          element.reference.update({
            'userName' :updateUserDataModel.name,
            'email' : updateUserDataModel.email,
            'phone' : updateUserDataModel.phone,
          }).then((value)
          {
            // update user data in posts comments
            FirebaseFirestore.instance
            .collection('posts')
            .get()
            .then((value)
            {
              value.docs.forEach((element) {
                element
                    .reference
                    .collection('comments')
                    .where('uId',isEqualTo: updateUserDataModel.uId)
                    .get().then((value)
                {
                  value.docs.forEach((element) {
                    element.reference.update(
                        {
                          'name' : updateUserDataModel.name,
                        },
                    ).then((value)
                    {
                      emit(UpdateUserDataSuccessState());
                    });
                  });
                });
              });
            });
            MySnackBar.showSnackBar(
                context: context,
                message: 'Updated successfully',
                color: Colors.green
            );
            log('updated');
          });
        });
      });

    }).catchError((error)
    {
      log(error.toString());
      emit(UpdateUserDataErrorState());
    });
  }

//   Future<void> updateEmail({
//     required String newEmail,
//     required context,
// })async
//   {
//     if(FirebaseAuth.instance.currentUser?.emailVerified == true)
//       {
//         await FirebaseAuth.instance
//             .currentUser?.updateEmail(newEmail).then((value)
//         {
//           log('email updated');
//         });
//
//       }else{
//       MySnackBar.showSnackBar(
//           context: context,
//           message: 'Please Verify your email',
//       );
//     }
//   }
}