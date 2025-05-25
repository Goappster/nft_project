import 'nft_item.dart';

class NFTModel {
  final String status;
  final int count;
  final List<NFTItem> data;
  final double totalValue;
  final double current7DaysTotal;
  final double last7DaysTotal;
  final double growthRate;

  NFTModel({
    required this.status,
    required this.count,
    required this.data,
    required this.totalValue,
    required this.current7DaysTotal,
    required this.last7DaysTotal,
    required this.growthRate,
  });

  factory NFTModel.fromJson(Map<String, dynamic> json) {
    return NFTModel(
      status: json['status'],
      count: json['count'],
      data: (json['data'] as List)
          .map((item) => NFTItem.fromJson(item))
          .toList(),
      totalValue: (json['total_value'] as num).toDouble(),
      current7DaysTotal: (json['current_7_days_total'] as num).toDouble(),
      last7DaysTotal: (json['last_7_days_total'] as num).toDouble(),
      growthRate: (json['growth_rate'] as num).toDouble(),
    );
  }
}
