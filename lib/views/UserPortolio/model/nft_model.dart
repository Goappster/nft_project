class NFTModel {
  final int id;
  final String nftName;
  final String imageUrl;
  final String amount;
  final String createdAt;

  NFTModel({
    required this.id,
    required this.nftName,
    required this.imageUrl,
    required this.amount,
    required this.createdAt,
  });

  factory NFTModel.fromJson(Map<String, dynamic> json) {
    return NFTModel(
      id: json['id'],
      nftName: json['nft_name'],
      imageUrl: json['image_url'],
      amount: json['amount'],
      createdAt: json['created_at'],
    );
  }
}
