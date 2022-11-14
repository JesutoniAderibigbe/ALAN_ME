import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  MyTextBox({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
            padding: EdgeInsets.all(10),
            child: Center(child: Text(text)),
            color: Colors.grey[200]),
      ),
    );
  }
}
