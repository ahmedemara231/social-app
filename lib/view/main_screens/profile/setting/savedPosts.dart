import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/models/profile_models.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/profile/cubit.dart';
import 'package:untitled10/view_model/profile/states.dart';

class SavedPosts extends StatefulWidget {
  const SavedPosts({super.key});

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {

  @override
  void initState() {
    ProfileCubit.getInstance(context).getSavedPosts(
        uId: AuthCubit.getInstance(context).userModel!.uId
    );
    ProfileCubit.getInstance(context).getSavedPostsIds(
        uId: AuthCubit.getInstance(context).userModel!.uId
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit,ProfileStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Saved Posts'),
          ),
          body: ProfileCubit.getInstance(context).savedPosts.isEmpty?
          Center(
            child: MyText(
            text: 'No saved posts yet',
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),):
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
              itemBuilder: (context, index) => Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: ProfileCubit.getInstance(context).savedPosts[index]['profileImage'] == '' ?
                      const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTs4XdD00sHtFKBYeyzKvz1CUHr598N0yrUA&usqp=CAU'))
                          : CircleAvatar(
                          backgroundImage: NetworkImage(
                              ProfileCubit.getInstance(context).savedPosts[index]['profileImage'])),
                      title: MyText(
                        text: ProfileCubit.getInstance(context)
                            .savedPosts[index]['userName'],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      subtitle: MyText(
                        text: ProfileCubit.getInstance(context)
                            .savedPosts[index]['time'],
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      trailing: IconButton(
                          onPressed: ()async
                          {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: MyText(text: 'Are you sure?'),
                                actions: [
                                  TextButton(
                                      onPressed: ()
                                      {
                                        Navigator.pop(context);
                                      }, child: MyText(text: 'Cancel',fontSize: 16,)),
                                  TextButton(
                                      onPressed: ()async
                                      {
                                        Navigator.pop(context);
                                        await ProfileCubit.getInstance(context).deleteSavedPost(
                                          deletePostModel: DeleteSavedPostModel(
                                              uId: AuthCubit.getInstance(context).userModel!.uId,
                                              postId: ProfileCubit.getInstance(context).savedPostsIds[index],
                                              index: index
                                          ),
                                          context: context,
                                        );
                                      }, child: MyText(text: 'Delete',fontSize: 16,))
                                ],
                            ),);
                          },
                          icon: const Icon(Icons.delete,color: Colors.red,),
                      ),
                    ),
                    MyText(
                      text: ProfileCubit.getInstance(context)
                          .savedPosts[index]['text'],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (ProfileCubit.getInstance(context).savedPosts[index]
                    ['photo'] == '')
                      MyText(text: ''),
                    if (ProfileCubit.getInstance(context).savedPosts[index]
                    ['photo'] != '')
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                              ProfileCubit.getInstance(context)
                                  .savedPosts[index]['photo'],
                          ),
                      ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 16,),
              itemCount: ProfileCubit.getInstance(context).savedPosts.length,
            ),
          ),
        );
      },
    );
  }
}
