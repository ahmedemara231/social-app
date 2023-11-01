import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/models/auth_models.dart';
import 'package:untitled10/models/updateProfile_models.dart';
import 'package:untitled10/view/bottomNavBar/bottomNavBar.dart';
import 'package:untitled10/view_model/auth_cubit/states.dart';
import 'package:untitled10/view_model/sharedPrefs/sharedPrefs.dart';
import '../../modules/snackBar.dart';

class AuthCubit extends Cubit<AuthStates>
{
  AuthCubit(super.initialState);

  static AuthCubit getInstance(context) => BlocProvider.of(context);

  bool regLoading = false;
  Future<void> register({
    required UserRegisterModel userRegisterModel,
    required context,
})async
  {
    // emit(RegisterLoadingState());
    regLoading = true;
    try {
     await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userRegisterModel.email,
      password: userRegisterModel.password,
    ).then((value)
    {
      log('${value.user?.email}');
      FirebaseFirestore.instance
          .collection('user')
          .doc(value.user?.uid)
          .set(
        {
          'name' : userRegisterModel.name,
          'email' : userRegisterModel.email,
          'phone' : userRegisterModel.phone,
          'bio' : '',
          'profileImage' : '',
          'coverImage' : '',
        },
      ).then((value)async
      {
        await verifyEmail(context);
        regLoading = false;
        emit(RegisterSuccessState());
      });

      // عشان يفتح ال saved posts collection
      FirebaseFirestore.instance
          .collection('user')
          .doc(value.user?.uid)
          .collection('savedPosts')
          .add({});
    });
  } on FirebaseAuthException catch (e) {
      emit(RegisterErrorState());
    if (e.code == 'weak-password') {
      MySnackBar.showSnackBar(
        context: context,
        message: 'The password provided is too weak.',
        color: Colors.red,
      );
      log('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      MySnackBar.showSnackBar(
        context: context,
        message: 'The account already exists for that email.',
        color: Colors.red,
      );
      log('The account already exists for that email.');
    }
  } catch (e) {
    log(e.toString());
  }}

  Future<void> verifyEmail(context)async
  {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value)
    {
      MySnackBar.showSnackBar(
          context: context,
          message: 'check your email to verify account',
        color: Colors.green,
      );
    });
  }

  UserModel? userModel;
  Future<void> login({
    required UserLoginModel userLoginModel,
    required context,
})async
  {
    emit(LoginLoadingState());
    try {
       await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userLoginModel.email,
          password: userLoginModel.password,
      ).then((value)
      {
        emit(LoginSuccessState());
        FirebaseFirestore.instance
        .collection('user')
        .doc(value.user?.uid)
        .get()
        .then((value)
        {

          userModel = UserModel(
              name: value.data()?['name'],
              email: value.data()?['email'],
              phone: value.data()?['phone'],
              bio: value.data()?['bio'],
              profileImage: value.data()?['profileImage'],
              coverImage: value.data()?['coverImage'],
              uId: value.id,
          );

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ), (route) => false,
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BottomNavBar(
          //       name: value.data()?['name'],
          //       email: value.data()?['email'],
          //       phone: value.data()?['phone'],
          //       profileImage: value.data()?['profileImage'] == '' ?
          //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTs4XdD00sHtFKBYeyzKvz1CUHr598N0yrUA&usqp=CAU' :
          //       value.data()?['profileImage'],
          //       coverImage: value.data()?['coverImage'] == '' ?
          //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDBJ_hQ-aH41e7-2UWaMNnWAhNa2tkNT1fhQ&usqp=CAU':
          //       value.data()?['coverImage'],
          //       uId: value.id,
          //     ),
          //   ),
          //  );
        });
      });

    } on FirebaseAuthException catch (e) {
      log('==============================');
      log(e.code);
      log('==============================');
      if (e.code == 'user-not-found') {
        MySnackBar.showSnackBar(
            context: context,
            message: 'No user found for that email.',
            color: Colors.red,
        );
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        MySnackBar.showSnackBar(
          context: context,
          message: 'Wrong password provided for that user.',
          color: Colors.red,
        );
        log('Wrong password provided for that user.');
      }else if(e.code == 'INVALID_LOGIN_CREDENTIALS')
        {
          MySnackBar.showSnackBar(
            context: context,
            message: 'Wrong password or Email Address',
            color: Colors.red,
          );
        }else
        {
          MySnackBar.showSnackBar(
            context: context,
            message: 'Try again later',
            color: Colors.red,
          );
        }
      emit(LoginErrorState());
    }
  }

  Future<void> resetPassword({
    required String email,
    required context,
  })async
  {
    emit(ResetPasswordLoadingState());
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    ).then((value)
    {
      MySnackBar.showSnackBar(
        context: context,
        message: 'check your email and sign in again',
        color: Colors.green,
      );
      emit(ResetPasswordSuccessState());
    }).catchError((error)
    {
      emit(ResetPasswordErrorState());
    });

  }

  bool isVisible = false;
  void changePwVisibility()
  {
    isVisible = !isVisible;
    log('$isVisible');
    emit(ChangePwVisibleState());
  }

  void changeUserData({
    required UpdateUserDataModel updateUserDataModel,
})
  {
    userModel?.name = updateUserDataModel.name;
    userModel?.email = updateUserDataModel.email;
    userModel?.phone = updateUserDataModel.phone;
    userModel?.bio = updateUserDataModel.bio;
    emit(EditUserDataSuccessState());
  }

  Future<void> changeLoginState(bool isLogin)async
  {
    await SharedPrefs.saveLoginState(isLogin).then((value)
    {
      if(isLogin == true)
        {
          SharedPrefs.saveUserDataWhenLogin(
              [
                userModel!.uId,
                userModel!.name,
                userModel!.email,
                userModel!.phone,
              ],
          );
        }
      else{
        SharedPrefs.saveUserDataWhenLogin([]);
      }
      emit(SaveLoginState());
    });
  }

}
