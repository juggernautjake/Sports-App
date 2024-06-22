// components/hover_button.dart
import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const HoverButton({
    required this.onPressed,
    required this.child,
  });

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _hovering = true),
      onExit: (event) => setState(() => _hovering = false),
      child: GestureDetector(
        onTapDown: (details) => setState(() => _pressed = true),
        onTapUp: (details) => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          decoration: BoxDecoration(
            color: _pressed
                ? Colors.lightBlueAccent
                : (_hovering ? Colors.blueAccent : Colors.blue),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: AnimatedDefaultTextStyle(
            style: TextStyle(
              color: Colors.white,
              fontSize: _hovering ? 18 : 16,
            ),
            duration: Duration(milliseconds: 200),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
