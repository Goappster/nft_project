import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Controller/balance.dart';
import '../../../tes.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String selectedNetwork = 'BNB';
  final List<String> networks = ['BNB', 'TRON', 'ETH'];

  void pasteAddress() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      setState(() {
        _addressController.text = data.text!;
      });
    }
  }

  void handleWithdraw() {
    final address = _addressController.text.trim();
    final amount = _amountController.text.trim();

    if (address.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // TODO: Add actual withdrawal logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Withdrawal of $amount on $selectedNetwork initiated.')),
    );
  }

  final FundsController controller = Get.put(FundsController());

  @override
  void initState() {
    super.initState();
    // Fetch the funds automatically when the screen is loaded
    controller.fetchFunds('39');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Withdraw", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Wallet Address", style: TextStyle(color: Colors.white70)),
              TextField(
                controller: _addressController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Enter Wallet Address",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  // Default border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // Border when enabled (not focused)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
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
                  suffixIcon: IconButton(
                    onPressed: pasteAddress,
                    icon: Icon(Icons.paste, color: Colors.grey),
                    tooltip: "Paste Address",
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 16),
              const Text("Select Network", style: TextStyle(color: Colors.white70)),
              DropdownButton<String>(
                dropdownColor: Colors.black87,
                value: selectedNetwork,
                items: networks.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedNetwork = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text("Withdrawal Amount", style: TextStyle(color: Colors.white70)),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: false,
                  // Default border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
        
                  // Border when enabled (not focused)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
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
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Obx(() {
                String formattedBalance = NumberFormat("#,##0.00", "en_US").format(controller.funds.value);
                return Text(
                  "Current Balance: \$${formattedBalance}",  // Show balance even if 0.00
                    style: TextStyle(color: Colors.limeAccent.shade400)
                );
              }),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Please ensure the address and network are correct. Wrong details may result in permanent loss of funds.",
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 13),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleWithdraw,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.limeAccent.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Withdraw", style: TextStyle(color: Colors.black)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
