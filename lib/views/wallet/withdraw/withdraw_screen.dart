import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final double currentBalance = 2543.55;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Withdraw", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Wallet Address", style: TextStyle(color: Colors.white70)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter address",
                      hintStyle: TextStyle(color: Colors.white38),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: pasteAddress,
                  icon: Icon(Icons.paste, color: Colors.limeAccent.shade400),
                )
              ],
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter amount",
                hintStyle: TextStyle(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 12),
            Text("Current Balance: \$${currentBalance.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.limeAccent.shade400)),
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
    );
  }
}
