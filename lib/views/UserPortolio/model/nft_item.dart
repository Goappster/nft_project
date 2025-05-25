class NFTItem {
  final int id;
  final String nftName;
  final String imageUrl;
  final String amount;
  final String createdAt;
  final int? userId;
  final String? username;

  NFTItem({
    required this.id,
    required this.nftName,
    required this.imageUrl,
    required this.amount,
    required this.createdAt,
    this.userId,
    this.username,
  });

  factory NFTItem.fromJson(Map<String, dynamic> json) {
    return NFTItem(
      id: json['id'],
      nftName: json['nft_name'],
      imageUrl: json['image_url'],
      amount: json['amount'],
      createdAt: json['created_at'],
      userId: json['user_id'],
      username: json['username'],
    );
  }
}
