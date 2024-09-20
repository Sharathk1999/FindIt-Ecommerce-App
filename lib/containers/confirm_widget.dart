import 'package:flutter/material.dart';

class ConfirmWidget extends StatefulWidget {
  final String contentText;
  final VoidCallback onYes, onNo;
  const ConfirmWidget({
    super.key,
    required this.contentText,
    required this.onYes,
    required this.onNo,
  });

  @override
  State<ConfirmWidget> createState() => _ConfirmWidgetState();
}

class _ConfirmWidgetState extends State<ConfirmWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:const Text("Are you sure?"),
      content: Text(widget.contentText),
      actions: [
        TextButton(onPressed: widget.onNo, child:const Text("No",),),
        TextButton(onPressed: widget.onYes, child:const Text("Yes",),),
      ],
    );
  }
}