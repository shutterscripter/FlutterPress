import 'package:flutter/material.dart';
import 'package:news_app/screen/search_result.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({super.key});

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  final TextEditingController _textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Topic of the News...'),
      content: TextField(
        textCapitalization: TextCapitalization.words,
        controller: _textEditingController,
        decoration: const InputDecoration(
          hintText: 'Eg.COVID-19 Pandemic',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(_textEditingController.text);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SearchResult(name: _textEditingController.text.toLowerCase()),
              ),
            );
          },
          child: const Text(
            'Search',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
