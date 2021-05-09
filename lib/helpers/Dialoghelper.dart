import 'package:flutter/material.dart';

class DialogHelper {
  showSuccessMessage(BuildContext context, String successMessage) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Success.",
          style: TextStyle(color: Color.fromRGBO(35, 97, 161, 1)),
        ),
        content: Text(successMessage),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("Ok"))
        ],
      ),
    );
  }
}
