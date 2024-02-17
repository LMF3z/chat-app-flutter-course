import 'package:flutter/material.dart';

showCustomAlert(BuildContext context, String title, String subTitle) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(subTitle),
        actions: [
          MaterialButton(
            elevation: 6,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
