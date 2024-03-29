import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final BuildContext ctx;
  final String title;
  final String content;
  final Widget isYes;
  const MyAlertDialog(
      {super.key,
      required this.ctx,
      required this.title,
      required this.content,
      required this.isYes});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      content: Text(
        content,
        style: const TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            )),
        isYes
      ],
    );
  }
}
