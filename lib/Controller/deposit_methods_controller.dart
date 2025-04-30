import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DepositMethod {
  final String name;
  final String currency;
  final String network;
  final String walletAddress;
  final String? logoUrl;

  DepositMethod({
    required this.name,
    required this.currency,
    required this.network,
    required this.walletAddress,
    this.logoUrl,
  });

  factory DepositMethod.fromJson(Map<String, dynamic> json) {
    return DepositMethod(
      name: json['name'],
      currency: json['currency'],
      network: json['network'],
      walletAddress: json['wallet_address'],
      logoUrl: json['logo_url'],
    );
  }
}

class DepositMethodsController extends GetxController {
  var depositMethods = <DepositMethod>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchDepositMethods();
    super.onInit();
  }

  void fetchDepositMethods() async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('https://dev.appezio.com/deposit_methods.php'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          depositMethods.value = (data['data'] as List)
              .map((e) => DepositMethod.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
