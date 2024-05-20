class User {
  final String accessToken;
  final String refreshToken;
  final String email;
  final String guid;
  final String title;
  final bool isAdmin;
  final String profilePicture;
  final String currentUser;

  User({
    required this.accessToken,
    required this.refreshToken,
    required this.email,
    required this.guid,
    required this.title,
    required this.isAdmin,
    required this.profilePicture,
    required this.currentUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      email: json['user_mail'],
      guid: json['user_guid'],
      title: json['user_title'],
      isAdmin: json['user_isAdmin'].toLowerCase() == 'true',
      profilePicture: json['user_profilePicture'],
      currentUser: json['current_user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user_mail': email,
      'user_guid': guid,
      'user_title': title,
      'user_isAdmin': isAdmin.toString(),
      'user_profilePicture': profilePicture,
      'current_user': currentUser,
    };
  }
}
