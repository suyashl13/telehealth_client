import 'package:flutter/material.dart';

class IndicateServerDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.zero),
            Center(
                child: Image(
                    height: 294, image: AssetImage('assets/serverdown.jpg'))),
            Column(
              children: [
                Text(
                  "Server Down !!".toUpperCase(),
                  style: TextStyle(fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Our servers are facing some problem right now please try again later.",
                      textAlign: TextAlign.center),
                )
              ],
            ),
            Padding(padding: EdgeInsets.zero)
          ],
        ),
      ),
    );
  }
}
