import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled10/view/auth_screens/forgot_password.dart';
import 'package:untitled10/models/auth_models.dart';
import 'package:untitled10/view/auth_screens/register.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/auth_cubit/states.dart';
import '../../modules/myText.dart';
import '../../modules/textFormField.dart';

class Login extends StatefulWidget {
   const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {
  var formKey = GlobalKey<FormState>();

  var emailCont = TextEditingController();

  var passCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height/7,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/3,
                            child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhHZ8ey7-do96PuMc0CHEO7rGumdi9P26X1Q&usqp=CAU')),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MyText(text: 'Welcome',fontSize: 25,fontWeight: FontWeight.bold,),
                    const SizedBox(
                      height: 35,
                    ),
                    TFF(
                        hintText: 'email address',
                        obscureText: false,
                        controller: emailCont,
                        prefixIcon: const Icon(Icons.email_outlined)
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TFF(
                        hintText: 'Password',
                        obscureText: AuthCubit.getInstance(context).isVisible? false : true,
                        controller: passCont,
                        prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed:()
                        {
                          AuthCubit.getInstance(context).changePwVisibility();
                        },
                        icon: AuthCubit.getInstance(context).isVisible?
                        const Icon(Icons.remove_red_eye) :
                            const Icon(Icons.visibility_off)
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if(state is LoginLoadingState)
                      CircleAvatar(
                        backgroundColor: HexColor('#00008B').withOpacity(.8),
                        radius: 30,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    if(state != LoginLoadingState())
                      ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#00008B').withOpacity(.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: ()async
                      {
                        if(formKey.currentState!.validate())
                          {
                             AuthCubit.getInstance(context).login(
                              context: context,
                              userLoginModel: UserLoginModel(
                                email: emailCont.text.trim(),
                                password: passCont.text.trim(),
                              )
                            ).then((value)
                            {
                              AuthCubit.getInstance(context).changeLoginState(true);
                            });
                          }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 120,
                          top: 15,
                          bottom: 15,
                          right: 120,
                        ),
                        child: MyText(
                          text: 'Login',
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      onPressed: ()
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ),
                        );
                      },
                      child: MyText(
                        text: 'Forgot Password?',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(text: 'Don\'t have an account?',fontSize: 17 ),
                        TextButton(
                          onPressed: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Register(),));
                          },
                          child: MyText(text: 'SignUp',fontSize: 17),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
