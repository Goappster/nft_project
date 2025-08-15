import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:untitled/app_theme.dart';
import 'package:untitled/routes.dart';

import '../../tes.dart';

class DepositScreen extends StatefulWidget {
final String name; final String network;

  const DepositScreen({super.key, required this.name, required this.network});
  @override
  _DepositScreenState createState() => _DepositScreenState();
}
bool isLoading = false;

const String walletAddress = '0x55d398326f99059ff775485246999027b3197955';
const String qrData = '0x55d398326f99059ff775485246999027b3197955';
const String userId = '39'; // Replace with actual user ID

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Dialog(
      // backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.limeAccent.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom animated loader
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
              strokeWidth: 4,
            ),
            SizedBox(height: 20),
            Text(
              "Please wait...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Processing your request",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop(); // Hide dialog
}


class _DepositScreenState extends State<DepositScreen> {
  List<String> images = [];
  List<XFile> selectedImages = [];
  final picker = ImagePicker();
  final String uploadUrl = "https://dev.appezio.com/api/upload.php";

  final _amountController = TextEditingController();

  Future<void> uploadImage() async {

    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    // Check if there's already an image selected
    if (selectedImages.length >= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only upload 1 image.")),
      );
      return;
    }

    setState(() {
      selectedImages.add(pickedFile);
    });
  }


  Future<void> submitDeposit() async {
    String amount = _amountController.text.trim();
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter the amount")));
      return;
    }
    showLoadingDialog(context); // Show loader
    try {
      for (var imageFile in selectedImages) {
        try {
          var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
          request.fields['user_id'] = userId;
          request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
          var res = await request.send();

          final body = await res.stream.bytesToString();
          final data = jsonDecode(body);

          if (res.statusCode == 200 && data['status'] == 'success') {
            images.add(data['url']);
            // Use actual dynamic values from response or input
            await makeApiCall(context, amount, data['url'], data['image_id'].toString());
          } else {
            hideLoadingDialog(context); // Hide loader no matter what
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'] ?? 'Upload failed.')));
          }
        } catch (e) {
          hideLoadingDialog(context); // Hide loader no matter what
          print('Error uploading image: $e');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error uploading image")));
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deposit of $amount submitted.")));
      setState(() {
        selectedImages.clear();
        _amountController.clear();
      });
    } finally {

    }
  }


  String getShortAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }


  Future<void> makeApiCall(BuildContext context, String amount, String imageUrl, String imageId) async {
    final url = 'https://dev.appezio.com/deposit.php';

    final Map<String, dynamic> body = {
      "user_id": "39",
      "amount": amount,
      "user_name": "ghani",
      "user_email": "ghani@gmail.com",
      "network": "bep20",
      "name": "bnb",
      "image_url": imageUrl,
      "image_id": imageId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
      hideLoadingDialog(context); // Hide loader no matter what
      showPaymentSuccessDialog(context);
    } else {
      hideLoadingDialog(context); // Hide loader no matter what
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(jsonResponse['message'] ?? 'Something went wrong.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar( backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black),
      title:                                       Text(
        "${widget.name} (${widget.network})",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black
        ),
      ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(
  child: Container(
    padding: EdgeInsets.all(8), // optional spacing around QR
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.primaryLight, // Set your desired border color
        width: 2,           // Border width
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: QrImageView(
        data: qrData,
        size: 200,
        backgroundColor: Colors.white,
      ),
    ),
  ),
),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    getShortAddress(walletAddress),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.black, size: 20,),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: walletAddress));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Address copied")),
                      );
                    },
                  ),
                ],
              ),


              const SizedBox(height: 16),

              const Text("Enter Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Type the amount (in USDT)",
                  hintStyle:  TextStyle(color: Colors.black45, fontSize: 12.sp),
                  filled: false,
                  // Default border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // Border when enabled (not focused)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),

                  // Border when focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primaryLight,
                      width: 1,
                    ),
                  ),

                  // Optional: prefix icon
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0), // Optional: adjust padding as needed
                    child: SizedBox(
                      width: 24,  // or use 8.w if you are using flutter_screenutil
                      height: 24, // or use 8.h
                      child: SvgPicture.string(
                        usdTSvg,
                        fit: BoxFit.contain, // Better fit for icons
                      ),
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),


              const SizedBox(height: 12),

              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  children: [
                    const TextSpan(text: "• Avoid transactions with restricted or sanctioned entities. "),
                    TextSpan(
                      text: "More info\n",
                      style: TextStyle(color: AppColors.scaffoldDark, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: "• Please do not send NFTs to this wallet address.\n"),
                    const TextSpan(
                      text: "• Smart contract deposits are generally unsupported — except for ETH (ERC20), BNB (BSC), Arbitrum, and Optimism.\n",
                    ),
                  ],
                ),
              ),
              Text("Payment Screenshots", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.scaffoldDark)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: uploadImage, // Your image upload function
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: [6, 4],
                  color: Colors.black,
                  strokeWidth: 1,
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 25, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          "Choose Image(s)",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
              const SizedBox(height: 20),
              selectedImages.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Selected Proofs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  // SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedImages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          SizedBox(
                      // height: 150,
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(selectedImages[index].path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 6,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImages.removeAt(index);
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.primaryLight,
                                  child: Icon(Icons.close, size: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              )
                  : const SizedBox(height: 30,),

              // const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    submitDeposit();
                  },
                  child: const Text("Submit Deposit", style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primaryLight,
                    textStyle: const TextStyle(fontSize: 16),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showPaymentSuccessDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            // margin: EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(vertical: 24, ),
            decoration: BoxDecoration(
              color: Colors.limeAccent.shade400,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                CircleAvatar(
                  radius: 25, // You can adjust the size
                  backgroundColor: Colors.black, // optional background
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.limeAccent.shade400,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Payment successfully processed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The order has been sent to the restaurant.',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
