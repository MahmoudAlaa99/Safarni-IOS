import 'package:safarni/Models/Profile.dart';

class UserProfile {
  final Profile profile;
  bool isFollowing;
  bool isSelf;
  UserProfile({
    this.profile,
    this.isFollowing,
    this.isSelf,
  });
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profile: Profile.fromJson(json['profile']),
      isFollowing: json['isFollowing'],
      isSelf: json['isSelf'],
    );
  }
}
