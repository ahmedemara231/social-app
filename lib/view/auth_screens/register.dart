import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled10/models/auth_models.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/auth_cubit/states.dart';
import '../../modules/myText.dart';
import '../../modules/textFormField.dart';
import 'login.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final formKey = GlobalKey<FormState>();
  final nameCont = TextEditingController();
  final emailCont = TextEditingController();
  final passCont = TextEditingController();
  final confPassCont = TextEditingController();
  final phoneCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: 'SignUp',
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                          Row(
                            children: [
                              const Spacer(flex: 2,),
                              InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Card(
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Image.network(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkbnAZrEf5OshX7yDHRbxbuUUmfR7vUMsZUA&usqp=CAU')),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Card(
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Image.network(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcSUWGIs3vTxgqa_qQ-0etVCRtIvpxtSI9Xg&usqp=CAU')),
                                  ),
                                ),
                              ),
                              const Spacer(flex: 2,),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: MyText(
                              text: 'Or, register with email',
                              fontSize: 15,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TFF(
                              hintText: 'name',
                              obscureText: false,
                              controller: nameCont,
                              prefixIcon: const Icon(Icons.edit)
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TFF(
                              hintText: 'email address',
                              obscureText: false,
                              controller: emailCont,
                              prefixIcon: const Icon(Icons.email)
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TFF(
                              hintText: 'Password',
                              obscureText: false,
                              controller: passCont,
                              prefixIcon: const Icon(Icons.lock)
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TFF(
                              hintText: 'phone',
                              obscureText: false,
                              controller: phoneCont,
                              prefixIcon: const Icon(Icons.phone_android)
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if(state is RegisterLoadingState)
                      CircleAvatar(
                        backgroundColor: HexColor('#00008B').withOpacity(.8),
                        radius: 30,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                      if(state is! RegisterLoadingState)
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
                            await AuthCubit.getInstance(context).register(
                              context: context,
                              userRegisterModel: UserRegisterModel(
                                  email: emailCont.text.trim(),
                                  password: passCont.text.trim(),
                                  name: nameCont.text.trim(),
                                  phone: phoneCont.text.trim(),
                              ),
                            ).then((value)
                            {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ), (route) => false,
                              );
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
                          text: 'Sign up',
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
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
