import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TokenScreen extends StatelessWidget {
  Map tokenData;

  TokenScreen(this.tokenData);

  TextStyle tableValue = TextStyle(
      fontWeight: FontWeight.bold, color: Color.fromRGBO(35, 97, 161, 1));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Token\nOverview",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(35, 97, 161, 1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Divider(),
                  ),
                  ListTile(
                    title: Text("Doctor"),
                    trailing: Text(
                      "Dr. ${tokenData['doctor']}",
                      style: tableValue,
                    ),
                  ),
                  ListTile(
                    title: Text("Slot"),
                    trailing: Text(
                      "${tokenData['slot']}",
                      style: tableValue,
                    ),
                  ),
                  ListTile(
                    title: Text("Symptoms"),
                    trailing: Text(
                      "${tokenData['symptoms']}",
                      style: tableValue,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                    title: Text("Token\nPosted"),
                    trailing: Text(
                      DateFormat.yMMMMd().format(DateTime.parse(
                              tokenData['time_posted']
                                  .toString()
                                  .split('+')[0])) +
                          " - " +
                          DateFormat.jm().format(DateTime.parse(
                              tokenData['time_posted']
                                  .toString()
                                  .split('+')[0])),
                      style: tableValue,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4,
                              color: Color.fromRGBO(35, 97, 161, 1))
                        ],
                        color: Color.fromRGBO(35, 97, 161, 1),
                        borderRadius: BorderRadius.circular(6)),
                    child: ListTile(
                      title: Text(
                        "Date time\nexpected",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        DateFormat.yMMMMd().format(
                                DateTime.parse(tokenData['date_expected'])) +
                            " - " +
                            tokenData['slot'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                color: Colors.yellow,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Note : Once you post an appointment token doctor will assign you the time of appointment according to selected slot."),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
