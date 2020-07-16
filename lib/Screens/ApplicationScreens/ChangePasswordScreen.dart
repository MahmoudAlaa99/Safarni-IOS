import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarni/Utilities/Constants.dart';
import 'package:safarni/Utilities/Functions.dart';
import 'package:safarni/View_Models/ChangePasswordViewModel.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/changePassword';
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //Variable to get the device size.
  var deviceSize;
  //Variable for the view model provider.
  var changepasswordViewModel;

  ///[_passwordVisible] is a private class member to determine if the typed password is visible or hashed
  bool _passwordVisible;

  ///Text field controllers for old and new password and confirm password.
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  void _changePassword(BuildContext context) async {
    if (oldPasswordController.text != "" &&
        newPasswordController.text != "" &&
        confirmNewPasswordController.text != "") {
      if (newPasswordController.text == confirmNewPasswordController.text) {
        bool changed = await changepasswordViewModel.changePassword(
          oldPasswordController.text.trim(),
          newPasswordController.text.trim(),
          context,
        );
        if (changed == true) {
          UtilityFunctions.snackBar("Password changed successfully", context);
        } else {
          UtilityFunctions.snackBar(
              "Something went wrong ,please try again", context);
        }
      } else {
        UtilityFunctions.snackBar("Password not matched!", context);
      }
    } else if (newPasswordController.text == "" &&
        oldPasswordController.text != "") {
      UtilityFunctions.snackBar("Please enter new pasword", context);
    } else {
      UtilityFunctions.snackBar(
          "Something went wrong ,please try again!", context);
    }
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changepasswordViewModel =
        Provider.of<ChangePasswordViewModel>(context, listen: true);
    deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async =>
          changepasswordViewModel.status == Status.loading ? false : true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: changepasswordViewModel.status == Status.loading
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                child: Text(
                  'Cancel',
                  style: changepasswordViewModel.status == Status.loading
                      ? TextStyle(color: Colors.transparent)
                      : TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
            ],
          ),
        ),
        body: Builder(
          builder: (context) => changepasswordViewModel.status == Status.loading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: deviceSize.height * 0.1),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                          size: deviceSize.width * 0.6,
                        ),
                      ),
                      _passwordTextField(oldPasswordController, 'Old password'),
                      _passwordTextField(newPasswordController, 'New password'),
                      _passwordTextField(
                          confirmNewPasswordController, 'Confirm new password'),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(
                            right: deviceSize.width * 0.1,
                            top: deviceSize.height * 0.05),
                        child: FlatButton(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: deviceSize.width * 0.04,
                            ),
                          ),
                          onPressed: () => _changePassword(context),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _passwordTextField(TextEditingController controller, String text) {
    return Container(
      margin: EdgeInsets.only(
          left: deviceSize.width * 0.1, top: deviceSize.height * 0.01),
      width: deviceSize.width * 0.7,
      child: TextFormField(
        controller: controller,
        style:
            TextStyle(fontFamily: 'Cairo', fontSize: deviceSize.width * 0.04),
        decoration: InputDecoration(
          icon: Icon(
            Icons.vpn_key,
            color: Colors.black54,
          ),
          labelText: text,
          labelStyle: TextStyle(color: Colors.black54),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.black54,
              size: deviceSize.width * 0.055,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        obscureText: !_passwordVisible,
      ),
    );
  }
}
