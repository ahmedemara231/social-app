import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/models/sendMessage_model.dart';
import 'package:untitled10/view_model/chats/states.dart';

class ChatsCubit extends Cubit<ChatsStates>
{
  ChatsCubit(super.initialState);

  static ChatsCubit getInstance(context) => BlocProvider.of(context);

  List<Map<String,dynamic>> users = [];
  List<String> otherUserUId = [];
  Future<void> getUsers({
    required String uId,
})async
  {
    emit(GetUsersLoadingState());
    users = [];
    FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((value)
     {
       value.docs.forEach((element) {
         if(element.id == uId)
           {
             log(element.id);
             return;
           }
         else{
           users.add(element.data());
           otherUserUId.add(element.id);
         }
       });
       emit(GetUsersSuccessState());
     },
    ).catchError((error)
    {
      emit(GetUsersErrorState(error: error.toString()));
      log(error.toString());
    });
  }

  // List<Map<String,dynamic>> messages = [];
  Future<void> sendMessage({
    required Message message,
})async
  {

    await FirebaseFirestore.instance
        .collection('user')
        .doc(message.uId)
        .collection('chats')
        .doc(message.otherUserUId)
        .collection('messages')
        .add(
        {
          'message' : message.message,
          'time' : message.time,
          'senderUId' : message.senderUId,
        },
    ).then((value)
    {
      FirebaseFirestore.instance
      .collection('user')
      .doc(message.otherUserUId)
      .collection('chats')
      .doc(message.uId)
      .collection('messages')
      .add(
          {
            'message' : message.message,
            'time' : message.time,
            'senderUId' : message.senderUId
          },
      ).then((value)
      {
          emit(SendMessageSuccessState());
        log('sent');
      }).catchError((error)
      {
        emit(SendMessageErrorState());
      });
    });
  }


}