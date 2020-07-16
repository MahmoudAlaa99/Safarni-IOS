import 'dart:ui';
//import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:safarni/Utilities/Constants.dart';

import 'package:safarni/View_Models/AuthenticationViewModel.dart';
import 'package:safarni/screens/Login_Signup/LoginScreen.dart';
import 'package:safarni/screens/Login_Signup/SignupScreen.dart';
import 'ForgetPasswordScreen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
/////////////////////////////////////////////////////////////////////////////////////////////////
  ///this function to test sign in with google -->> will be removed
  ///commented for now 3shan law ehtagnaha w ehna bngrb
  // Future<void> _signOut(BuildContext context) async {
  //     final GoogleSignIn _googlSignIn = new GoogleSignIn();
  //     final GoogleSignInAccount googleUser = await _googlSignIn.disconnect();
  //     print('signed out');
  // }
/////////////////////////////////////////////////////////////////////////////////////////////////
  var provider;
  AssetImage image1;
  AssetImage image2;
  @override
  void initState() {
    provider = Provider.of<AuthenticationViewModel>(context, listen: false);
    image1=AssetImage("assets/images/background1-01.png");
    image2=AssetImage("assets/images/background2-01.png");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage( image1, context);
    super.didChangeDependencies();
  }

  
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Color primaryColor = CupertinoTheme .of(context).primaryColor; 
    Color secondaryColor = CupertinoTheme .of(context).barBackgroundColor;
    return CupertinoPageScaffold(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: image1,//AssetImage("assets/images/background1-01.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                 CupertinoColors.black.withOpacity(0.3), BlendMode.lighten)),
        ),
        child: provider.status == Status.loading
            ? CupertinoActivityIndicator ()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset('assets/images/vertical_white.png'),
                    ),
                    margin: EdgeInsets.only(top: deviceSize.height * 0.1),
                    height: deviceSize.height * 0.4,
                    width: double.infinity,
                  ),
                  Container(
                    width: deviceSize.width * 0.8,
                    height: deviceSize.height * 0.065,
                    margin: EdgeInsets.only(top:deviceSize.height * 0.015),
                    child: CupertinoButton (
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SignupScreen()),
                        );
                      },
                      color: secondaryColor,
                      //heroTag: "createAccountButton", 
                      borderRadius: BorderRadius.circular(25.0),
                      
                      child: Text(
                        'CREATE ACCOUNT',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceSize.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: deviceSize.width * 0.8,
                    height: deviceSize.height * 0.065,
                    margin:
                        EdgeInsets.only(top:deviceSize.height * 0.015),
                    child: CupertinoButton(
                      //heroTag: "loginButton",
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(25.0),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceSize.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: deviceSize.width * 0.1,
                      ),
                      CupertinoButton(
                        child: Text(
                          'FORGET PASSWORD?',
                          style: TextStyle(
                              fontSize: deviceSize.width * 0.03,
                              color: secondaryColor,
                              decoration: TextDecoration.underline),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ForgetPasswordScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.05,
                  ),
                  Text(
                    'LOGIN WITH',
                    style: TextStyle(
                      fontSize: deviceSize.width * 0.045,
                      color: secondaryColor,
                      //decoration: TextDecoration.underline
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        width: deviceSize.width * 0.15,
                        height: deviceSize.height * 0.09,
                        child: CupertinoButton(
                          //heroTag: "btn3",
                          onPressed: () async {
                            await provider.continueWithFacebook(context);
                          },
                          //backgroundColor: secondaryColor,
                          color: Color.fromRGBO(59, 89, 152, 1),
                            borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            //backgroundColor: secondaryColor,
                            color: Color.fromRGBO(59, 89, 152, 1),
                            child:
                                Image.asset('assets/images/facebookLogo.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: deviceSize.width * 0.07,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        width: deviceSize.width * 0.15,
                        height: deviceSize.height * 0.09,
                        child: CupertinoButton(
                          onPressed: () async {
                            await provider.continueWithGoogle(context);
                          },
                          //heroTag: "btn4",
                          color: secondaryColor,
                            borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                              color: secondaryColor,
                              child: Image.asset(
                                'assets/images/google.png',
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
