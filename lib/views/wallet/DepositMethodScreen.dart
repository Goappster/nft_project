import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For copying address
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart'; // For picking image proof

class DepositMethodScreen extends StatefulWidget {
  final String walletAddress;  // Assume you pass this address as an argument
  final String qrData;         // QR Code data (e.g., the wallet address or other data)

  DepositMethodScreen({required this.walletAddress, required this.qrData});

  @override
  _DepositMethodScreenState createState() => _DepositMethodScreenState();
}

class _DepositMethodScreenState extends State<DepositMethodScreen> {
  final _amountController = TextEditingController();
  XFile? _imageProof;

  // Function to pick image proof
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageProof = image;
    });
  }

  @override
  Widget build(BuildContext context) {

    final qrCode = QrCode.fromData(
      data: widget.qrData,
      errorCorrectLevel: QrErrorCorrectLevel.L,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Deposit Method"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://img.freepik.com/premium-vector/qr-code-icon-vector-isolated-white-background-vector-illustration_612390-356.jpg?ga=GA1.1.859183070.1742399369&semt=ais_hybrid&w=740'),
            SizedBox(height: 20),
            Text(
              "Deposit Address",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.walletAddress,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            SizedBox(height: 10),
            // Button to copy address
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: widget.walletAddress));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Address copied to clipboard")));
              },
              child: Text("Copy Address"),
            ),
            SizedBox(height: 20),
            // Amount Input Field
            Text(
              "Enter Deposit Amount",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Image Proof Option
            Text(
              "Upload Payment Proof (Optional)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Choose Image"),
            ),
            SizedBox(height: 20),
            // If image is selected, show it
            if (_imageProof != null)
              Image.file(
                File(_imageProof!.path),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Handle the submission logic here
                String amount = _amountController.text;
                if (amount.isNotEmpty) {
                  // Handle the deposit process
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Deposit Amount: $amount"),
                  ));
                  // Proceed with backend API or further steps
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please enter the amount"),
                  ));
                }
              },
              child: Text("Submit Deposit"),
            ),
          ],
        ),
      ),
    );
  }
}
