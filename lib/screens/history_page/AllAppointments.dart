import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telehealth_client/contexts/Appointments.dart';
import 'package:telehealth_client/screens/appointment/AppointmentScreen.dart';

class AllAppointments extends StatefulWidget {
  @override
  _AllAppointmentsState createState() => _AllAppointmentsState();
}

class _AllAppointmentsState extends State<AllAppointments> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Appointments>(
      builder: (context, appointments, child) => ListView.builder(
          itemCount: appointments.activeAppointments.length,
          itemBuilder: (context, index) => ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentScreen(
                          appointments.activeAppointments[index]),
                    )),
                title: Text(
                    "Dr. ${appointments.activeAppointments[index]['doctor']}"),
                subtitle: Text("Time Allocated : " +
                    DateFormat.yMMMMd().format(DateTime.parse(appointments
                        .activeAppointments[index]['time_posted']
                        .toString()
                        .split('+')[0])) +
                    " - " +
                    DateFormat.jm().format(DateTime.parse(appointments
                        .activeAppointments[index]['time_posted']
                        .toString()
                        .split('+')[0]))),
                trailing: Card(
                  elevation: 0,
                  color: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Upcomming",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              )),
    );
  }
}
