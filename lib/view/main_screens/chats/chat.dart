import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:untitled10/models/sendMessage_model.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/modules/textFormField.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/chats/chats_cubit.dart';
import 'package:untitled10/view_model/chats/states.dart';
import 'package:untitled10/view_model/sharedPrefs/sharedPrefs.dart';

class Chat extends StatelessWidget {

  String profileImageUrl;
  String name;
  String otherUserUId;

  Chat({super.key,
    required this.profileImageUrl,
    required this.name,
    required this.otherUserUId,
  });

  var formKey = GlobalKey<FormState>();
  var messageCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit,ChatsStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title : MyText(text: 'Chat'),
          ),
          body: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: profileImageUrl == '' ?
                    const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTs4XdD00sHtFKBYeyzKvz1CUHr598N0yrUA&usqp=CAU') :
                    NetworkImage(profileImageUrl),
                    radius: 50,
                  ),
                  const SizedBox(height: 16,),
                  MyText(text: name,fontWeight: FontWeight.w500,fontSize: 20,),
                  const SizedBox(height: 20,),
                  /////////////////////////////////////////
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(AuthCubit.getInstance(context).userModel!.uId)
                        .collection('chats')
                        .doc(otherUserUId)
                        .collection('messages')
                        .orderBy('time',descending: false,)
                        .snapshots(),
                    builder: (context, snapshot)
                    {
                      if(snapshot.hasData)
                        {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: ListView.separated(
                                  itemBuilder: (context, index) => Column(
                                    children: [
                                      if(snapshot.data?.docs[index].data()['senderUId'] == AuthCubit.getInstance(context).userModel?.uId)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: SharedPrefs.sharedPreferences.getBool('appTheme') == true?
                                              Colors.grey[700] :
                                              Colors.grey[300],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: MyText(
                                                text: snapshot.data?.docs[index]['message'],
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                    ),
                                      if(snapshot.data?.docs[index].data()['senderUId'] != AuthCubit.getInstance(context).userModel?.uId)
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          Container(
                                            decoration : BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: SharedPrefs.sharedPreferences.getBool('appTheme') == true?
                                              Colors.blue :
                                              Colors.blue[400],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: MyText(
                                                text: snapshot.data?.docs[index]['message'],
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ],
                                  ),
                                  separatorBuilder: (context, index) => const SizedBox(height: 16,),
                                  itemCount: snapshot.data!.docs.length
                              ),
                            ),
                          );
                        }
                      else{
                        return const Center(child: CircularProgressIndicator(),);
                      }
                    },
                  ),
                  ////////////////////////////////////////
                  Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: formKey,
                          child: TFF(
                            obscureText: false,
                            controller: messageCont,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)
                            ),
                            hintText: 'ex :hello',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: ()async
                        {
                          if(formKey.currentState!.validate())
                            {
                              await ChatsCubit.getInstance(context).sendMessage(
                                message: Message(
                                  message: messageCont.text,
                                  time: Jiffy.now().yMMMdjm,
                                  uId: AuthCubit.getInstance(context).userModel!.uId,
                                  senderUId: AuthCubit.getInstance(context).userModel!.uId,
                                  otherUserUId: otherUserUId,
                                )
                              ).then((value)
                              {
                                messageCont.clear();
                              });
                            }
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
