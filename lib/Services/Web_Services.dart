import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safarni/Utilities/Constants.dart';
import '../Models/HttpExceptions.dart';

class WebServices {
  Future<Map<String, dynamic>> _retirieveFacebookData() async {
    FacebookLogin facebookLogin = FacebookLogin();
    try {
      final results = await facebookLogin.logIn(
        [
          'email',
          'public_profile',
          'user_gender',
          'user_location',
          'user_birthday',
          'user_photos',
        ],
      );
      return results.accessToken.toMap();
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> loginWithFacebook() async {
    try {
      final results = await _retirieveFacebookData();
      return await _sendFacebookData(results);
    } catch (error) {
      throw Exception("Something went wrong");
    }
  }

  Future<Map<String, dynamic>> _sendFacebookData(
      Map<String, dynamic> results) async {
    try {
      final response = await Dio().post(
        Constants.baseUrl + Constants.continueWithFacebook,
        data: json.encode(
          {
            "accessToken": results['token'],
            "userId": results['userId'],
          },
        ),
      );
      if (response.statusCode != 200) {
        throw HTTPException(response.data['error']).toString();
      }
      return response.data;
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<Map<String, dynamic>> signUp(
      String firstName,
      String lastName,
      String email,
      String userName,
      String password,
      String gender,
      String dateOfBirth) async {
    try {
      final response = await Dio().post(
        Constants.baseUrl + Constants.signUp,
        data: json.encode(
          {
            "email": email,
            "userName": userName,
            "password": password,
            "gender": gender,
            "dateOfBirth": dateOfBirth,
            "displayName": {
              "firstName": firstName,
              "lastName": lastName,
            },
          },
        ),
        options: Options(
          validateStatus: (_) {
            return true;
          },
        ),
      );
      if (response.statusCode != 201) {
        throw HTTPException(response.data['error']).toString();
      }
      return response.data;
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await Dio().post(
        Constants.baseUrl + Constants.signIn,
        data: json.encode(
          {
            "email": email,
            "password": password,
          },
        ),
        options: Options(
          validateStatus: (_) {
            return true;
          },
        ),
      );
      if (response.statusCode != 200) {
        throw HTTPException(response.data['error']).toString();
      }
      return response.data;
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<Map<String, dynamic>> fetchMyProfile(String token) async {
    try {
      final response = await http.get(
        Constants.baseUrl + Constants.user + Constants.myProfile,
        headers: {
          "Authorization": "Bearer " + token,
        },
      );
      if (response.statusCode != 200) {
        throw HTTPException(jsonDecode(response.body)['error']).toString();
      }
      return jsonDecode(response.body);
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<Map<String, dynamic>> refreshToken(String token) async {
    try {
      final response = await Dio().post(
        Constants.baseUrl + Constants.refreshToken,
        options: Options(
          validateStatus: (_) {
            return true;
          },
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
      );
      if (response.statusCode != 200) {
        throw HTTPException(response.data['error']).toString();
      }
      return response.data;
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future _retirieveGoogleToken() async {
    try {
      final GoogleSignIn _googlSignIn = new GoogleSignIn(
        scopes: [
          'email',
          'profile',
          'openid',
          'https://www.googleapis.com/auth/user.addresses.read',
          'https://www.googleapis.com/auth/user.gender.read',
          'https://www.googleapis.com/auth/user.birthday.read',
          'https://www.googleapis.com/auth/user.phonenumbers.read'
        ],
      );
      final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
      return googleUser.authentication;
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String , dynamic>> loginWithGoogle() async {
    try {
      var response;
      await _retirieveGoogleToken().then((value) async {
         response= await Dio().post(
          Constants.baseUrl + Constants.continueWithGoogle,
          data: {"token": value.accessToken},
          options: Options(contentType: "application/json"),
        );
        print(response.statusCode);
        if (response.statusCode != 200) {
          throw Exception("Something went wrong");
        }
        print(response.data);
       
      });
       return response.data;
    } catch (error) {
      throw Exception("Something went wrong");
    }
  }

  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
    String token,
  ) async {
    try {
      final response = await Dio().post(
        Constants.baseUrl + Constants.changePassword,
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
        options: Options(
          contentType: "application/json",
          validateStatus: (_) {
            return true;
          },
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
      );
      if (response.statusCode != 200) {
        throw HTTPException(response.data['error']).toString();
      }

      return true;
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<bool> editProfile(String userName, String firstName, String lastName,
      List<String> phoneNumbers, String token) async {
    try {
      final response = await Dio().post(
        Constants.baseUrl + Constants.editProfile,
        data: jsonEncode(
          {
            "displayName": {
              "firstName": firstName,
              "lastName": lastName,
            },
            "userName": userName,
            "phone": phoneNumbers
          },
        ),
        options: Options(
          contentType: "application/json",
          validateStatus: (_) {
            return true;
          },
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception("Something went wrong");
    }
  }

  Future<Map<String, dynamic>> editProfilePicture(
      File image, String token) async {
    try {
      FormData formData = new FormData.fromMap(
          {"picture": MultipartFile.fromFileSync(image.path)});

      final response = await Dio().post(
        Constants.baseUrl + Constants.editProfilePicture,
        data: formData,
        options: Options(
          //contentType: "application/json",
          validateStatus: (_) {
            return true;
          },
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      throw Exception("Something went wrong");
    }
  }

  Future<List> fetchFollowing(String token, String userID, int skip) async {
    try {
      final response = await http.get(
        Constants.baseUrl +
            Constants.followingList +
            Constants.skip +
            skip.toString() +
            Constants.userID +
            userID,
        headers: {
          "Authorization": "Bearer " + token,
        },
      );
      if (response.statusCode != 200) {
        throw HTTPException(jsonDecode(response.body)['error']).toString();
      }
      return jsonDecode(response.body) as List;
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<List> fetchFollowers(String token, String userID, int skip) async {
    try {
      final response = await http.get(
        Constants.baseUrl +
            Constants.followersList +
            Constants.skip +
            skip.toString() +
            Constants.userID +
            userID,
        headers: {
          "Authorization": "Bearer " + token,
        },
      );
      if (response.statusCode != 200) {
        throw HTTPException(jsonDecode(response.body)['error']).toString();
      }
      return jsonDecode(response.body) as List;
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<Map<String, dynamic>> fetchUserStats(
      String token, String userID) async {
    try {
      final response = await http.get(
        Constants.baseUrl +
            Constants.userStats +
            Constants.userIDQuest +
            userID,
        headers: {
          "Authorization": "Bearer " + token,
        },
      );
      if (response.statusCode != 200) {
        throw HTTPException(jsonDecode(response.body)['error']).toString();
      }
      return jsonDecode(response.body);
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<void> toggleFollow(
    String token,
    String profileID,
    String userToFollowID,
    bool follow,
  ) async {
    try {
      if (follow) {
        await _follow(token, profileID, userToFollowID);
      } else {
        await _unFollow(token, profileID, userToFollowID);
      }
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<bool> _follow(
    String token,
    String profileID,
    String userToFollowID,
  ) async {
    try {
      final response = await Dio().post(
        Constants.baseUrl + Constants.follow,
        options: Options(
          validateStatus: (_) {
            return true;
          },
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
        data: jsonEncode(
          {
            "profileID": profileID,
            "userToFollowID": userToFollowID,
          },
        ),
      );
      if (response.statusCode != 200) {
        throw HTTPException(response.data['error']).toString();
      }
      return true;
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }

  Future<bool> _unFollow(
    String token,
    String profileID,
    String userToFollowID,
  ) async {
    try {
      final response = await Dio().post(
        Constants.baseUrl + Constants.unfollow,
        options: Options(
          validateStatus: (_) {
            return true;
          },
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
        data: jsonEncode(
          {
            "profileID": profileID,
            "userToFollowID": userToFollowID,
          },
        ),
      );
      if (response.statusCode != 200) {
        throw HTTPException(response.data['error']).toString();
      }
      return true;
    } catch (error) {
      throw HTTPException(error).toString();
    }
  }
}
