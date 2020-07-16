import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/models/persisten-bottom-nav-item.widget.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-bottom-nav-bar-styles.widget.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-nav-bar-scaffold.widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:provider/provider.dart';
import 'package:safarni/View_Models/AuthenticationViewModel.dart';
import '../ApplicationScreens/HomeScreen.dart';
import '../ApplicationScreens/ProfileScreen.dart';
import '../../Utilities/Functions.dart';
import '../../Utilities/Constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PersistentTabController _controller;
  var deviceSize;
  var provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthenticationViewModel>(context);
    deviceSize = MediaQuery.of(context).size;
    _controller = PersistentTabController(initialIndex: 0);
    return provider.status == Status.loading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).accentColor,
            appBar: AppBar(
              flexibleSpace: SizedBox(
                height: deviceSize.height * 0.6,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              actions: <Widget>[
                Container(
                  height: deviceSize.height * 0.06,
                  width: deviceSize.height * 0.06,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      right: deviceSize.width * 0.05,
                      bottom: deviceSize.height * 0.01),
                  child: CircleAvatar(
                    radius: deviceSize.height * 0.03,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      provider.profileViewModel.displayPicture,
                    ),
                  ),
                ),
              ],
            ),
            body: PersistentTabView(
              controller: _controller,
              items: _navBarsItems(),
              screens: _buildScreens(),
              showElevation: true,
              navBarCurve: NavBarCurve.upperCorners,
              confineInSafeArea: true,
              handleAndroidBackButtonPress: true,
              iconSize: 26.0,
              navBarStyle: NavBarStyle
                  .style1, // Choose the nav bar style with this property
              onItemSelected: (index) {
                print(index);
              },
            ),
            drawer: Drawer(
                child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: deviceSize.height * 0.1,
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              0, 0, deviceSize.width * 0.07, 0),
                          child: CircleAvatar(
                            radius: deviceSize.height * 0.05,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                provider.profileViewModel.displayPicture),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: deviceSize.width * 0.45,
                              child: Text(
                                provider.profileViewModel.firstName +
                                    ' ' +
                                    provider.profileViewModel.lastName,
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: deviceSize.width * 0.06),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: deviceSize.width * 0.45,
                              child: Text(
                                provider.profileViewModel.userName,
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: deviceSize.width * 0.045,
                                    color: Colors.black54,
                                    height: 0.5),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),

                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: IconButton(
                        //     iconSize: deviceSize.width * 0.25,
                        //     icon: CircleAvatar(
                        //       radius: deviceSize.width * 0.25,
                        //       backgroundColor: Colors.transparent,
                        //       child: ClipRRect(
                        //         borderRadius:
                        //             BorderRadius.circular(deviceSize.width * 0.3),
                        //         child: Image.network(
                        //           provider.profileViewModel.displayPicture,
                        //         ),
                        //       ),
                        //     ),
                        //     onPressed: () {},
                        //   ),
                        // ),
                        // Align(
                        //   alignment: Alignment.center,// + Alignment(-0.4, 0),
                        //   child: Text(
                        //     provider.profileViewModel.firstName +
                        //         ' ' +
                        //         provider.profileViewModel.lastName,
                        //     style: TextStyle(
                        //         fontFamily: 'Cairo', fontSize: deviceSize.width * 0.08),
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        // Align(
                        //   alignment: Alignment.centerRight + Alignment(-0.85, 0.7),
                        //   child: FlatButton(
                        //      child: Row(
                        //        mainAxisSize: MainAxisSize.min,
                        //        children: <Widget>[
                        //         Icon(Icons.edit, color: Colors.blue,),
                        //         Text('Edit Profile', style: TextStyle(fontSize: deviceSize.width*0.03, color: Colors.blue, decoration: TextDecoration.underline),),
                        //       ],
                        //     ),
                        //     onPressed: () {},
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: deviceSize.width * 0.04),
                  child: ListTile(
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: ProfileScreen(),
                        platformSpecific:
                            false, // OPTIONAL VALUE. False by default, which means the bottom nav bar will persist
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                      );
                    },
                    leading: Icon(
                      Icons.person_outline,
                      size: deviceSize.width * 0.09,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Profile',
                      style: TextStyle(fontSize: deviceSize.width * 0.045),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: deviceSize.width * 0.04),
                  child: ListTile(
                    leading: Icon(
                      Icons.shopping_cart,
                      size: deviceSize.width * 0.09,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Shop',
                      style: TextStyle(fontSize: deviceSize.width * 0.045),
                    ),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(left: deviceSize.width * 0.04),
                //   child: ListTile(
                //     onTap: () {
                //       provider.toggleMode();
                //     },
                //     leading: Icon(
                //       Icons.brightness_4,
                //       size: deviceSize.width * 0.09,
                //       color: Colors.black,
                //     ),
                //     title: Text(
                //       'Dark Mode',
                //       style: TextStyle(fontSize: deviceSize.width * 0.045),
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(left: deviceSize.width * 0.04),
                  child: ListTile(
                    leading: Icon(
                      Icons.settings,
                      size: deviceSize.width * 0.09,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(fontSize: deviceSize.width * 0.045),
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.35,
                ),
                Container(
                  margin: EdgeInsets.only(left: deviceSize.width * 0.2),
                  child: ListTile(
                      onTap: () {
                        UtilityFunctions.logOutDialogueBox(
                          provider,
                          'Logout',
                          'Are you sure you want to logout?',
                          context,
                        );
                      },
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            size: deviceSize.width * 0.08,
                            color: Colors.red,
                          ),
                          Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: deviceSize.width * 0.04,
                                color: Colors.red),
                          ),
                        ],
                      )),
                ),
              ],
            )),
          );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: ("Search"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notifications),
        title: ("Notifications"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        title: ("Shop"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColor,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      Container(),
      Container(),
      Container(),
    ];
  }
}
