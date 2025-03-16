import 'package:dio/dio.dart';

class NftService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.opensea.io/api/v2/',
    headers: {
      'Accept': 'application/json',
      'X-API-KEY': '7228627c37664a99be7c4a231efc0478', // Replace with your actual API key
    },
  ));

  Future<Map<String, dynamic>> fetchCollections({String? pageKey, String orderBy = 'one_day_change'}) async {
    try {
      final response = await _dio.get('collections', queryParameters: {
        if (pageKey != null) 'cursor': pageKey, // Pagination key
        'order_by': orderBy, // Order by one_day_change or other criteria
      });

      if (response.statusCode == 200) {
        return {
          'collections': response.data['collections'] as List<dynamic>,
          'next': response.data['next'], // Next page cursor
        };
      } else {
        throw Exception('Failed to load collections');
      }
    } catch (e) {
      throw Exception('Error fetching collections: $e');
    }
  }
}
