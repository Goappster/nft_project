import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class FundsController extends GetxController {
//   var funds = 0.0.obs;
//   var deposits = 0.0.obs; // Observable to store the response
//
//   // Function to make the POST request with parameters directly
//   Future<void> fetchFunds(String userId) async {
//     try {
//       final url = Uri.parse('https://dev.appezio.com/getfunds.php');
//
//       // Send POST request with the user_id as a parameter in the body
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'user_id': userId}),
//       );
//
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         print(data);
//
//         // Remove commas from balance and parse the value
//         String balanceString = data['balance'].toString().replaceAll(',', '');
//         String total_deposits = data['total_deposits'].toString().replaceAll(',', '');
//         funds.value = double.tryParse(balanceString) ?? 0.0;
//         deposits.value = double.tryParse(total_deposits)?? 0.0;// Parse the cleaned balance
//       } else {
//         print('Failed to load funds. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }


// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class FundsController extends GetxController {
  var funds = 0.0.obs;         // USD balance
  var deposits = 0.0.obs;      // Total deposits
  var estimatedPKR = 0.0.obs;  // Converted balance in PKR

  Future<void> fetchFunds(String userId) async {
    try {
      final url = Uri.parse('https://dev.appezio.com/getfunds.php');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);

        String balanceString = data['balance'].toString().replaceAll(',', '');
        String total_deposits = data['total_deposits'].toString().replaceAll(',', '');

        funds.value = double.tryParse(balanceString) ?? 0.0;
        deposits.value = double.tryParse(total_deposits) ?? 0.0;

        // Call conversion after getting balance
        convertUSDtoPKR(funds.value);
      } else {
        print('Failed to load funds. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> convertUSDtoPKR(double amount) async {
    try {
      final url = Uri.parse(
        'https://api.getgeoapi.com/v2/currency/convert'
            '?api_key=6606214cf47d4bede76db5c0e9ee1907e28aa459'
            '&from=USD&to=PKR&amount=$amount&format=json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var rate = double.tryParse(data['rates']['PKR']['rate_for_amount'].toString()) ?? 0.0;
        estimatedPKR.value = rate;
      } else {
        print('Failed to convert USD to PKR. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during conversion: $e');
    }
  }
}
