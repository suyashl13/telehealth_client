import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telehealth_client/contexts/Treatments.dart';
import 'package:telehealth_client/helpers/TreatmentsHelper.dart';
import 'package:telehealth_client/screens/treatments/TreatmentPage.dart';

class HomeTreatments extends StatefulWidget {
  @override
  _HomeTreatmentsState createState() => _HomeTreatmentsState();
}

class _HomeTreatmentsState extends State<HomeTreatments>
    with AutomaticKeepAliveClientMixin<HomeTreatments> {
  var treatmentsData = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    await TreatmentsHelper().getAllTreatments(
        // ignore: missing_return
        onSuccess: (data) {
      List tempData = jsonDecode(data);
      Provider.of<Treatments>(context, listen: false)
          .setAllTreatments(tempData);
      Provider.of<Treatments>(context, listen: false)
          .setActiveTreatments(_filterTreatments(tempData));
      setState(() {
        isLoading = false;
      });
    },
        // ignore: missing_return
        onError: (error) {
      setState(() {
        isError = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(new SnackBar(content: Text(error.toString())));
      });
    });
  }

  _filterTreatments(List treatmentsArray) {
    List filteredData = [];

    for (var item in treatmentsArray) {
      if (!item['is_treated']) {
        filteredData.add(item);
      }
    }
    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<Treatments>(
        builder: (context, treatments, child) => isError
            ? Center(
                child: Text("data"),
              )
            : isLoading
                ? Center(child: CircularProgressIndicator())
                : treatments.activeTreatments.length == 0
                    ? Center(child: Text("No ongoing treatments"))
                    : ListView.builder(
                        itemCount: treatments.activeTreatments.length,
                        itemBuilder: (context, index) => ListTile(
                            title: Text("Dr. " +
                                treatments.activeTreatments[index]['doctor']
                                    .toString()),
                            subtitle: Text(treatments.activeTreatments[index]
                                    ['symptoms']
                                .toString()),
                            trailing: Card(
                              elevation: 0,
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  "See Treatment",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TreatmentPage(
                                      treatmentData:
                                          treatments.activeTreatments[index]),
                                )))));
  }

  @override
  bool get wantKeepAlive => true;
}
