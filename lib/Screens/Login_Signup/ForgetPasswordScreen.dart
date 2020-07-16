import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///Getting the device size.
    final deviceSize = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;
    Color secondaryColor = Theme.of(context).accentColor;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: deviceSize.height,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background2-01.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      primaryColor.withOpacity(0.3), BlendMode.lighten)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: deviceSize.height * 0.4,
                ),

                ///'Email' Text.
                // Container(
                //   margin: EdgeInsets.all(deviceSize.height * 0.015),
                //   child: Text(
                //     'Send password by e-mail',
                //     style: TextStyle(
                //         color: Colors.white, fontSize: deviceSize.width * 0.07),
                //   ),
                // ),

                ///Text input field to take the email.
                Container(
                  width: deviceSize.width * 0.8,
                  height: deviceSize.height * 0.2,
                  margin: EdgeInsets.all(deviceSize.height * 0.015),
                  child: TextFormField(
                    //controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: secondaryColor.withOpacity(0.2),
                      ),
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.black54.withOpacity(0.7),
                      helperText:
                          'We\'ll send you an email to reset your password.',
                      helperStyle: TextStyle(color: secondaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelStyle: TextStyle(
                          color:
                              secondaryColor.withOpacity(0.4)),
                    ),
                    style: TextStyle(color: secondaryColor),
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                // ///Show an error text if needed.
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     _validate
                //         ? SizedBox(
                //             height: 0.1,
                //           )
                //         : Text(
                //             'Please enter a valid Email',
                //             style: TextStyle(color: Colors.red),
                //           )
                //   ],
                // ),

                Container(
                  width: deviceSize.width * 0.6,
                  height: deviceSize.height * 0.065,
                  margin: EdgeInsets.all(deviceSize.height * 0.015),
                  child: RaisedButton(
                    textColor: secondaryColor,
                    color: primaryColor,
                    child: Text(
                      'SEND E-MAIL',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
