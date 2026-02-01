class User {
  final String userId;
  final String email;
  final String username;
  
  User({
    required this.userId,
    required this.email,
    required this.username,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'username': username,
    };
  }
}
