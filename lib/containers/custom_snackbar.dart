import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class CustomSnackbar extends StatelessWidget {
  final BuildContext ctx;
  final String title;
  final String message;
  final ContentType contentType;
  const CustomSnackbar({
    super.key,
    required this.ctx,
    required this.title,
    required this.message,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: title,
              message: message,
              contentType: contentType,
            ),
          ));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: const Text(
          'Show Snackbar',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
