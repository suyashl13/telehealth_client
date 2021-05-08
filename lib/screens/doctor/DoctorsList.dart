import 'package:flutter/material.dart';
import 'package:telehealth_client/helpers/DoctorHelper.dart';
import 'package:telehealth_client/screens/doctor/DoctorProfile.dart';

// ignore: must_be_immutable
class DoctorList extends StatefulWidget {
  String queryString;

  DoctorList({@required this.queryString});
  @override
  _DoctorListState createState() => _DoctorListState(queryString: queryString);
}

class _DoctorListState extends State<DoctorList> {
  String queryString;
  List doctors = [];
  bool isLoading = true;

  _DoctorListState({@required this.queryString});

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    await DoctorHelper().searchDoctor(
        query: queryString,
        // ignore: missing_return
        onSuccess: (data) {
          setState(() {
            doctors = data;
            isLoading = false;
          });
        },
        // ignore: missing_return
        onError: (error) {
          print("ERR " + error);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 50,
              backgroundColor: Color.fromRGBO(35, 97, 161, 1),
              title: Text(queryString + "S", style: TextStyle(fontSize: 14)),
            ),
            body: Container(
              margin: EdgeInsets.only(top: 4),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) => ListTile(
                            leading: Card(
                              elevation: 0.2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(124)),
                              child: Container(
                                child: Image(
                                  fit: BoxFit.fill,
                                  image: doctors[index]['profile']
                                              ['profile_photo'] ==
                                          null
                                      ? AssetImage('assets/doctor.png')
                                      : NetworkImage(
                                          doctors[index]['profile']
                                              ['profile_photo'],
                                        ),
                                ),
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorProfile(
                                    doctorDetails: doctors[index],
                                  ),
                                )),
                            title: Text(
                                "Dr. ${doctors[index]['profile']['name']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            subtitle: Text(
                                "Consultation Fee : Rs.${doctors[index]['consultation_fee']}"),
                          )),
            )));
  }
}
