class Constants {
  static String baseUrl = "https://safarni.herokuapp.com";
  static String signUp = "/register/signUp";
  static String signIn = "/register/signIn";
  static String refreshToken = "/register/refreshToken";
  static String continueWithGoogle = "/register/continueWithGoogle";
  static String continueWithFacebook = "/register/continueWithFacebook";
  static String user = '/user';
  static String myProfile = '/myProfile';
  static String changePassword = "/user/changePassword";
  static String editProfile = "/user/profile";
  static String follow = '/user/follow';
  static String unfollow = '/user/unfollow';
  static String followingList = '/user/followingList';
  static String followersList = '/user/followersList';
  static String skip = '?skip=';
  static String userID = '&userID=';
  static String userIDQuest = '?userID=';
  static String userStats = '/user/userStats';
  static String editProfilePicture = "/user/upload/profilePicture/me";
}

enum Status {
  loading,
  success,
  failed,
  empty,
}

///this enum is used in [ChangePasswordScreen] as the popup menu items
enum EditProfileNavigator {
  editProfile,
  changePassword,
}

///this list is a global list used to store phone numbers in edit profile screen
List<String> storePhoneNumbers = [];
