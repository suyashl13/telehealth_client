import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telehealth_client/contexts/Treatments.dart';
import 'package:telehealth_client/helpers/TreatmentsHelper.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class TreatmentPage extends StatefulWidget {
  Map treatmentData;
  TreatmentPage({@required this.treatmentData});
  @override
  _TreatmentPageState createState() =>
      _TreatmentPageState(treatmentData: treatmentData);
}

class _TreatmentPageState extends State<TreatmentPage> {
  Map treatmentData;
  _TreatmentPageState({@required this.treatmentData});
  List medicines = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      medicines = treatmentData['medecines'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr. " + treatmentData['doctor'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color.fromRGBO(35, 97, 161, 1),
                        ),
                      ),
                      Text(
                        treatmentData['doctor_specialization'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(35, 97, 161, 1),
                        ),
                      ),
                      SizedBox(
                        width: 148,
                        child: Text(
                          treatmentData['symptoms'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  !treatmentData['is_treated']
                      ? MaterialButton(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(
                                color: Color.fromRGBO(35, 97, 161, 1),
                              )),
                          textColor: Color.fromRGBO(35, 97, 161, 1),
                          onPressed: () async {
                            final String doctorPhone =
                                treatmentData['doctor_phone'].toString();
                            final String phoneSms = 'sms:+91$doctorPhone';
                            final String phone = 'tel:+91$doctorPhone';
                            final String wAPhone =
                                "whatsapp://send?phone=$phone";
                            try {
                              await launch(wAPhone);
                            } catch (e) {
                              try {
                                await launch(phoneSms);
                              } catch (e) {
                                print("Unable to launch url.");
                              }
                              print("Unable to launch url.");
                            }
                          },
                          child: Text("Chat Live"),
                        )
                      : Padding(padding: EdgeInsets.zero)
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Medicines",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color.fromRGBO(35, 97, 161, 1),
                ),
              ),
              Divider(),
              Expanded(
                child: ListView(
                  children: [
                    ...medicines
                        .map((med) => Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(
                                  med['medicine'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(35, 97, 161, 1)),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${med['intake_quantity']}'),
                                    Text('${med['note']}'),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      '${med['duration']} Days',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                trailing: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        "${DateFormat.jm().format(DateTime.parse('2020-01-02 ' + med['intake_time_1']))}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue),
                                      ),
                                      Text(
                                        "${DateFormat.jm().format(DateTime.parse('2020-01-02 ' + med['intake_time_2']))}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue),
                                      ),
                                      Text(
                                        "${DateFormat.jm().format(DateTime.parse('2020-01-02 ' + med['intake_time_3']))}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue),
                                      ),
                                      med['intake_time_4'] == null
                                          ? Padding(padding: EdgeInsets.zero)
                                          : Text(
                                              "${DateFormat.jm().format(DateTime.parse('2020-01-02 ' + med['intake_time_4']))}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blue),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList()
                  ],
                ),
              ),
              treatmentData['precautions'] == null
                  ? Padding(padding: EdgeInsets.zero)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Precautions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color.fromRGBO(35, 97, 161, 1),
                          ),
                        ),
                        Divider(),
                        Text(treatmentData['precautions'])
                      ],
                    ),
              SizedBox(
                height: 40,
              ),
              !treatmentData['is_treated']
                  ? Center(
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        textColor: Colors.blue,
                        color: Colors.transparent,
                        onPressed: () async {
                          try {
                            await TreatmentsHelper()
                                .completeTreatment(treatmentData['id']);
                            return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Consulted."),
                                content:
                                    Text("Thank-you for consulting at us."),
                                actions: [
                                  MaterialButton(
                                      textColor: Colors.blue,
                                      child: Text("Done"),
                                      onPressed: () {
                                        Provider.of<Treatments>(context,
                                                listen: false)
                                            .deleteTreatment(treatmentData);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            );
                          } catch (e) {
                            return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Error!"),
                                content: Text(
                                    "Unable to mark treatment as complete."),
                                actions: [
                                  MaterialButton(
                                      textColor: Colors.red,
                                      child: Text("Okay"),
                                      onPressed: () => Navigator.pop(context))
                                ],
                              ),
                            );
                          }
                        },
                        child: Text("Mark Treatment as Completed"),
                      ),
                    )
                  : Padding(padding: EdgeInsets.zero)
            ],
          ),
        ),
      ),
    );
  }
}
