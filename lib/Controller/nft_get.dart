import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../model/nft_list.dart';


class GridController extends GetxController {
  var isLoading = true.obs;
  var items = <ItemModel>[].obs;

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  Future<void> fetchItems() async {
    try {
      var response = await Dio().get("https://dev.appezio.com/getnft.php");

      if (response.statusCode == 200) {
        var jsonData = response.data; // Response is a Map

        if (jsonData["data"] is List) {
          items.value = (jsonData["data"] as List)
              .map((e) => ItemModel.fromJson(e))
              .toList();
        } else {
          if (kDebugMode) {
            print("Error: Expected a list in 'data' key, but got something else.");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    } finally {
      isLoading(false);
    }
  }

}
