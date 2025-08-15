import 'package:untitled/model/nft_list.dart';

class GroupedCategoryModel {
  final String category;
  final List<ItemModel> nfts;

  GroupedCategoryModel({required this.category, required this.nfts});

  factory GroupedCategoryModel.fromJson(Map<String, dynamic> json) {
    return GroupedCategoryModel(
      category: json['category'],
      nfts: (json['nfts'] as List)
          .map((e) => ItemModel.fromJson(e))
          .toList(),
    );
  }
}
