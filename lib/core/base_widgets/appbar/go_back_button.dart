import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  GoBackButton({super.key, required this.title});
  String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.chevron_left, color: Colors.white, size: 50),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
