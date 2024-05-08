import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:untitled10/models/home_models.dart';
import 'package:untitled10/modules/mine_custom_divider.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/modules/textFormField.dart';
import 'package:untitled10/view/main_screens/add_post/add_post.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/auth_cubit/states.dart';
import 'package:untitled10/view_model/home-cubit/cubit.dart';
import 'package:untitled10/view_model/home-cubit/states.dart';
import 'package:untitled10/view_model/sharedPrefs/sharedPrefs.dart';
import 'edit_post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    HomeCubit.getInstance(context).getAllPosts();
    super.initState();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final commentCont = TextEditingController();
  // الداتا كلها من الفاير ماعدا الappBar
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return BlocBuilder<AuthCubit, AuthStates>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: MyText(
                  text:
                  'Hello ${AuthCubit.getInstance(context).userModel?.name}',
                  fontWeight: FontWeight.w500,
                ),
              ),
              body: HomeCubit.getInstance(context).finalPostsList.isNotEmpty &&
                HomeCubit.getInstance(context).finalPostsIdsList.isNotEmpty?
              ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: AuthCubit.getInstance(context)
                            .userModel!
                            .profileImage
                            .isEmpty
                            ? const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTs4XdD00sHtFKBYeyzKvz1CUHr598N0yrUA&usqp=CAU'))
                            : CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              AuthCubit.getInstance(context)
                                  .userModel!
                                  .profileImage),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPost(),
                              ),
                            );
                          },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: SharedPrefs.sharedPreferences.getBool('appTheme') == false?
                                  Colors.grey[300]:
                                  Colors.grey[800],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0,horizontal: 16),
                                  child: MyText(text: 'What\'s on your mind?'),
                                )
                              ),
                            ),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: HomeCubit.getInstance(context)
                                  .finalPostsList[index]
                              ['userProfileImage'] ==
                                  ''
                                  ? const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTs4XdD00sHtFKBYeyzKvz1CUHr598N0yrUA&usqp=CAU'))
                                  : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      HomeCubit.getInstance(context)
                                          .finalPostsList[index]
                                      ['userProfileImage'])),
                              title: MyText(
                                text: HomeCubit.getInstance(context)
                                    .finalPostsList[index]['userName'],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              // subtitle: MyText(
                              //   text: HomeCubit.getInstance(context)
                              //       .finalPostsList[index]['time'],
                              //   color: Colors.grey,
                              //   fontSize: 15,
                              //   fontWeight: FontWeight.w500,
                              // ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) =>
                                [
                                  if(HomeCubit.getInstance(context).finalPostsList[index]['uId'] != AuthCubit.getInstance(context).userModel!.uId)
                                    PopupMenuItem(
                                    onTap: () async {
                                      await HomeCubit.getInstance(context).savePost(
                                        savePostModel: SavePostModel(
                                          text: HomeCubit.getInstance(context).finalPostsList[index]['text'],
                                          time: HomeCubit.getInstance(context).finalPostsList[index]['time'],
                                          userName:  HomeCubit.getInstance(context).finalPostsList[index]['userName'],
                                          posterId: HomeCubit.getInstance(context).finalPostsList[index]['uId'],
                                          uId: AuthCubit.getInstance(context).userModel!.uId,
                                          profileImage: HomeCubit.getInstance(context).finalPostsList[index]['userProfileImage'],
                                          photo: HomeCubit.getInstance(context).finalPostsList[index]['photo'],
                                          index: index,
                                        ),
                                        context: context,
                                      );
                                    },
                                    child: MyText(
                                      text: 'Save Post',
                                      fontSize: 16,
                                    ),
                                  ),
                                  if(HomeCubit.getInstance(context).finalPostsList[index]['uId'] == AuthCubit.getInstance(context).userModel!.uId)
                                    PopupMenuItem(
                                      onTap: ()async
                                      {
                                        await HomeCubit.getInstance(context).deletePost(
                                          context: context,
                                          index: index,
                                          uId: AuthCubit.getInstance(context).userModel!.uId,
                                        );
                                      },
                                      child: MyText(
                                        text: 'Delete post',
                                        fontSize: 16,
                                      ),
                                    ),
                                  if(HomeCubit.getInstance(context).finalPostsList[index]['uId'] == AuthCubit.getInstance(context).userModel!.uId)
                                    PopupMenuItem(
                                      onTap: ()
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditPost(
                                                post: HomeCubit.getInstance(context).finalPostsList[index],
                                                index: index,
                                              ),
                                            ),
                                        );
                                      },
                                      child: MyText(
                                        text: 'Edit Caption',
                                        fontSize: 16,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyText(
                                text: HomeCubit.getInstance(context)
                                    .finalPostsList[index]['text'],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (HomeCubit.getInstance(context).finalPostsList[index]
                            ['photo'] == null)
                              MyText(text: ''),
                            if (HomeCubit.getInstance(context).finalPostsList[index]
                            ['photo'] != null)
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                      HomeCubit.getInstance(context)
                                          .finalPostsList[index]['photo'])),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection('posts').doc(HomeCubit.getInstance(context).finalPostsIdsList[index]).collection('likes').snapshots(),
                                      builder: (context, snapshot)
                                      {
                                        if(snapshot.hasData)
                                        {
                                          return MyText(
                                            text: '${snapshot.data!.docs.length} Likes',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          );
                                        }
                                        else{
                                          return MyText(text: '...');
                                        }

                                      },
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: ()
                                    {
                                      HomeCubit.getInstance(context).postIndex = index;
                                      log('============================');
                                      log('${HomeCubit.getInstance(context).postIndex}');
                                      log('============================');
                                      HomeCubit.getInstance(context).getPostCommentsIds(
                                        index: index,
                                      ).then((value)
                                      {
                                        HomeCubit.getInstance(context).getAllComments(
                                          index: index,
                                        ).then((value)
                                        {
                                          scaffoldKey.currentState?.showBottomSheet((context) => SizedBox(
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: SizedBox(
                                                height: MediaQuery.of(context).size.height/1.2,
                                                width: double.infinity,
                                                child: Column(
                                                  children: [
                                                    MyText(
                                                      text: 'All comments',
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: MediaQuery.of(context).size.height/1.4,
                                                        child: HomeCubit.getInstance(context).allComments.isEmpty?
                                                        Center(
                                                            child: MyText(
                                                              text: 'No comments yet',
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 20,
                                                            )) :
                                                        ListView.separated(
                                                          itemBuilder: (context, index) => Card(
                                                            elevation: 3,
                                                            child: ListTile(
                                                              leading: CircleAvatar(
                                                                backgroundImage: HomeCubit.getInstance(context).allComments[index]?['userProfileImage'] == ''?
                                                                const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTs4XdD00sHtFKBYeyzKvz1CUHr598N0yrUA&usqp=CAU'):
                                                                NetworkImage(HomeCubit.getInstance(context).allComments[index]?['userProfileImage']),
                                                                radius: 30,
                                                              ),
                                                              title: MyText(
                                                                text: HomeCubit.getInstance(context).allComments[index]?['name'],
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                              subtitle: Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                child: MyText(text: HomeCubit.getInstance(context).allComments[index]?['comment'],fontWeight: FontWeight.w500,fontSize: 18,),
                                                              ),
                                                              trailing: HomeCubit.getInstance(context).allComments[index]?['uId'] == AuthCubit.getInstance(context).userModel!.uId?
                                                              PopupMenuButton(
                                                                itemBuilder: (context) =>
                                                                [
                                                                    PopupMenuItem(
                                                                    child: MyText(
                                                                      text: 'edit',fontSize: 16,
                                                                    ),
                                                                    onTap: () {},
                                                                  ),
                                                                    PopupMenuItem(
                                                                    child: MyText(
                                                                      text: 'Delete',
                                                                      fontSize: 16,
                                                                    ),
                                                                    onTap: ()async
                                                                    {
                                                                      await HomeCubit.getInstance(context).deleteComment(
                                                                        context: context,
                                                                        commentIndex: index,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ):
                                                              null,
                                                            ),
                                                          ),
                                                          separatorBuilder: (context, index) => const SizedBox(
                                                            height: 16,
                                                          ),
                                                          itemCount: HomeCubit.getInstance(context).allComments.length,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                        },
                                        );
                                      });
                                    },
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection('posts').doc(HomeCubit.getInstance(context).finalPostsIdsList[index]).collection('comments').snapshots(),
                                      builder: (context, snapshot)
                                      {
                                        if(snapshot.hasData)
                                        {
                                          return MyText(
                                            text: '${snapshot.data?.docs.length} comments',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          );
                                        }
                                        else{
                                          return MyText(text: '...');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async
                                      {
                                        HomeCubit.getInstance(context).getAllLikesForPost(
                                          index: index,
                                        ).then((value)
                                        {
                                          // HomeCubit.getInstance(context).detectUserLike(
                                          //     uId: AuthCubit.getInstance(context).userModel!.uId,
                                          //     index: index,
                                          // );
                                        }
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.favorite_outline_sharp,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          MyText(
                                            text: 'Like',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: ()
                                      {
                                        scaffoldKey.currentState?.showBottomSheet((context) => SizedBox(
                                          height: MediaQuery.of(context).size.height/4,
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: NewDivider(),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Form(
                                                  key: formKey,
                                                  child: TFF(
                                                    prefixIcon: const Icon(Icons.edit),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(30)
                                                    ),
                                                    obscureText: false,
                                                    controller: commentCont,
                                                    labelText: 'Write a comment',
                                                    labelStyle: const TextStyle(
                                                      fontSize: 19,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              FutureBuilder(
                                                future: FirebaseFirestore.instance.collection('user').doc(AuthCubit.getInstance(context).userModel!.uId).get(),
                                                builder: (context, snapshot)
                                                {
                                                  return ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.blue,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                    ),
                                                    onPressed: ()
                                                    {
                                                      if(formKey.currentState!.validate())
                                                      {
                                                        HomeCubit.getInstance(context).writeComment(
                                                          commentModel: CommentModel(
                                                              comment: commentCont.text,
                                                              name: snapshot.data?.data()?['name'],
                                                              time: Jiffy.now().yMMMdjm,
                                                              uId: AuthCubit.getInstance(context).userModel!.uId,
                                                              profileImage: snapshot.data?.data()?['profileImage'],
                                                              index: index
                                                          ),
                                                        ).then((value)
                                                        {
                                                          commentCont.clear();
                                                          Navigator.pop(context);
                                                        });
                                                      }
                                                    },
                                                    child: MyText(
                                                      text: 'Comment',
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.comment_outlined,
                                              color: Colors.blue),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          MyText(
                                            text: 'comment',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                      itemCount: HomeCubit.getInstance(context).finalPostsList.length,
                    ),
                  ),
                ]) :
              const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }
}
