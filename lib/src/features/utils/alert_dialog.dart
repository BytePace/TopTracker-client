import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/resources/text.dart';

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
        style: Theme.of(context).textTheme.labelMedium,
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              DisplayText.alertCancel,
              style: Theme.of(context).textTheme.labelMedium,
            )),
        isYes
      ],
    );
  }
}
