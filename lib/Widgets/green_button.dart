import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GreenButton extends StatelessWidget {
  final VoidCallback? onPressed;
  var buttonText;

  GreenButton({this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF109428),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(35.0),
        ),
      ),
    );
  }
}
