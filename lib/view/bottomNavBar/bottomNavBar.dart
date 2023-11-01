import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/view/main_screens/Home/home.dart';
import 'package:untitled10/view/main_screens/profile/profile.dart';
import 'package:untitled10/view_model/home-cubit/cubit.dart';
import 'package:untitled10/view_model/home-cubit/states.dart';
import '../main_screens/chats/users.dart';

class BottomNavBar extends StatelessWidget {

//   UserModel currentUser;
  const BottomNavBar();

  @override
  Widget build(BuildContext context) {
    List<Widget> mainScreens =
    [
      Home(
        // currentUser: currentUser,
      ),
      Users(),
      Profile(),
    ];
    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            selectedIconTheme: const IconThemeData(
              size: 25,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            unselectedIconTheme: const IconThemeData(
              color: Colors.grey
            ),
            currentIndex: HomeCubit.getInstance(context).currentIndex,
            onTap: (value)
            {
              HomeCubit.getInstance(context).changeCurrentIndex(newIndex: value);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chats'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile'
              ),
            ],
          ),
          body: mainScreens[HomeCubit.getInstance(context).currentIndex],
        );
      },
    );
  }
}
