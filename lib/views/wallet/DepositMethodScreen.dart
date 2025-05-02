import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DepositScreen extends StatefulWidget {
final String name; final String network;

  const DepositScreen({super.key, required this.name, required this.network});
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

final String walletAddress = '0x55d398326f99059ff775485246999027b3197955';
final String qrData = 'fafafa';
final String userId = '39'; // Replace with actual user ID

class _DepositScreenState extends State<DepositScreen> {
  List<String> images = [];
  List<XFile> selectedImages = [];
  final picker = ImagePicker();
  final String uploadUrl = "https://dev.appezio.com/api/upload.php";

  final _amountController = TextEditingController();

  Future<void> uploadImage() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles == null || pickedFiles.isEmpty) return;

    setState(() {
      selectedImages.addAll(pickedFiles);
    });
  }

  Future<void> submitDeposit() async {
    String amount = _amountController.text.trim();
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter the amount")));
      return;
    }

    for (var imageFile in selectedImages) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
        request.fields['user_id'] = userId;
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
        var res = await request.send();

        if (res.statusCode == 200) {
          ;  // Add this line to print the response

          final body = await res.stream.bytesToString();

          final data = jsonDecode(body);
          print(data);
          if (data['status'] == 'success') {
            images.add(data['url']);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to upload image.")));
        }
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error uploading image")));
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deposit of $amount submitted.")));
    setState(() {
      selectedImages.clear();
      _amountController.clear();
    });
  }

  String getShortAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(  backgroundColor: Colors.black, iconTheme: IconThemeData(color: Colors.white),
      title:                                       Text(
        "${widget.name} (${widget.network})",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                  child: QrImageView(
                    data: qrData,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    getShortAddress(walletAddress),
                    style: TextStyle(fontSize: 16, color: Colors.limeAccent.shade400),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.limeAccent.shade400, size: 20,),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: walletAddress));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Address copied")),
                      );
                    },
                  ),
                ],
              ),


              SizedBox(height: 16),

              Text("Enter Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: false,
                  // Default border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // Border when enabled (not focused)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white38,
                      width: 1,
                    ),
                  ),

                  // Border when focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.limeAccent.shade400,
                      width: 1,
                    ),
                  ),

                  // Optional: prefix icon
                  // prefixIcon: Icon(Icons.attach_money, color: Colors.limeAccent.shade400),
                ),
                style: TextStyle(color: Colors.white),
              ),


              SizedBox(height: 12),

              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  children: [
                    TextSpan(text: "• Avoid transactions with restricted or sanctioned entities. "),
                    TextSpan(
                      text: "More info\n",
                      style: TextStyle(color: Colors.limeAccent.shade400, decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: "• Please do not send NFTs to this wallet address.\n"),
                    TextSpan(
                      text: "• Smart contract deposits are generally unsupported — except for ETH (ERC20), BNB (BSC), Arbitrum, and Optimism.\n",
                    ),
                  ],
                ),
              ),


              Text("Upload Payment Proof", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.limeAccent.shade400)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: uploadImage, // Your image upload function
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  dashPattern: [6, 4],
                  color: Colors.white38,
                  strokeWidth: 1,
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    alignment: Alignment.center,
                    child: Row(
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
              SizedBox(height: 20),
              selectedImages.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Selected Proofs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  // SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedImages.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          SizedBox(
                      height: 150,
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.limeAccent.shade400,
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
                  : SizedBox(),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitDeposit,
                  child: Text("Submit Deposit", style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.limeAccent.shade400,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
