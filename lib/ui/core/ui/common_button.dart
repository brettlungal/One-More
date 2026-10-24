import 'package:flutter/material.dart';
class CommonButton extends StatefulWidget {
  final VoidCallback onPressed;
  const CommonButton({super.key, required this.onPressed});

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton>{

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375,
      child: FilledButton(
        onPressed: widget.onPressed,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'PLAY',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
