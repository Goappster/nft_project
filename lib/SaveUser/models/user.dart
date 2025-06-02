class User {
  final int userId;
  final String name;
  final String email;
  final String walletAddress;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.walletAddress,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      walletAddress: map['walletAddress'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'walletAddress': walletAddress,
    };
  }
}
