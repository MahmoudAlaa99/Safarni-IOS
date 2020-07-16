class Profile {
  final String id;
  final String user;
  String userName;
  String displayPicture;
  String picture;
  String firstName;
  String lastName;
  bool isPrivate;
  List<String> phoneNumbers;

  Profile({
    this.id,
    this.user,
    this.userName,
    this.displayPicture,
    this.picture,
    this.firstName,
    this.lastName,
    this.isPrivate,
    this.phoneNumbers,
  });
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'],
      user: json['user'],
      userName: json['userName'],
      displayPicture: json['displayPicture'],
      picture: json['picture'],
      firstName: json['displayName']['firstName'],
      lastName: json['displayName']['lastName'],
      isPrivate: json['isPrivate'],
      //phoneNumbers: json['phoneNumbers'], //to be updated when the request is updated
    );
  }
}
