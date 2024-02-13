import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String labelText;
  final void Function()? onPress;

  const CustomElevatedButton({
    super.key,
    this.labelText = 'label',
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(2),
        backgroundColor: const MaterialStatePropertyAll(Colors.blueAccent),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                labelText,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
