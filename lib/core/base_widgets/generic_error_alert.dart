import 'package:flutter/material.dart';

class GenericErrorAlert extends StatelessWidget {
  GenericErrorAlert({super.key, required this.error});

  String error;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: Icon(Icons.shield, color: Color(0xffef5360))),
        Expanded(
          flex: 6,
          child: Text(
            this.error,
            style: const TextStyle(
              color: Color(0xffef5360),
              fontSize: 14,
              fontFamily: "Comfortaa",
            ),
          ),
        ),
      ],
    );
  }
}
