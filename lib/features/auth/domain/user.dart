class User {
  final String id;
  final String screenName;
  final String? accessToken;

  const User({
    required this.id,
    required this.screenName,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      screenName: json['screen_name'] as String,
      accessToken: json['access_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'screen_name': screenName,
      if (accessToken != null) 'access_token': accessToken,
    };
  }

  User copyWith({
    String? screenName,
  }) {
    return User(
      id: id,
      screenName: screenName ?? this.screenName,
      accessToken: accessToken,
    );
  }
}
