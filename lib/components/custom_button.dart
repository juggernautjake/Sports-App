import 'package:flutter/material.dart';
import '../color_palette.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;

  const CustomButton({
    required this.onPressed,
    required this.text,
    required this.color,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _hovering = true),
      onExit: (event) => setState(() => _hovering = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _hovering ? ColorPalette.secondaryColor : widget.color,
          foregroundColor: Colors.white, // Text color
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
