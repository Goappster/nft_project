import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FundsController extends GetxController {
  var funds = 0.0.obs;
  var invest = 0.0.obs; // Observable to store the response

  // Function to make the POST request with parameters directly
  Future<void> fetchFunds(String userId) async {
    try {
      final url = Uri.parse('https://dev.appezio.com/getfunds.php');

      // Send POST request with the user_id as a parameter in the body
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);

        // Remove commas from balance and parse the value
        String balanceString = data['balance'].toString().replaceAll(',', '');
        String investment_balance = data['investment_balance'].toString().replaceAll(',', '');
        funds.value = double.tryParse(balanceString) ?? 0.0;
        invest.value = double.tryParse(investment_balance)?? 0.0;// Parse the cleaned balance
      } else {
        print('Failed to load funds. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
