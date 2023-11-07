import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled10/models/updateProfile_models.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/modules/textFormField.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/auth_cubit/states.dart';
import '../../../view_model/update_profile/cubit.dart';
import '../../../view_model/update_profile/states.dart';

class EditProfile extends StatefulWidget {

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var editNameCont = TextEditingController();

  var editEmailCont = TextEditingController();

  var editPhoneCont = TextEditingController();

  var editBioCont = TextEditingController();

  @override
  void initState() {
    editNameCont.text = AuthCubit.getInstance(context).userModel!.name;
    editEmailCont.text = AuthCubit.getInstance(context).userModel!.email;
    editPhoneCont.text = AuthCubit.getInstance(context).userModel!.phone;
    editBioCont.text = AuthCubit.getInstance(context).userModel!.bio;
    super.initState();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileCubit, UpdateProfileStates>(
      builder: (context, state) => BlocBuilder<AuthCubit, AuthStates>(
        builder: (context, state) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(AuthCubit.getInstance(context).userModel?.uId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    title: MyText(
                      text: 'Edit your profile',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state is UpdateUserDataLoadingState)
                            const LinearProgressIndicator(),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 4.5,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  child: snapshot.data?.data()?['coverImage'] == '' ?
                                      // AuthCubit.getInstance(context).userModel.coverImage.isEmpty?
                                      Image.network(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDBJ_hQ-aH41e7-2UWaMNnWAhNa2tkNT1fhQ&usqp=CAU',
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          snapshot.data?.data()?['coverImage'],
                                          fit: BoxFit.contain,
                                        ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.blue,
                                        child: IconButton(
                                            onPressed: ()
                                            {
                                              scaffoldKey.currentState?.showBottomSheet((context) => SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      MyText(
                                                        text: 'choose photo from ?',
                                                        fontSize: 22,
                                                      ),
                                                      TextButton(
                                                        onPressed: ()
                                                        {
                                                          UpdateProfileCubit.getInstance(context).updateCoverImage(
                                                            uId: AuthCubit.getInstance(context).userModel!.uId,
                                                            method: ImageSource.camera,
                                                            context: context,
                                                          ).then((value)
                                                          {
                                                            Navigator.pop(context);
                                                          });
                                                        },
                                                        child: MyText(
                                                          text: 'Camera',
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: ()
                                                        {
                                                          UpdateProfileCubit.getInstance(context).updateCoverImage(
                                                            uId: AuthCubit.getInstance(context).userModel!.uId,
                                                            method: ImageSource.gallery,
                                                            context: context,
                                                          ).then((value)
                                                          {
                                                            Navigator.pop(context);
                                                          });
                                                        },
                                                        child: MyText(
                                                          text: 'Gallery',
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.camera_alt_outlined,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                        ),
                                      ),
                                    )),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width/3,
                                    height: MediaQuery.of(context).size.width/3,
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 63,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundImage: snapshot.data
                                                        ?.data()?['profileImage'] == '' ?
                                            const NetworkImage(
                                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTs4XdD00sHtFKBYeyzKvz1CUHr598N0yrUA&usqp=CAU',
                                                  )
                                                : NetworkImage(
                                                    snapshot.data?.data()?['profileImage'],
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.blue,
                                            child: IconButton(
                                              onPressed: ()
                                              {
                                                scaffoldKey.currentState?.showBottomSheet((context) => SizedBox(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        MyText(
                                                          text: 'choose photo from ?',
                                                          fontSize: 22,
                                                        ),
                                                        TextButton(
                                                          onPressed: ()
                                                          {
                                                            UpdateProfileCubit.getInstance(context).updateProfileImage(
                                                              uId: AuthCubit.getInstance(context).userModel!.uId,
                                                              method: ImageSource.camera,
                                                              context: context,
                                                            ).then((value)
                                                            {
                                                              Navigator.pop(context);
                                                            });
                                                          },
                                                          child: MyText(
                                                            text: 'Camera',
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: ()
                                                          {
                                                            UpdateProfileCubit.getInstance(context).updateProfileImage(
                                                              uId: AuthCubit.getInstance(context).userModel!.uId,
                                                              method: ImageSource.gallery,
                                                              context: context,
                                                            ).then((value)
                                                            {
                                                              Navigator.pop(context);
                                                            });
                                                          },
                                                          child: MyText(
                                                            text: 'Gallery',
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                      ),
                                                  ),
                                                ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 22,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TFF(
                            obscureText: false,
                            controller: editNameCont,
                            prefixIcon: const Icon(Icons.edit),
                            hintText: 'Name',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    width: 1.2
                                )
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TFF(
                            obscureText: false,
                            controller: editEmailCont,
                            prefixIcon: const Icon(Icons.email_outlined),
                            hintText: 'email-address',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                width: 1.2
                              )
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TFF(
                            obscureText: false,
                            controller: editPhoneCont,
                            prefixIcon: const Icon(Icons.phone),
                            hintText: 'phone',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    width: 1.2
                                )
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TFF(
                            obscureText: false,
                            controller: editBioCont,
                            prefixIcon: const Icon(Icons.edit),
                            hintText: 'Bio',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    width: 1.2
                                )
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: editNameCont.text == AuthCubit.getInstance(context).userModel?.name &&
                                      editEmailCont.text == AuthCubit.getInstance(context).userModel?.email &&
                                      editPhoneCont.text == AuthCubit.getInstance(context).userModel?.phone &&
                                      editBioCont.text == AuthCubit.getInstance(context).userModel?.bio?
                                  Colors.grey :
                                  Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: editNameCont.text == AuthCubit.getInstance(context).userModel?.name &&
                                    editEmailCont.text == AuthCubit.getInstance(context).userModel?.email &&
                                    editPhoneCont.text == AuthCubit.getInstance(context).userModel?.phone&&
                                    editBioCont.text == AuthCubit.getInstance(context).userModel?.bio ?
                                null : () {
                                        UpdateProfileCubit.getInstance(context).updateUserData(
                                          updateUserDataModel: UpdateUserDataModel(
                                            name: editNameCont.text,
                                            bio: editBioCont.text,
                                            phone: editPhoneCont.text,
                                            email: editPhoneCont.text,
                                            uId: AuthCubit.getInstance(context).userModel!.uId,
                                          ),
                                          context: context,
                                        ).then((value) {
                                          AuthCubit.getInstance(context).changeUserData(
                                            updateUserDataModel: UpdateUserDataModel(
                                              name: editNameCont.text,
                                              email: editEmailCont.text,
                                              phone: editPhoneCont.text,
                                              bio: editBioCont.text,
                                            ),
                                          );
                                        });
                                      },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 20,
                                    bottom: 20,
                                    left: MediaQuery.of(context).size.width / 5,
                                    right:
                                        MediaQuery.of(context).size.width / 5,
                                  ),
                                  child: MyText(
                                    text: 'Update',
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return MyText(text: '');
              }
            },
          );
        },
      ),
    );
  }
}
