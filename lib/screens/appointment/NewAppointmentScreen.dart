import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telehealth_client/contexts/Token.dart';
import 'package:telehealth_client/helpers/AppointmentsHelper.dart';
import 'package:telehealth_client/screens/appointment/SlotBookingHelper.dart';
import 'package:telehealth_client/screens/payments/MakePayment.dart';

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
  bool isLoading = true;
  Map availablity = {};
  String symptoms, notes = "";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _setPage() async {
    await AppointmentsHelper().checkDoctorAvailablity(doctorDetails['id'],
        (data) {
      Provider.of<Token>(context, listen: false)
          .setDoctorId(doctorDetails['id'].toString());
      setState(() {
        availablity = data;
        isLoading = false;
      });
    }, (error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _NewAppointmentScreenState({@required this.doctorDetails});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 26, vertical: 28),
        child: Form(
          key: _formKey,
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
              Text(
                  "${doctorDetails['specializations']}\nFees : Rs. ${doctorDetails['consultation_fee']}",
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
              SizedBox(
                width: 160,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("${doctorDetails['bio']}"),
                ),
              ),
              Divider(),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4)),
                  child: TextFormField(
                    maxLines: 3,
                    // ignore: missing_return
                    validator: (e) {
                      if (e.length < 6) {
                        return "This field cannot be smaller than 6 chars.";
                      }
                    },
                    onSaved: (e) {
                      symptoms = e;
                      // Provider.of<Token>(context, listen: false).setSymptoms(e);
                    },
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 14),
                        hintText: 'Describe your symptoms.',
                        border: InputBorder.none),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 14),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4)),
                  child: TextFormField(
                    onChanged: (e) {
                      notes = e;
                      //Provider.of<Token>(context, listen: false).setNote(e);
                    },
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 14),
                        hintText: 'Note',
                        border: InputBorder.none),
                  )),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: SlotBookingHelper(availablity: availablity)),
              Center(
                child: Container(
                  width: double.infinity,
                  child: MaterialButton(
                      elevation: 0,
                      textColor: Colors.white,
                      color: Color.fromRGBO(35, 97, 161, 1),
                      child: Text("Book an appointment"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Provider.of<Token>(context, listen: false)
                              .setSymptoms(symptoms);
                          Provider.of<Token>(context, listen: false)
                              .setNote(notes);

                          if (!Provider.of<Token>(context, listen: false)
                              .checkToken()) {
                            return ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("Please fil all required fields."),
                              backgroundColor: Colors.red,
                              duration: Duration(milliseconds: 1000),
                            ));
                          }
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MakePayment(
                                token:
                                    Provider.of<Token>(context, listen: false)
                                        .token,
                                doctorDetails: doctorDetails),
                          ));
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
