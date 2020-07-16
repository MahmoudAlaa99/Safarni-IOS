//import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:safarni/View_Models/ChangePasswordViewModel.dart';
import 'package:safarni/View_Models/MyProfileViewModel.dart';

import 'Screens/ApplicationScreens/MainScreen.dart';
import 'Screens/Login_Signup/IntroScreen.dart';

import 'Screens/Login_Signup/SplashScreen.dart';
import 'Utilities/Constants.dart';
import 'View_Models/AuthenticationViewModel.dart';
import './Screens/ApplicationScreens/ProfileScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthenticationViewModel(),
        ),
        ChangeNotifierProxyProvider<AuthenticationViewModel,
            ChangePasswordViewModel>(
          create: (ctx) => ChangePasswordViewModel(
            accessToken: '',
          ),
          update: (ctx, auth, previous) => ChangePasswordViewModel(
            accessToken: auth.accessToken,
          ),
        ),
        ChangeNotifierProxyProvider<AuthenticationViewModel,
            MyProfileViewModel>(
          create: (ctx) => MyProfileViewModel(
              accessToken: '',
              skip: 0,
              followers: [],
              following: [],
              userStats: Status.loading,
              numberOfFollowers: '0',
              numberOfFollowings: '0'),
          update: (ctx, auth, previous) => MyProfileViewModel(
            accessToken: auth.accessToken,
            skip: previous.skip,
            followers: previous.followers == [] ? [] : previous.followers,
            following: previous.following == [] ? [] : previous.following,
            userStats: previous.userStats,
            numberOfFollowers: previous.numberOfFollowers,
            numberOfFollowings: previous.numberOfFollowings,
          ),
        ),
      ],
      child: Consumer<AuthenticationViewModel>(
        builder: (ctx, auth, _) => CupertinoApp(
          theme: CupertinoThemeData(
            primaryColor: CupertinoColors.systemPurple,
            scaffoldBackgroundColor: CupertinoColors.white,
          ),
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? MainScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(context),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : IntroScreen(),
                ),
          routes: {
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
          },
        ),
      ),
    );
  }
}
