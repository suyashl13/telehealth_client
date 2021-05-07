import 'package:flutter/material.dart';
import 'package:telehealth_client/screens/history_page/AllAppointments.dart';
import 'package:telehealth_client/screens/history_page/AllTreatments.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 50,
            backgroundColor: Color.fromRGBO(35, 97, 161, 1),
            title: TabBar(
              tabs: [
                Tab(
                  child: Text("Treatments"),
                ),
                Tab(
                  child: Text("Appointments"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[AllTreatments(), AllAppointments()],
          ),
        ));
  }
}
