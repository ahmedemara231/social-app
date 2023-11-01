import 'package:untitled10/view_model/auth_cubit/cubit.dart';

class AuthStates{}

class InitialState extends AuthStates{}

//login
class LoginLoadingState extends AuthStates{}
class LoginSuccessState extends AuthStates{}
class LoginErrorState extends AuthStates{}

//register
class RegisterLoadingState extends AuthStates{}

class RegisterSuccessState extends AuthStates{}

class RegisterErrorState extends AuthStates{}

class ChangePwVisibleState extends AuthStates{}

// edit user data
class EditUserDataSuccessState extends AuthStates{}

// saveLoginState
class SaveLoginState extends AuthStates{}

//reset password
class ResetPasswordLoadingState extends AuthStates{}

class ResetPasswordSuccessState extends AuthStates{}

class ResetPasswordErrorState extends AuthStates{}