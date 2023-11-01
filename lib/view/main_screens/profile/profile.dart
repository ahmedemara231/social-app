import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/modules/snackBar.dart';
import 'package:untitled10/view/main_screens/profile/edit_profile.dart';
import 'package:untitled10/view/main_screens/profile/setting/setting.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/auth_cubit/states.dart';
import 'package:untitled10/view_model/profile/cubit.dart';
import 'package:untitled10/view_model/profile/states.dart';
import '../../../modules/myText.dart';

class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    ProfileCubit.getInstance(context).getPostsForCurrentUser(
      uId: AuthCubit.getInstance(context).userModel!.uId,
    );
    // TODO: implement initState
    super.initState();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  //  هنا كل الداتا جاية من الفاير ماعدا البوستات
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit,ProfileStates>(
      builder: (context, state)
      {
        return BlocBuilder<AuthCubit,AuthStates>(
          builder: (context, state)
          {
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('user').doc(AuthCubit.getInstance(context).userModel?.uId).snapshots(),
              builder: (context, snapshot)
              {
                if(snapshot.hasData)
                  {
                    return Scaffold(
                      key: scaffoldKey,
                      appBar: AppBar(
                        title: MyText(text: 'Profile',fontWeight: FontWeight.w500,),
                        actions: [
                          IconButton(
                              onPressed: ()
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  const Setting(),
                                    ),
                                );
                              },
                              icon: const Icon(Icons.linear_scale),
                          )
                        ],
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height/4.5,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height/5,
                                    child: snapshot.data?.data()?['coverImage'] == ''?
                                    Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDBJ_hQ-aH41e7-2UWaMNnWAhNa2tkNT1fhQ&usqp=CAU',
                                      fit: BoxFit.contain,):
                                    Image.network(
                                      snapshot.data?.data()?['coverImage'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width/3,
                                      height: MediaQuery.of(context).size.width/3,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 63,
                                            backgroundColor: Colors.white,
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 60,
                                            child: CircleAvatar(
                                              radius: 60,
                                              backgroundImage: snapshot.data?.data()?['profileImage'] == ''?
                                              const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTs4XdD00sHtFKBYeyzKvz1CUHr598N0yrUA&usqp=CAU',):
                                              NetworkImage(snapshot.data?.data()?['profileImage']),
                                            ),
                                          ),
                                        ],
                                        // child:
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            MyText(
                              text : snapshot.data?.data()?['name'],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            MyText(
                              text: snapshot.data?.data()?['bio'],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(16)
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: ()
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfile(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width/3.5
                                    ),
                                    child: MyText(
                                      text: 'Edit your profile',
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            MyText(
                              text: 'Your posts',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            if(state is GetUserPostsLoadingState)
                              const Center(child: CircularProgressIndicator()),
                            if(ProfileCubit.getInstance(context).currentUserPosts.isEmpty)
                              Center(
                                  child: MyText(
                                      text: 'No posts yet',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                              ),
                            if(ProfileCubit.getInstance(context).currentUserPosts.isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius : 25,
                                          backgroundImage: NetworkImage(
                                            ProfileCubit.getInstance(context).currentUserPosts[index]['userProfileImage'],
                                          ),
                                        ),
                                        title: MyText(
                                          text: ProfileCubit.getInstance(context).currentUserPosts[index]['userName'],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        subtitle: MyText(
                                          text: ProfileCubit.getInstance(context).currentUserPosts[index]['time'],
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.settings)),
                                      ),
                                      MyText(
                                        text: ProfileCubit.getInstance(context).currentUserPosts[index]['text'],
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      if (ProfileCubit.getInstance(context).currentUserPosts[index]['photo'] == null)
                                        MyText(text: ''),
                                      if (ProfileCubit.getInstance(context).currentUserPosts[index]['photo'] != null)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.network(
                                              ProfileCubit.getInstance(context).currentUserPosts[index]['photo']),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            MyText(
                                              text: '10 Likes',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: ()
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
                                                              child: ProfileCubit.getInstance(context).currentUserPostsComments.isEmpty?
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
                                                                      backgroundImage: NetworkImage(ProfileCubit.getInstance(context).currentUserPostsComments[index]['userProfileImage']),
                                                                      radius: 30,
                                                                    ),
                                                                    title: MyText(text: ProfileCubit.getInstance(context).currentUserPostsComments[index]['name'],fontWeight: FontWeight.w500,),
                                                                    subtitle: MyText(text: ProfileCubit.getInstance(context).currentUserPostsComments[index]['comment'],fontWeight: FontWeight.w500,fontSize: 18,),
                                                                    trailing: MyText(text: ProfileCubit.getInstance(context).currentUserPostsComments[index]['time']),
                                                                  ),
                                                                ),
                                                                separatorBuilder: (context, index) => const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                itemCount: ProfileCubit.getInstance(context).currentUserPostsComments.length,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                              },
                                              child: MyText(
                                                text: '${ProfileCubit.getInstance(context).currentUserPostsComments.length} comments',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
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
                                    ],
                                  ),
                                ),
                                separatorBuilder: (context, index) => const SizedBox(height: 16,),
                                itemCount: ProfileCubit.getInstance(context).currentUserPosts.length,
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                else if(snapshot.connectionState == ConnectionState.waiting)
                  {
                    return const Center(child: CircularProgressIndicator());
                  }
                else {
                  MySnackBar.showSnackBar(
                      context: context,
                      message: 'try again latter',
                      color: Colors.red,
                  );
                }
                return MyText(text: '');
              },
            );
          },
        );
      },
    );
  }
}
