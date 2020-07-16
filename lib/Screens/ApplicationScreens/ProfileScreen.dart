import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarni/Screens/ApplicationScreens/ChangePasswordScreen.dart';
import 'package:safarni/Screens/ApplicationScreens/EditProfileScreen.dart';
import 'package:safarni/Utilities/Constants.dart';
import 'package:safarni/View_Models/AuthenticationViewModel.dart';
import 'package:safarni/View_Models/MyProfileViewModel.dart';
import 'package:safarni/Widgets/UserProfileCard.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  var deviceSize;
  var authViewModel;
  String userID;
  TabController _tabController;

  ///this function is used as the popup menu selecting options to navigate to [EditProfileScreen()] or [ChangePasswordScreen()]
  void _onSelect(EditProfileNavigator value) {
    switch (value) {
      case EditProfileNavigator.editProfile:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EditProfileScreen()));
        break;
      case EditProfileNavigator.changePassword:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ChangePasswordScreen()));
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    userID = Provider.of<AuthenticationViewModel>(context, listen: false)
        .profileViewModel
        .user;
    Future.microtask(() {
      Provider.of<MyProfileViewModel>(context, listen: false)
          .fetchUserStats(userID);
      Provider.of<MyProfileViewModel>(context, listen: false)
          .fetchFollowing(userID);
      Provider.of<MyProfileViewModel>(context, listen: false)
          .fetchFollowers(userID);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authViewModel = Provider.of<AuthenticationViewModel>(context, listen: true);
    final myProfileViewModel =
        Provider.of<MyProfileViewModel>(context, listen: true);
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: myProfileViewModel.userStats == Status.loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 10,
                    backgroundColor: Theme.of(context).primaryColor,
                    pinned: true,
                    floating: false,
                    //snap: true,
                    expandedHeight: deviceSize.height * 0.34,
                    bottom: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      tabs: <Widget>[
                        _tab('0', ' Posts '),
                        _tab(
                            myProfileViewModel.numberOfFollowings, 'Following'),
                        _tab(myProfileViewModel.numberOfFollowers, 'Followers'),
                      ],
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: deviceSize.height * 0.13,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                0, deviceSize.height * 0.05, 0, 0),
                            child: CircleAvatar(
                              radius: deviceSize.height * 0.065,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                authViewModel.profileViewModel.displayPicture,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              authViewModel.profileViewModel.firstName +
                                  ' ' +
                                  authViewModel.profileViewModel.lastName,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: deviceSize.width * 0.08,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          // Container(
                          //   width: deviceSize.width * 0.2,
                          //   height: deviceSize.height*0.08,
                          //    padding: EdgeInsets.symmetric(vertical:deviceSize.height*0.02),
                          //   child: FloatingActionButton(
                          //       backgroundColor: Theme.of(context).accentColor,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(20.0),
                          //       ),
                          //       child: Text(
                          //         'Follow',
                          //         style: TextStyle(color: Theme.of(context).primaryColor),
                          //       ),
                          //       onPressed: (() {})),
                          // ),
                          // Container(
                          //   width: deviceSize.width * 0.25,
                          //   height: deviceSize.height*0.08,
                          //    padding: EdgeInsets.symmetric(vertical:deviceSize.height*0.02),
                          //   child: FloatingActionButton(
                          //       backgroundColor: Theme.of(context).accentColor,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(20.0),
                          //       ),
                          //       child: Text(
                          //         'Unfollow',
                          //         style: TextStyle(color: Theme.of(context).primaryColor),
                          //       ),
                          //       onPressed: (() {})),
                          // )
                        ],
                      ),
                    ),
                    automaticallyImplyLeading: true,
                    actions: <Widget>[
                      PopupMenuButton<EditProfileNavigator>(
                        onSelected: _onSelect,
                        itemBuilder: (context) =>
                            <PopupMenuEntry<EditProfileNavigator>>[
                          PopupMenuItem<EditProfileNavigator>(
                            value: EditProfileNavigator.editProfile,
                            child: Text("Edit profile"),
                          ),
                          PopupMenuItem<EditProfileNavigator>(
                            value: EditProfileNavigator.changePassword,
                            child: Text("Change password"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  myProfileViewModel.postsStatus == Status.loading
                      ? Center(
                          child: Text("No posts yet!!"),
                        )
                      : ListView.builder(
                          itemCount: myProfileViewModel.following.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              value: myProfileViewModel.following[index],
                              child: UserProfileCard(
                                deviceSize: deviceSize,
                                i: index,
                              ),
                            );
                          },
                        ),
                  myProfileViewModel.followingStatus == Status.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        )
                      : (myProfileViewModel.followingStatus == Status.empty
                          ? Center(
                              child: Text("You didn't follow any user yet!!"),
                            )
                          : ListView.builder(
                              itemCount: myProfileViewModel.following.length,
                              itemBuilder: (context, index) {
                                return ChangeNotifierProvider.value(
                                  value: myProfileViewModel.following[index],
                                  child: UserProfileCard(
                                    deviceSize: deviceSize,
                                    i: index,
                                  ),
                                );
                              },
                            )),
                  myProfileViewModel.followersStatus == Status.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        )
                      : (myProfileViewModel.followersStatus == Status.empty
                          ? Center(
                              child: Text("You don't have followers yet!!"),
                            )
                          : ListView.builder(
                              itemCount: myProfileViewModel.followers.length,
                              itemBuilder: (context, index) {
                                return ChangeNotifierProvider.value(
                                  value: myProfileViewModel.followers[index],
                                  child: UserProfileCard(
                                    deviceSize: deviceSize,
                                    i: index,
                                  ),
                                );
                              },
                            )),
                ],
              ),
            ),
    );
  }

  Widget _tab(String number, String text) {
    return Container(
      height: deviceSize.height * 0.08,
      child: Tab(
        iconMargin: EdgeInsets.only(left: deviceSize.width * 0.2),
        child: Column(
          children: <Widget>[
            Text(
              number,
              style: TextStyle(fontSize: deviceSize.width * 0.055),
            ),
            //SizedBox(height: deviceSize.height*0.01),
            Text(
              text,
              style: TextStyle(fontSize: deviceSize.width * 0.045),
            )
          ],
        ),
      ),
    );
  }
}
