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