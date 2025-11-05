import 'package:flutter/material.dart';

class CuteButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CuteButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black, width: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 35,
            fontFamily: 'CuteFont',
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
