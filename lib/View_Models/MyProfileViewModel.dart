import 'package:flutter/cupertino.dart';
import 'package:safarni/Models/UserProfile.dart';
import 'package:safarni/Services/Web_Services.dart';
import 'package:safarni/Utilities/Constants.dart';
import 'package:safarni/View_Models/UserProfileViewModel.dart';

class MyProfileViewModel with ChangeNotifier {
  String _accessToken;
  int skip = 0;
  Status postsStatus = Status.loading;
  Status followingStatus = Status.success;
  Status followersStatus = Status.success;
  Status userStats = Status.loading;
  String numberOfFollowings = '0';
  String numberOfFollowers = '0';
  List<UserProfileViewModel> following = [];
  List<UserProfileViewModel> followers = [];
  MyProfileViewModel({
    String accessToken,
    this.skip,
    this.following,
    this.followers,
    this.userStats,
    this.numberOfFollowers,
    this.numberOfFollowings,
  }) : _accessToken = accessToken;

  Future<void> fetchUserStats(String userID) async {
    try {
      final results = await WebServices().fetchUserStats(_accessToken, userID);
      numberOfFollowers = results['numberOfFollowers'].toString();
      numberOfFollowings = results['numberOfFollowings'].toString();
      userStats = Status.success;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> fetchFollowing(String userID) async {
    try {
      followingStatus = Status.loading;
      notifyListeners();
      final results =
          await WebServices().fetchFollowing(_accessToken, userID, skip);
      following.clear();
      for (int i = 0; i < results.length; i++) {
        following.add(
          UserProfileViewModel(
            accessToken: _accessToken,
            userProfile: UserProfile.fromJson(results[i]),
          ),
        );
      }
      followingStatus = following.length == 0 ? Status.empty : Status.success;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> fetchFollowers(String userID) async {
    try {
      followersStatus = Status.loading;
      notifyListeners();
      final results =
          await WebServices().fetchFollowers(_accessToken, userID, skip);
      followers.clear();
      for (int i = 0; i < results.length; i++) {
        followers.add(
          UserProfileViewModel(
            accessToken: _accessToken,
            userProfile: UserProfile.fromJson(results[i]),
          ),
        );
      }
      followersStatus = followers.length == 0 ? Status.empty : Status.success;
      notifyListeners();
    } catch (error) {}
  }
}
