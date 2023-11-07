import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:untitled10/models/addPost_model.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/view_model/add_post/cubit.dart';
import 'package:untitled10/view_model/add_post/states.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/home-cubit/cubit.dart';

class AddPost extends StatelessWidget {

  var postTextCont = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPostCubit,AddPostStates>(
      builder: (context, state)
      {
        return  Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: MyText(text: 'Add new post',fontWeight: FontWeight.w500,),
            actions: [
              FutureBuilder(
                future: FirebaseFirestore.instance.collection('user').doc(AuthCubit.getInstance(context).userModel!.uId).get(),
                builder: (context, snapshot)
                {
                  return TextButton(
                    onPressed: state is AddPostLoadingState? null : () async
                    {
                      if(formKey.currentState!.validate())
                      {
                        if(AddPostCubit.getInstance(context).selectedImage != null)
                        {
                          await AddPostCubit.getInstance(context).addPostWithPhoto(
                            addPostModel: AddPostModel(
                              userName: snapshot.data?.data()?['name'],
                              userProfileImage: snapshot.data?.data()?['profileImage'],
                              text: postTextCont.text,
                              time: Jiffy.now().yMMMdjm,
                              uId: snapshot.data!.id,
                            ),
                            pickedImage: AddPostCubit.getInstance(context).selectedImage!,
                            context: context,
                          ).then((value)
                          {
                            HomeCubit.getInstance(context).getAllPosts().then((value)
                            {
                              Navigator.pop(context);
                            });
                          });
                        }
                        else{
                          await AddPostCubit.getInstance(context).addPostWithoutPhoto(
                            addPostModel: AddPostModel(
                              text: postTextCont.text,
                              uId: snapshot.data!.id,
                              userName: snapshot.data?.data()?['name'],
                              userProfileImage: snapshot.data?.data()?['profileImage'],
                              time: Jiffy.now().yMMMdjm,
                            ),
                            context: context,
                          ).then((value)
                          {
                            HomeCubit.getInstance(context).getAllPosts().then((value)
                            {
                              Navigator.pop(context);
                            });
                          });
                        }
                      }
                    },
                    child: MyText(
                      text: 'Add post',
                      fontSize: 16,
                      color: state is AddPostLoadingState ?
                      Colors.grey : Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if(state is AddPostLoadingState)
                  const LinearProgressIndicator(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    FutureBuilder(
                      future: AddPostCubit.getInstance(context).getUserProfileImage(
                        context: context,
                        uId: AuthCubit.getInstance(context).userModel!.uId,
                      ),
                      builder: (context, snapshot)
                      {
                        if(snapshot.hasData)
                        {
                          return CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(snapshot.requireData),
                          );
                        }
                        else{
                          return MyText(text: '...');
                        }
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                            validator: (value)
                            {
                              if(value!.isEmpty)
                                {
                                  return 'This field can not be empty';
                                }
                            },
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400
                            ),
                            controller: postTextCont,
                            decoration:  InputDecoration(
                              errorStyle: const TextStyle(
                                fontSize: 19
                              ),
                              hintText: 'What\'s on your mind?',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1.3,
                                ),
                                borderRadius: BorderRadius.circular(30)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if(AddPostCubit.getInstance(context).selectedImage != null)
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Stack(
                          alignment: Alignment.topRight,
                            children:[
                              Image.file(AddPostCubit.getInstance(context).selectedImage!),
                              IconButton(
                                onPressed: ()
                                {
                                  AddPostCubit.getInstance(context).deleteSelectingPhoto();
                                },
                                icon: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 15,
                                child: Icon(Icons.close),
                               ),
                              )
                            ]),
                      ),
                  ),
                if(AddPostCubit.getInstance(context).selectedImage == null)
                  const Spacer(),
                TextButton(
                  onPressed: state is SelectImageForPostSuccessState? null : ()
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
                                  AddPostCubit.getInstance(context).selectImageForPost(
                                    source: ImageSource.camera,
                                  ).then((value)
                                  {
                                    Navigator.pop(context);
                                  });
                                }, child: MyText(text: 'Camera', fontSize: 18, fontWeight: FontWeight.bold,),
                            ),
                            TextButton(
                                onPressed: ()
                                {
                                  AddPostCubit.getInstance(context).selectImageForPost(
                                    source: ImageSource.gallery,
                                  ).then((value)
                                  {
                                    Navigator.pop(context);
                                  });
                                }, child: MyText(text: 'Gallery', fontSize: 18, fontWeight: FontWeight.bold,)),
                          ],
                        ),
                      ),
                    ),
                    );

                  },
                  child: MyText(
                    text: 'Add photo',
                    color: state is SelectImageForPostSuccessState?
                    Colors.grey : Colors.blue,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
