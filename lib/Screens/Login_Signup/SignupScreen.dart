import 'package:flutter/cupertino.dart';

///Importing this package to use different date formats.
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safarni/Utilities/Constants.dart';
import 'package:safarni/View_Models/AuthenticationViewModel.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var deviceSize;
  var provider;
  final _formKey = GlobalKey<FormState>();

  DateTime _userPickedDate;

  TextEditingController firstNameContoller = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  String dateOfBirth = '';

  bool _enableSubmition = false;
  bool _goBack = true;

  void _enableSubmit() {
    if (firstNameContoller.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        userNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        genderController.text.isNotEmpty &&
        dateOfBirth.isNotEmpty) {
      setState(() {
        _enableSubmition = true;
      });
    }
  }

  void initState() {
    firstNameContoller.text = '';
    lastNameController.text = '';
    userNameController.text = '';
    emailController.text = '';
    genderController.text = '';
    passwordController.text = '';
    provider = Provider.of<AuthenticationViewModel>(context, listen: false);
    //_validate = true;
    birthDateController.text = _userPickedDate == null
        ? 'No Day Choosen'
        : DateFormat.yMMMMEEEEd().format(_userPickedDate).toString();
    super.initState();
  }

   _presentDatePicker() {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: DateTime.now().subtract(
        Duration(days: 365 * 13),),
     minimumYear: 1, 
     onDateTimeChanged: (pickedDate) {
      setState(() {
        _userPickedDate = pickedDate;
        birthDateController.text = _userPickedDate == null
            ? 'No Day Choosen'
            : DateFormat.yMMMMEEEEd().format(_userPickedDate).toString();

        if (_userPickedDate != null) {
          dateOfBirth =
              DateFormat('yyyy-MM-dd').format(_userPickedDate).toString();
        }
      });
        if (dateOfBirth != null) {
        _enableSubmit();
      }
     }
    );
  }


      ///Setting the text field text with the chosen date if found any.
  Future<void> _submit() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      setState(() {
        _goBack = false;
      });
      _formKey.currentState.save();
      try {
        await provider.signUp(
          firstNameContoller.text.trim(),
          lastNameController.text.trim(),
          emailController.text.trim(),
          userNameController.text.trim(),
          passwordController.text.trim(),
          genderController.text.toLowerCase().trim(),
          dateOfBirth.trim(),
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
    deviceSize = MediaQuery.of(context).size;
    Color primaryColor = CupertinoTheme.of(context).primaryColor;
    Color secondaryColor = CupertinoTheme.of(context).scaffoldBackgroundColor;
    return WillPopScope(
      onWillPop: () async => _goBack,
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,

        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.quaternarySystemFill,
          automaticallyImplyLeading: _goBack,
          //elevation: 0,
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
                      CupertinoColors.black.withOpacity(0.2), BlendMode.lighten),
                ),
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
                            _sizedBox(0.07),
                            Hero(tag: 'logo', child: Container()),
                            Text(
                              'Join Us! ',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: deviceSize.width * 0.15,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                            _sizedBox(0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _textField(firstNameContoller, 'First name',
                                    CupertinoIcons.person_solid, deviceSize.width * 0.42),
                                _textField(lastNameController, 'Last name',
                                    null, deviceSize.width * 0.42),
                              ],
                            ),
                            _textField(emailController, 'E-mail',CupertinoIcons.mail_solid,
                                deviceSize.width * 0.9),
                            _textField(userNameController, 'Username',
                                CupertinoIcons.person_solid, deviceSize.width * 0.9),
                            _textField(passwordController, 'Password',
                                CupertinoIcons.eye_solid, deviceSize.width * 0.9),
                            _genderTextField(genderController),
                            _birthDateTextField(birthDateController),
                            _sizedBox(0.03),
                            Container(
                              width: deviceSize.width * 0.6,
                              height: deviceSize.height * 0.065,
                              margin: EdgeInsets.only(
                                  bottom: deviceSize.height * 0.015),
                              child: CupertinoButton(
                                onPressed: _enableSubmition ? _submit : null,
                                color: _enableSubmition
                                    ? primaryColor
                                    : primaryColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(25.0),
                                child: Text(
                                  'CREATE ACCOUNT',
                                  style: TextStyle(
                                    color: _enableSubmition
                                        ? secondaryColor
                                        : secondaryColor.withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceSize.width * 0.04,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizedBox(double value) {
    return SizedBox(
      height: deviceSize.height * value,
    );
  }

  Widget _textField(TextEditingController controller, String text,
      IconData icon, double width) {
    return Container(
      width: width,
      //height: deviceSize.height * 0.08,
      margin: EdgeInsets.all(deviceSize.height * 0.015),
      child: CupertinoTheme(
        data: CupertinoThemeData(
            primaryColor: CupertinoTheme.of(context).primaryColor,
            scaffoldBackgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor),
        child: CupertinoTextField(
          /*validator: (value) {
            if (text == 'First name' && value.isEmpty) {
              return 'Please enter your first name.';
            } else if (text == 'Last name' && value.isEmpty) {
              return 'Please enter your last name.';
            } else if (text == 'User`name' && value.isEmpty) {
              return 'Please enter your last name.';
            } else if (text == 'E-mail' && value.isEmpty) {
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
            style: TextStyle(color: CupertinoTheme.of(context).primaryColor),
            cursorColor:CupertinoColors.white.withOpacity(0.2),
            keyboardType: text == 'E-mail'
                ? TextInputType.emailAddress
                : TextInputType.text,
        ),
      ),
    );
  }

  Widget _genderTextField(TextEditingController controller) {
    return Container();
    ///The drop down menu showing both genders as choices.
    /*return CupertinoTheme(
      data: CupertinoTheme.of(context),
         // .copyWith(canvasColor: CupertinoColors.black.withOpacity(0.3)),
      child: Container(
        width: deviceSize.width * 0.9,
        height: deviceSize.height * 0.08,
        margin: EdgeInsets.all(deviceSize.height * 0.015),
        child: CupertinoDropdownButton(
          items: ["Male", "Female"]
              .map(
                (label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ),
              )
              .toList(),
          onChanged: (value) {
            genderController.text = value;
            _enableSubmit();
          },
          value:
              genderController.text.isNotEmpty ? genderController.text : null,
          style: TextStyle(
            fontSize: deviceSize.width * 0.035,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.wc,
              color: Colors.white.withOpacity(0.2),
            ),
            labelText: "Gender",
            labelStyle: TextStyle(
                color: Theme.of(context).accentColor.withOpacity(0.4),
                fontSize: deviceSize.width * 0.035),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(15.0),
            ),
            fillColor: Colors.black54.withOpacity(0.7),
          ),
        ),
      ),
    );*/
  }

  Widget _birthDateTextField(TextEditingController birthDateController) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        primaryColor: CupertinoTheme.of(context).primaryColor,
        scaffoldBackgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
      ),
      child: Container(
        width: deviceSize.width * 0.9,
        height: deviceSize.height * 0.08,
        margin: EdgeInsets.all(deviceSize.height * 0.015),
        child: CupertinoTextField(
            onTap: _presentDatePicker,
            controller: birthDateController,
            enabled: true,
            enableInteractiveSelection: false,
            readOnly: true,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              color: CupertinoColors.black.withOpacity(0.6),              
            ),
              placeholderStyle: TextStyle(
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(0.4)),
              prefix: Icon(
                      CupertinoIcons.time_solid,
                      color: CupertinoColors.white.withOpacity(0.2),
                   
                  ),
              
                 //onPressed: _presentDatePicker,
            //),
            style: TextStyle(
                fontSize: deviceSize.width * 0.035,
                color: _userPickedDate == null
                    ? CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(0.4)
                    : CupertinoColors.white),
            showCursor: false,
          ),
        ),
    );
  }
}
