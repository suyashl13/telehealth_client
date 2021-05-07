import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:telehealth_client/screens/appointment/NewAppointmentScreen.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DoctorProfile extends StatefulWidget {
  Map doctorDetails;
  DoctorProfile({@required this.doctorDetails});
  @override
  _DoctorProfileState createState() =>
      _DoctorProfileState(doctorDetails: this.doctorDetails);
}

class _DoctorProfileState extends State<DoctorProfile> {
  Map doctorDetails;
  _DoctorProfileState({@required this.doctorDetails});

  @override
  Widget build(BuildContext context) {
    final backgroundCover = ClipPath(
      clipper: DiagonalPathClipperTwo(),
      child: Container(
          height: 185,
          width: MediaQuery.of(context).size.width,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.grey[350], BlendMode.modulate),
            child: Image(
                filterQuality: FilterQuality.medium,
                fit: BoxFit.cover,
                image: AssetImage('assets/cover_photo.jpg')),
          )),
    );

    _launchURL(String url) async {
      try {
        await launch(url);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: e));
      }
    }

    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backgroundCover,
              Container(
                padding: EdgeInsets.only(top: 16),
                margin: EdgeInsets.symmetric(horizontal: 18),
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("${doctorDetails['bio']}"),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.school,
                              color: Colors.black45,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text("Certificate",
                                  style: TextStyle(color: Colors.black45)),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL("${doctorDetails['certificate']}");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text("See Certificate",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(35, 97, 161, 1))),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              color: Colors.black45,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text("Consultancy Fee",
                                  style: TextStyle(color: Colors.black45)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                              "Rs. ${doctorDetails['consultation_fee']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(35, 97, 161, 1))),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.black45,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text("Available Time",
                                  style: TextStyle(color: Colors.black45)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                              "${DateFormat.jm().format(DateTime.parse('2020-01-02 ' + doctorDetails['open_time'].toString().split(' - ')[0]))} - " +
                                  "${DateFormat.jm().format(DateTime.parse('2020-01-02 ' + doctorDetails['open_time'].toString().split(' - ')[1]))}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(35, 97, 161, 1))),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 3.45),
              Center(
                  child: SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: MaterialButton(
                      elevation: 0,
                      textColor: Colors.white,
                      child: Text("Book an Appointment"),
                      color: Color.fromRGBO(35, 97, 161, 1),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NewAppointmentScreen(
                            doctorDetails: doctorDetails,
                          ),
                        ));
                      }),
                ),
              ))
            ],
          ),
          Positioned(
            top: 110,
            right: 32,
            bottom: 500,
            child: Container(
              height: 104,
              width: 120,
              child: doctorDetails['profile']['profile_photo'] == null
                  ? Image.asset(
                      "assets/doctor.png",
                    )
                  : Image.network(
                      doctorDetails['profile']['profile_photo'],
                      fit: BoxFit.fill,
                    ),
            ),
          )
        ],
      ),
    ));
  }
}
