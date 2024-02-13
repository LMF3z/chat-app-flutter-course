import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String questionString;
  final String redirectString;

  const Labels({
    super.key,
    required this.route,
    required this.questionString,
    required this.redirectString,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          questionString,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, route);
          },
          child: Text(
            redirectString,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
