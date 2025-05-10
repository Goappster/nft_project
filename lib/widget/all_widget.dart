import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback onPressed;

  final double width;
  final double height;

  const CustomButton({
    Key? key,
    this.text,
    this.child,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 50.0,
  })  : assert(text != null || child != null, "Either text or child must be provided"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.limeAccent.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(text!,
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
            ),
      ),
    );
  }
}


class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: const BorderSide(color: Colors.grey, width: 2), // Border styling
          activeColor: Colors.limeAccent.shade400,
          checkColor: const Color.fromARGB(255, 0, 0, 0), // Checkbox active color
        ),
        RichText(
          text:  TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.white),
            children: [
              TextSpan(text: "I agree with "),
              TextSpan(
                text: "Terms and conditions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.limeAccent.shade400, // Green color for emphasis
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}





class UserCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String email;
  final int points;

  const UserCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.email,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.limeAccent.shade700,
          // gradient: LinearGradient(
          //   colors: [Colors.indigo.shade300, Colors.blue.shade400],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 16),
            // User details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            // Points
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '$points',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
