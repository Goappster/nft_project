import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DepositScreen extends StatefulWidget {
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
          final body = await res.stream.bytesToString();
          final data = jsonDecode(body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(  backgroundColor: Colors.black, iconTheme: IconThemeData(color: Colors.white),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: QrImageView(
                  data: qrData,
                  size: 180,
                  backgroundColor: Colors.limeAccent.shade400
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      walletAddress,
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: walletAddress));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Address copied")));
                    },
                  )
                ],
              ),

              SizedBox(height: 30),

              Text("Enter Deposit Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.limeAccent.shade400)),
              SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.attach_money),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),

              SizedBox(height: 24),

              Text("Upload Payment Proof (Optional)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: uploadImage,
                icon: Icon(Icons.upload_file, color: Colors.limeAccent.shade400,),
                label: Text("Choose Image(s)", style: TextStyle(color: Colors.limeAccent.shade400,)),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  side: BorderSide(color: Colors.white38, width: 1), // outline color and width
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
