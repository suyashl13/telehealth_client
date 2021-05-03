import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telehealth_client/components/AppointmentsList.dart';
import 'package:telehealth_client/components/TokensLists.dart';
import 'package:telehealth_client/contexts/Appointments.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview>
    with SingleTickerProviderStateMixin {
  var _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Appointments>(builder: (context, appointments, child) {
      return Column(
        children: [
          Center(
            child: Container(
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Color.fromRGBO(35, 97, 161, 1),
                    automaticIndicatorColorAdjustment: true,
                    controller: _controller,
                    tabs: [
                      Tab(
                        child: Text(
                          "Appointments",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(35, 97, 161, 1),
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Tokens",
                          style: TextStyle(
                            color: Color.fromRGBO(35, 97, 161, 1),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Expanded(
              child: DefaultTabController(
            length: 2,
            child: TabBarView(
              controller: _controller,
              children: [AppointmentList(), TokensList()],
            ),
          )),
        ],
      );
    });
  }
}
