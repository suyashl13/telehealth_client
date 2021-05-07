import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:telehealth_client/contexts/Appointments.dart';
import 'package:telehealth_client/helpers/AppointmentsHelper.dart';
import 'package:telehealth_client/screens/appointment/AppointmentScreen.dart';

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;

  _setPage() async {
    // ignore: missing_return
    await AppointmentsHelper().getAllAppointments((data) {
      Provider.of<Appointments>(context, listen: false)
          .setallAppointments(jsonDecode(data));
      setState(() {
        isLoading = false;
      });
      // ignore: missing_return
    }, (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<Appointments>(
      builder: (context, appointments, child) => Container(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : appointments.activeAppointments.length == 0
                  ? Center(
                      child: Text("No active appointments"),
                    )
                  : ListView.builder(
                      itemCount: appointments.activeAppointments.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text("Dr. " +
                            appointments.activeAppointments[index]['doctor']),
                        subtitle: Text(
                            "${DateFormat.MMMMEEEEd().format(DateTime.parse(appointments.activeAppointments[index]['datetime_allocated'])) + " - " + DateFormat.jm().format(DateTime.parse(appointments.activeAppointments[index]['datetime_allocated']))}"),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentScreen(
                                  appointments.activeAppointments[index]),
                            )),
                        trailing: Card(
                          elevation: 0,
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "See Appointment",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
