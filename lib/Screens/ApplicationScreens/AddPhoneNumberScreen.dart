import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:safarni/Utilities/Constants.dart';
import 'package:safarni/Utilities/Functions.dart';

class AddPhoneNumberScreen extends StatefulWidget {
  @override
  _AddPhoneNumberScreenState createState() => _AddPhoneNumberScreenState();
}

class _AddPhoneNumberScreenState extends State<AddPhoneNumberScreen> {
  ///setting the colors used in the screen
  Color primaryColor = Colors.deepPurple; //Color(0x8205C9);
  Color secondaryColor = Colors.white;

  TextEditingController phoneNumber = TextEditingController();

  void savePhoneNumber(BuildContext context){
    if(phoneNumber.text == ''){
      UtilityFunctions.snackBar("Please enter a valid number!" , context);
    }
    else if(storePhoneNumbers.isEmpty)
    {
      storePhoneNumbers.add(phoneNumber.text);
      Navigator.of(context).pop();
    }
    else{
      storePhoneNumbers[1]= phoneNumber.text;
      Navigator.of(context).pop();
    }

  }
  
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
            appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: secondaryColor),
                )),
            FlatButton(
                onPressed: () => savePhoneNumber(context),
                child: Text('Save', style: TextStyle(color: secondaryColor)))
          ],
        ),
      ),
       body: Container(
              margin: EdgeInsets.only(
                  left: deviceSize.width * 0.1, top: deviceSize.height * 0.035),
              width: deviceSize.width * 0.6,
              child: InternationalPhoneNumberInput(
                onInputChanged: (phoneNumberTxt) {},
                countries: ['EG'],
                textFieldController: phoneNumber,

              ),
            ),
    );
  }
}