class ChatsStates {}

class ChatsInitialState extends ChatsStates {}

class GetUsersLoadingState extends ChatsStates {}

class GetUsersSuccessState extends ChatsStates {}

class GetUsersErrorState extends ChatsStates {
  String error;

  GetUsersErrorState({
    required this.error,
});
}

class SendMessageSuccessState extends ChatsStates{}

class SendMessageErrorState extends ChatsStates{}
