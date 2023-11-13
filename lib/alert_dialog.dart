import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  
  BuildContext context, 
  String text,  // content
  String errorType, // title
  String opt_1, // button 1
  String opt_2, // button 2
) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(errorType),
        content: Text(text),
        actions: <Widget>[
          Row(
            textDirection: TextDirection.rtl,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("$opt_1"),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("$opt_2"),
              ),
            ],
          ),
        ],
      );  
    });
  }