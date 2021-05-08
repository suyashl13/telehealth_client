import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telehealth_client/screens/wrapper.dart';

// ignore: must_be_immutable
class PaymentInfoScreen extends StatelessWidget {
  bool isSuccessed;

  PaymentInfoScreen({@required this.isSuccessed});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(),
          Center(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: isSuccessed ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(54)),
              child: isSuccessed
                  ? Icon(
                      Icons.check,
                      size: 74,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.cancel_outlined,
                      size: 74,
                      color: Colors.white,
                    ),
            ),
          ),
          SizedBox(),
          SizedBox(),
          !isSuccessed
              ? Center(
                  child: Text(
                    "Oops! Unable to complete appointment. We'll repay fees shortly on your account.",
                    textAlign: TextAlign.center,
                  ),
                )
              : Center(
                  child: Text(
                    "Booked an appointment successfully!\n Doctor will shortly assign you timing and you'll recive a call soon.",
                    textAlign: TextAlign.center,
                  ),
                ),
          SizedBox(),
          MaterialButton(
            elevation: 0,
            textColor: Colors.white,
            color: Color.fromRGBO(35, 97, 161, 1),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => wrapper()));
            },
            child: Text("Back to Home"),
          )
        ],
      ),
    );
  }
}
