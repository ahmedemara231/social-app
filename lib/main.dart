import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/view/auth_screens/login.dart';
import 'package:untitled10/view_model/add_post/cubit.dart';
import 'package:untitled10/view_model/add_post/states.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/auth_cubit/states.dart';
import 'package:untitled10/view_model/bloc-observer.dart';
import 'package:untitled10/view_model/chats/chats_cubit.dart';
import 'package:untitled10/view_model/chats/states.dart';
import 'package:untitled10/view_model/home-cubit/cubit.dart';
import 'package:untitled10/view_model/home-cubit/states.dart';
import 'package:untitled10/view_model/profile/cubit.dart';
import 'package:untitled10/view_model/profile/states.dart';
import 'package:untitled10/view_model/sharedPrefs/sharedPrefs.dart';
import 'package:untitled10/view_model/update_profile/cubit.dart';
import 'package:untitled10/view_model/update_profile/states.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initCacheMemory();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(InitialState()),
        ),
        BlocProvider(
          create: (context) => AddPostCubit(AddPostInitialState()),
        ),
        BlocProvider(
          create: (context) => HomeCubit(HomeInitialState()),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(ProfileInitialState()),
        ),
        BlocProvider(
          create: (context) => UpdateProfileCubit(UpdateProfileInitialState()),
        ),
        BlocProvider(
          create: (context) => ChatsCubit(ChatsInitialState()),
        ),
      ],
          child: BlocBuilder<ProfileCubit,ProfileStates>(
            builder: (context, state)
            {
              return BlocBuilder<AuthCubit,AuthStates>(
                builder: (context, state)
                {
                  return MaterialApp(
                    theme: SharedPrefs.sharedPreferences.getBool('appTheme') == false?
                    ThemeData.light():
                    ThemeData.dark(),
                    debugShowCheckedModeBanner: false,
                    home: const Login(),
                  );
                },
              );
            },
          ),
      );
  }
}


