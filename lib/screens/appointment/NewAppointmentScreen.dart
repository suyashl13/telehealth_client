import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewAppointmentScreen extends StatefulWidget {
  Map doctorDetails;
  NewAppointmentScreen({@required this.doctorDetails});
  @override
  _NewAppointmentScreenState createState() =>
      _NewAppointmentScreenState(doctorDetails: this.doctorDetails);
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  Map doctorDetails = {};

  _NewAppointmentScreenState({@required this.doctorDetails}) {
    print(doctorDetails);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 26, vertical: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dr. ${doctorDetails['profile']['name']}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(35, 97, 161, 1),
                )),
            Text("${doctorDetails['specializations']}",
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            SizedBox(
              width: 160,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("${doctorDetails['bio']}"),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: TextFormField(
                cursorColor: Colors.white,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: "Describe your symptoms.",
                    border: OutlineInputBorder()),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    ));
  }
}
