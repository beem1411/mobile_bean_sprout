import 'package:flutter/material.dart';

class AddDeviceButton extends StatelessWidget {
  final VoidCallback onTap;

  AddDeviceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(Icons.add, size: 48, color: Colors.grey),
        ),
      ),
    );
  }
}
