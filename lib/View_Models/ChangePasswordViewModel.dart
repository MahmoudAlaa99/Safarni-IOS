import 'package:flutter/material.dart';
import 'package:safarni/Utilities/Constants.dart';
import 'package:safarni/Utilities/Functions.dart';
import '../Services/Web_Services.dart';

class ChangePasswordViewModel with ChangeNotifier {
  final String _accessToken;

  ChangePasswordViewModel({String accessToken}) : _accessToken = accessToken;
  Status status = Status.success;
  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
    BuildContext context,
  ) async {
    try {
      status = Status.loading;
      notifyListeners();
      if (await WebServices()
          .changePassword(oldPassword, newPassword, _accessToken)) {
        status = Status.success;
        notifyListeners();
        return true;
      }
      status = Status.failed;
      notifyListeners();
      return false;
    } catch (error) {
      status = Status.failed;
      notifyListeners();
      UtilityFunctions.showErrorDialog(
          'An error occured', error.toString(), context);
      return false;
    }
  }
}
