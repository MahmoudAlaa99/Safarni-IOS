import '../Models/Profile.dart';

class ProfileViewModel {
  final Profile profile;
  ProfileViewModel({this.profile});

  String get id {
    return profile.id;
  }

  String get user {
    return profile.user;
  }

  String get userName {
    return profile.userName;
  }

  String get displayPicture {
    return profile.displayPicture;
  }

  String get firstName {
    return profile.firstName;
  }

  String get lastName {
return profile.lastName;
  }

  bool get isPrivate {
    return profile.isPrivate;
  }

}
