import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/modules/textFormField.dart';
import 'package:untitled10/view/main_screens/chats/chat.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/chats/chats_cubit.dart';
import 'package:untitled10/view_model/chats/states.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {

  @override
  void initState() {
    ChatsCubit.getInstance(context).getUsers(
        uId: AuthCubit.getInstance(context).userModel!.uId
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit,ChatsStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Users'),
          ),
          body: state is GetUsersSuccessState ?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                        onTap: ()
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Chat(
                                  name: ChatsCubit.getInstance(context).users[index]['name'],
                                  profileImageUrl: ChatsCubit.getInstance(context).users[index]['profileImage'],
                                  otherUserUId: ChatsCubit.getInstance(context).otherUserUId[index],
                                ),
                              ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: ChatsCubit.getInstance(context).users[index]['profileImage'] == ''?
                                const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTs4XdD00sHtFKBYeyzKvz1CUHr598N0yrUA&usqp=CAU') :
                                NetworkImage(ChatsCubit.getInstance(context).users[index]['profileImage']),
                              ),
                              title: MyText(
                                text: ChatsCubit.getInstance(context).users[index]['name'],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),

                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                      itemCount: ChatsCubit.getInstance(context).users.length
                  ),
                ),
              ],
            ),
          ) :
          const Center(child: CircularProgressIndicator(),)
        );
      },
    );
  }
}
