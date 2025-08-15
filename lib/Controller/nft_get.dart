import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:untitled/model/GroupedCategoryModel.dart';




class GridController extends GetxController {
  var isLoading = true.obs;
  var groupedItems = <GroupedCategoryModel>[].obs;
  var selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  Future<void> fetchItems() async {
    try {
      var response = await Dio().get("https://dev.appezio.com/getnft.php");

      if (response.statusCode == 200) {
        var jsonData = response.data;

        if (jsonData["data"] is List) {
          groupedItems.value = (jsonData["data"] as List)
              .map((e) => GroupedCategoryModel.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching NFTs: $e");
      }
    } finally {
      isLoading(false);
    }
  }
}
