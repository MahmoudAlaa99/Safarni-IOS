import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safarni/Models/Profile.dart';
import 'package:safarni/Services/Web_Services.dart';
import 'package:safarni/Utilities/Constants.dart';
import 'package:safarni/View_Models/ProfileViewModel.dart';
import '../Utilities/Functions.dart';

class AuthenticationViewModel with ChangeNotifier {
  String _accessToken;
  int _accessTokenValidity;
  String _refreshToken;
  Timer _authTimer;
  Status status = Status.success;
  bool _firstTime = true;
  bool dark = false;
  ProfileViewModel profileViewModel = ProfileViewModel();

  bool get isAuth {
    return _accessToken != null;
  }

  String get accessToken {
    return _accessToken;
  }

  String get refreshToken {
    return _refreshToken;
  }

  int get accessTokenValidity {
    return _accessTokenValidity;
  }

  void toggleMode() {
    dark = !dark;
    notifyListeners();
  }

  Future<void> _setMyProfile(BuildContext context) async {
    try {
      final Map<String, dynamic> results =
          await WebServices().fetchMyProfile(_accessToken);
      print(results);
      profileViewModel = ProfileViewModel(profile: Profile.fromJson(results));
    } catch (error) {
      print(error);
      UtilityFunctions.showErrorDialog(
          'An error occured', error.toString(), context);
    }
  }

  Future<bool> tryAutoLogin(BuildContext context) async {
    try{
          final storage = FlutterSecureStorage();
    final results = await storage.read(key: "userData");
    if (results == null) {
      return false;
    }
    final extractedData = jsonDecode(results);
    _refreshToken = extractedData['refreshToken'];
    if (_firstTime) {
      _firstTime = false;
      await refreshAccessToken();
      _autoRefresh();
    }
    await _setMyProfile(context);
    notifyListeners();
    return true;
    }catch(error){
      return false;
    }

  }

  void _autoRefresh() async {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    _authTimer = Timer.periodic(
      Duration(minutes: _accessTokenValidity - 2),
      (timer) async {
        await refreshAccessToken();
      },
    );
  }

  Future<void> refreshAccessToken() async {
    final Map<String, dynamic> results =
        await WebServices().refreshToken(_refreshToken);
    await _cacheAndSetUserAuthenticationData(results);
    if (profileViewModel.profile != null) {
      notifyListeners();
    }
  }

  Future<void> signUp(
    String firstName,
    String lastName,
    String email,
    String userName,
    String password,
    String gender,
    String dateOfBirth,
    BuildContext context,
  ) async {
    status = Status.loading;
    notifyListeners();
    try {
      final Map<String, dynamic> results = await WebServices().signUp(
        firstName,
        lastName,
        email,
        userName,
        password,
        gender,
        dateOfBirth,
      );
      await _cacheAndSetUserAuthenticationData(results);
      await _setMyProfile(context);
      _autoRefresh();
      status = Status.success;
      notifyListeners();
      Navigator.of(context).pop();
    } catch (error) {
      status = Status.failed;
      notifyListeners();
      UtilityFunctions.showErrorDialog(
          'An error occured', error.toString(), context);
      throw Exception;
    }
  }

  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    status = Status.loading;
    notifyListeners();
    try {
      final Map<String, dynamic> results =
          await WebServices().signIn(email, password);
      await _cacheAndSetUserAuthenticationData(results);
      await _setMyProfile(context);
      _autoRefresh();
      status = Status.success;
      notifyListeners();
      Navigator.of(context).pop();
    } catch (error) {
      status = Status.failed;
      notifyListeners();
      UtilityFunctions.showErrorDialog(
          'An error occured', error.toString(), context);
      throw Exception;
    }
  }

  Future<void> continueWithFacebook(BuildContext context) async {
    try {
      Map<String, dynamic> results = await WebServices().loginWithFacebook();
      status = Status.loading;
      notifyListeners();
      await _cacheAndSetUserAuthenticationData(results);
      await _setMyProfile(context);
      status = Status.success;
      notifyListeners();
    } catch (error) {
      status = Status.failed;
      notifyListeners();
      UtilityFunctions.showErrorDialog(
          'An error occured', error.toString(), context);
    }
  }
  Future<void> continueWithGoogle(BuildContext context) async {
    try {
      Map<String, dynamic> results = await WebServices().loginWithGoogle();
      print('mahmoud');
      print(results);
      status = Status.loading;
      notifyListeners();
      await _cacheAndSetUserAuthenticationData(results);
      await _setMyProfile(context);
      status = Status.success;
      notifyListeners();
    } catch (error) {
      status = Status.failed;
      notifyListeners();
      UtilityFunctions.showErrorDialog(
          'An error occured', error.toString(), context);
    }
  }

  void logOut() {
    _accessToken = null;
    _refreshToken = null;
    _accessTokenValidity = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final storage = FlutterSecureStorage();
    storage.delete(key: 'userData');
    notifyListeners();
  }

  Future<void> _cacheAndSetUserAuthenticationData(
      Map<String, dynamic> userData) async {
    try {
      _accessToken = userData['accessToken'];
      _refreshToken = userData['refreshToken'];
      print("Auth token is:");
      print(_accessToken);
      print("Refresh Token is:");
      print(_refreshToken);
      _accessTokenValidity =
          int.parse(userData['accessTokenValidity'].substring(0, 2));
      final storedData = json.encode(
        {
          "accessToken": _accessToken,
          "refreshToken": _refreshToken,
          "accessTokenValidity": _accessTokenValidity.toString(),
        },
      );
      final storage = FlutterSecureStorage();
      await storage.write(key: "userData", value: storedData);
    } catch (error) {
      throw error;
    }
  }

  ///this function is used to edit profile's data
  ///it takes this data as inputs [userName], [firstName] , [lastName], [phoneNumbers]
  Future<bool> editMyProfile(
    String userName,
    String firstName,
    String lastName,
    List<String> phoneNumbers,
    BuildContext context,
  ) async {
    status = Status.loading;
    notifyListeners();
    try {
      bool changed = await WebServices().editProfile(
        userName,
        firstName,
        lastName,
        phoneNumbers,
        _accessToken,
      );
      if (changed == true) {
        profileViewModel.profile.firstName = firstName;
        profileViewModel.profile.lastName = lastName;
        profileViewModel.profile.userName = userName;
        print(profileViewModel.profile.userName);
        status = Status.success;
        notifyListeners();
        return changed;
      }
      status = Status.failed;
      notifyListeners();
      return changed;
    } catch (error) {
      UtilityFunctions.showErrorDialog(
          'An error occured', error.toString(), context);
      return false;
    }
  }

  Future<bool> editProfilePicture(
    File image,
    BuildContext context,
  ) async {
    status = Status.loading;
    notifyListeners();
    try {
      var profilePicture = await WebServices().editProfilePicture(
        image,
        _accessToken,
      );
      if (profilePicture != null) {
        profileViewModel.profile.displayPicture =
            profilePicture['displayPicture'];
        status = Status.success;
        notifyListeners();
        return true;
      }
      status = Status.failed;
      notifyListeners();
      return false;
    } catch (error) {
      UtilityFunctions.showErrorDialog(
          'An error occured', error.toString(), context);
      return false;
    }
  }
}
