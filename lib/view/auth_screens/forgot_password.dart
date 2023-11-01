import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/modules/textFormField.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/auth_cubit/states.dart';
import '../../modules/snackBar.dart';

class ForgotPassword extends StatelessWidget {
   ForgotPassword({super.key});

  var forgotPwCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit,AuthStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'forgot password',fontWeight: FontWeight.w500,),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                MyText(text: 'enter email address',fontSize: 20,fontWeight: FontWeight.w500,),
                const SizedBox(
                  height: 20,
                ),
                TFF(
                  obscureText: false,
                  controller: forgotPwCont,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'example@gmail.com',
                  hintStyle: const TextStyle(color: Colors.grey,fontSize: 18),
                  labelText: 'Email address',
                  labelStyle: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  onPressed: ()
                  {
                    if(forgotPwCont.text.isEmpty)
                    {
                      MySnackBar.showSnackBar(
                          context: context,
                          message: 'please enter your email'
                      );
                    }
                    else{
                      AuthCubit.getInstance(context).resetPassword(
                          email: forgotPwCont.text,
                          context: context
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.blue
                  ) ,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 12),
                    child: MyText(text: 'Send',color: Colors.white,fontSize: 20,),
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
/*
*  */