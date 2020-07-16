import 'package:flutter/material.dart';
import 'package:safarni/View_Models/AuthenticationViewModel.dart';

class UtilityFunctions {
  static void showErrorDialog(
      String title, String message, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.deepPurple,
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void logOutDialogueBox(AuthenticationViewModel auth, String title,
      String message, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.deepPurple,
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            textColor: Colors.deepPurple,
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              auth.logOut();
            },
          ),
        ],
      ),
    );
  }

  ///this function is used to show snackbar to indicate if the password changed successfuly or not
  ///it takes [messageToShow] , [context] as arguments
  static void snackBar(String messageToShow, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Container(
          color: Colors.grey[850],
          child: Text(
            messageToShow,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}


