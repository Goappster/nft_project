class ItemModel {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String imageUrl;
  final String price;
  final String createdAt;

  ItemModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json["id"] ?? "",
      ownerId: json["owner_id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      imageUrl: 'https://dev.appezio.com/${json["image_url"]}' ?? "",
      price: json["price"] ?? "0.00",
      createdAt: json["created_at"] ?? "",
    );
  }
}

