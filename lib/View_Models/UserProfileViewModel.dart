import 'package:flutter/material.dart';
import 'package:safarni/Models/UserProfile.dart';
import 'package:safarni/Services/Web_Services.dart';

class UserProfileViewModel with ChangeNotifier {
  String _accessToken;
  final UserProfile userProfile;
  UserProfileViewModel({this.userProfile, String accessToken})
      : _accessToken = accessToken;
  bool get isFollowing {
    return userProfile.isFollowing;
  }

  bool get isSelf {
    return userProfile.isSelf;
  }

  String get id {
    return userProfile.profile.id;
  }

  String get user {
    return userProfile.profile.user;
  }

  String get userName {
    return userProfile.profile.userName;
  }

  String get displayPicture {
    return userProfile.profile.displayPicture;
  }

  String get firstName {
    return userProfile.profile.firstName;
  }

  String get lastName {
    return userProfile.profile.lastName;
  }

  bool get isPrivate {
    return userProfile.profile.isPrivate;
  }

  Future<bool> toggleFollow(bool follow) async {
    try {
      if (follow) {
        userProfile.isFollowing = true;
      } else {
        userProfile.isFollowing = false;
      }
      notifyListeners();
      await WebServices().toggleFollow(
        _accessToken,
        userProfile.profile.id,
        userProfile.profile.user,
        follow,
      );
      return true;
    } catch (error) {
      if (follow) {
        userProfile.isFollowing = false;
      } else {
        userProfile.isFollowing = true;
      }
      notifyListeners();
      print(error);
      return false;
    }
  }
}
