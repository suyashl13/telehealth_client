import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telehealth_client/contexts/Treatments.dart';
import 'package:telehealth_client/screens/treatments/TreatmentPage.dart';

class AllTreatments extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<Treatments>(
      builder: (context, treatments, child) => ListView.builder(
            itemCount: treatments.allTreatments.length,
            itemBuilder: (context, index) => ListTile(
              title: Text("Dr. ${treatments.allTreatments[index]['doctor']}"),
              subtitle: Text(
                DateFormat.yMMMMd().format(DateTime.parse(
                        treatments.allTreatments[index]['date_created'])) +
                    "(${treatments.allTreatments[index]['symptoms']})",
              ),
              trailing: treatments.allTreatments[index]['is_treated']
                  ? Card(
                      color: Colors.green,
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          "Completed",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    )
                  : null,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TreatmentPage(
                          treatmentData: treatments.allTreatments[index]))),
            ),
          ));
}
