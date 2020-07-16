import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarni/Utilities/Constants.dart';
import 'package:safarni/View_Models/AuthenticationViewModel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var deviceSize;
  var provider;
  bool _enableLogin = false;
  bool _goBack = true;
  //setting up page colors
  Color primaryColor = CupertinoColors.systemPurple; //Color(0x8205C9);
  Color secondaryColor = CupertinoColors.white;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _enableSubmit() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        _enableLogin = true;
      });
    }
  }

  @override
  void initState() {
    emailController.text = '';
    passwordController.text = '';
    provider = Provider.of<AuthenticationViewModel>(context, listen: false);
    super.initState();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      setState(() {
        _goBack = false;
      });
      _formKey.currentState.save();
      try {
        await provider.signIn(
          emailController.text.trim(),
          passwordController.text.trim(),
          context,
        );
      } catch (error) {
        setState(() {
          _goBack = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ///getting device size
    deviceSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => _goBack,
      child:CupertinoPageScaffold (
        resizeToAvoidBottomInset: false,
        /*resizeToAvoidBottomPadding: false,
        extendBodyBehindAppBar: true,*/
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.quaternarySystemFill,
        ),
        child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: deviceSize.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background2-01.png"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          CupertinoColors.black.withOpacity(0.3), BlendMode.lighten)),
                ),
                child: provider.status == Status.loading
                    ? Center(
                        child: CupertinoActivityIndicator(
                        animating: true,
                        radius: 25,
                      ),
                      )
                    : SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Hero(
                                    tag: 'logo',
                                    child: Image.asset(
                                        'assets/images/vertical_white.png'),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: deviceSize.height * 0.1),
                                  height: deviceSize.height * 0.5,
                                  width: double.infinity,
                                ),
                                SizedBox(
                                  height: deviceSize.height * 0.01,
                                ),
                                _textField(
                                    emailController, 'E-mail', CupertinoIcons.mail_solid),
                                _textField(passwordController, 'Password',
                                    CupertinoIcons.eye_solid),
                                Container(
                                  width: deviceSize.width * 0.6,
                                  height: deviceSize.height * 0.065,
                                  margin:
                                      EdgeInsets.all(deviceSize.height * 0.015),
                                  child: CupertinoButton(
                                    onPressed: _submit,
                                    color: _enableLogin
                                        ? primaryColor
                                        : primaryColor.withOpacity(0.5),
                                  
                                      borderRadius: BorderRadius.circular(25.0),
                                    
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: _enableLogin
                                            ? secondaryColor
                                            : secondaryColor.withOpacity(0.5),
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceSize.width * 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
              ),
            ),
          ),
        ),
    );
  }

  Widget _textField(
      TextEditingController controller, String text, IconData icon) {
    return Container(
      width: deviceSize.width * 0.8,
      height: deviceSize.height * 0.08,
      margin: EdgeInsets.all(deviceSize.height * 0.01),
      child: CupertinoTheme(
        data: CupertinoThemeData(primaryColor: primaryColor),
        child: Container(
            child: CupertinoTextField(
            /*validator: (value) {
              if (text == 'E-mail' && value.isEmpty) {
                return 'Please enter your email address.';
              } else if (text == 'Password' && value.isEmpty) {
                return 'Please enter your password.';
              } else if (text == 'Password' && value.length < 8) {
                return 'Password must be at least 8 characters';
              } else if (text == 'E-mail' && !value.contains('@')) {
                return 'Please enter a valid email address.';
              }
            },*/
            onChanged: (value) {
              _enableSubmit();
            },
            obscureText: text == 'Password' ? true : false,
            controller: controller,
            decoration: BoxDecoration(
              color: CupertinoColors.black,
              borderRadius: BorderRadius.circular(15.0),
              
            ),
              prefix: Container(
                padding:EdgeInsets.only(left: deviceSize.width*0.04 , right: deviceSize.width*0.04 ), 
                child: Icon(
                  icon,
                  color: CupertinoColors.white.withOpacity(0.2),
                  size: 25,
                
                ),
              ),
              placeholder: text,
              placeholderStyle: TextStyle(
              color: CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(0.4)),
            style: TextStyle(color: primaryColor),
            cursorColor: secondaryColor,
            keyboardType: text == 'E-mail'
                ? TextInputType.emailAddress
                : TextInputType.text,
          ),
        ),
      ),
    );
  }
}
