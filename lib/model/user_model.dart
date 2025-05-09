class UserModel {
  final int id;
  final String name;
  final String email;
  final String mobile;
  final String walletAddress;
  final String referralCode;
  final int? referrerId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.walletAddress,
    required this.referralCode,
    this.referrerId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      walletAddress: json['wallet_address'],
      referralCode: json['referral_code'],
      referrerId: json['referrer_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "wallet_address": walletAddress,
    "referral_code": referralCode,
    "referrer_id": referrerId,
  };
}
