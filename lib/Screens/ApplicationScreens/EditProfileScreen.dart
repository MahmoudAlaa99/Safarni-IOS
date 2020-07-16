import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:safarni/Screens/ApplicationScreens/AddPhoneNumberScreen.dart';
import 'package:safarni/Utilities/Functions.dart';
import 'package:safarni/View_Models/AuthenticationViewModel.dart';
import 'package:safarni/Utilities/Constants.dart';
import 'package:safarni/View_Models/MyProfileViewModel.dart';
import 'ChangePasswordScreen.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/EditProfile';
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ///text field controllers for username, display name and phone number text fields
  TextEditingController userName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  bool textChanged = false;
  var authenticationViewModel;
  var myProfileViewModel;
  File imageURI;
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    var authenticationViewModel0 =
        Provider.of<AuthenticationViewModel>(context, listen: false);
    myProfileViewModel =
        Provider.of<MyProfileViewModel>(context, listen: false);
    firstName.text = authenticationViewModel0.profileViewModel.firstName;
    lastName.text = authenticationViewModel0.profileViewModel.lastName;
    userName.text = authenticationViewModel0.profileViewModel.userName;
  }

  void saveCahnges(BuildContext context) async {
    authenticationViewModel =
        Provider.of<AuthenticationViewModel>(context, listen: false);
    if (imageURI != null) {
      bool profilePicture =
          await authenticationViewModel.editProfilePicture(imageURI, context);
      if (profilePicture) {
        imageURI = null;
      }
    }
    if (firstName.text != authenticationViewModel.profileViewModel.firstName ||
        lastName.text != authenticationViewModel.profileViewModel.lastName ||
        userName.text != authenticationViewModel.profileViewModel.userName ||
        storePhoneNumbers.isNotEmpty) {
      //storePhoneNumbers[0] = phoneNumber.text;
      bool changed = await authenticationViewModel.editMyProfile(
        userName.text.trim(),
        firstName.text.trim(),
        lastName.text.trim(),
        storePhoneNumbers,
        context,
      );
      if (changed == true) {
        // UtilityFunctions.snackBar(
        //     "Profile has been changed successfully!", context);

      } else {
        // UtilityFunctions.snackBar(
        //     "Something went wrong please try again!", context);
      }
    }
    Navigator.of(context).pop();
  }

  Future getImageFromGallery() async {
    var image = await picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageURI = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (storePhoneNumbers.isNotEmpty) {
      print(storePhoneNumbers[0]);
    }
    final deviceSize = MediaQuery.of(context).size;
    authenticationViewModel =
        Provider.of<AuthenticationViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Theme.of(context).accentColor),
                )),
            FlatButton(
              onPressed: () => (textChanged == true || imageURI != null)
                  ? saveCahnges(context)
                  : null,
              child: Text(
                'Save',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            )
          ],
        ),
      ),
      body: Builder(
        builder: (context) => authenticationViewModel.status == Status.loading
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
                      height: deviceSize.height * 0.16,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                          0, deviceSize.height * 0.05, 0, 0),
                      child: CircleAvatar(
                        radius: deviceSize.height * 0.08,
                        backgroundColor: Colors.white,
                        backgroundImage: imageURI != null
                            ? FileImage(imageURI)
                            : NetworkImage(
                                authenticationViewModel
                                    .profileViewModel.displayPicture,
                              ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.file_upload,
                                color: Colors.blue,
                                size: deviceSize.width * 0.045),
                            Text(
                              'Edit Profile Picture',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceSize.width * 0.03),
                            ),
                          ],
                        ),
                        onPressed: getImageFromGallery,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: deviceSize.width * 0.1,
                          top: deviceSize.height * 0.02),
                      width: deviceSize.width * 0.6,
                      child: TextFormField(
                        onChanged: (_) {
                          textChanged = true;
                        },
                        controller: userName,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: deviceSize.width * 0.05),
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person_pin,
                            color: Colors.black,
                          ),
                          hintText: 'New Username',
                          //labelText: 'Username',
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: deviceSize.width * 0.1,
                              top: deviceSize.height * 0.02),
                          width: deviceSize.width * 0.3,
                          child: TextFormField(
                            onChanged: (_) {
                              textChanged = true;
                            },
                            textAlign: TextAlign.center,
                            controller: firstName,
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: deviceSize.width * 0.05),
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              hintText: 'What do people call you?',
                              //labelText: 'Username',
                            ),
                            validator: (String value) {
                              return value.contains('@')
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: deviceSize.width * 0.1,
                              top: deviceSize.height * 0.02),
                          width: deviceSize.width * 0.3,
                          child: TextFormField(
                            onChanged: (_) {
                              textChanged = true;
                            },
                            textAlign: TextAlign.center,
                            controller: lastName,
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: deviceSize.width * 0.05),
                            decoration: const InputDecoration(
                              //icon: Icon(Icons.person_pin, color: Colors.black,),
                              hintText: 'What do people call you?',
                              //labelText: 'Username',
                            ),
                            validator: (String value) {
                              return value.contains('@')
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: deviceSize.width * 0.1,
                          top: deviceSize.height * 0.035),
                      width: deviceSize.width * 0.6,
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (phoneNumberTxt) {
                          // storePhoneNumbers[0] = phoneNumber.text;
                          textChanged = true;
                        },
                        countries: ['EG'],
                        textFieldController: phoneNumber,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: deviceSize.width * 0.02),
                      width: deviceSize.width * 0.6,
                      child: FlatButton(
                        onPressed: () {
                          if (storePhoneNumbers.length < 2) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddPhoneNumberScreen()));
                          } else {
                            UtilityFunctions.snackBar(
                                "You already have 2 phone numbers ,You can't add more!",
                                context);
                          }
                        },
                        child: Text(
                          'Add another phone number',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: deviceSize.width * 0.03,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: FlatButton(
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: deviceSize.width * 0.04,
                              decoration: TextDecoration.underline),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
