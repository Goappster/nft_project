import 'package:dio/dio.dart';
import '../model/nft_model.dart';

import 'package:dio/dio.dart';
import '../model/nft_model.dart';

class NFTRepository {
  final Dio _dio = Dio();

  Future<List<NFTModel>> fetchUserNFTs(int userId) async {
    try {
      final response = await _dio.post(
        "https://dev.appezio.com/get_user_nfts.php",
        queryParameters: {
          "user_id": userId.toString(), // ✅ Must be in query
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      print("📦 API Response: ${response.data}");

      if (response.data['status'] == 'success') {
        final List data = response.data['data'];
        return data.map((json) => NFTModel.fromJson(json)).toList();
      } else {
        throw Exception("API Error: ${response.data}");
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.message}");
      print("📉 Response: ${e.response?.data}");
      throw Exception("Dio failed with status code ${e.response?.statusCode}");
    }
  }
}

