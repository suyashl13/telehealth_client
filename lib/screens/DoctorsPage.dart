import 'package:flutter/material.dart';
import 'package:telehealth_client/screens/doctor/DoctorsList.dart';

class DoctorsPage extends StatefulWidget {
  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List<String> categories = [
    'FAMILY PHYSICIAN',
    'PODIATRIST',
    'SPORTS MEDICINE PHYSICIAN',
    'RADIOLOGIST',
    'PREVENTIVE MEDICINE PHYSICIAN',
    'PHYSICAL MEDICINE AND REHABILITATION PHYSICIAN',
    'DERMATOLOGIST',
    'NUCLEAR MEDICINE PHYSICIAN',
    'OPHTHALMOLOGIST',
    'HOSPITALIST',
    'ALLERGISTS AND IMMUNOLOGIST',
    'NEUROLOGIST',
    'PATHOLOGIST',
    'ANESTHESIOLOGIST',
    'SURGEON',
    'OBSTETRICIANS AND GYNECOLOGIST',
    'PSYCHIATRIST',
    'PEDIATRICIAN',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color.fromRGBO(35, 97, 161, 1),
        elevation: 0,
        title: Center(
          child: Text(
            "Doctor Categories",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 8, left: 12, right: 12),
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              ...categories
                  .map((e) => Card(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DoctorList(queryString: e),
                              )),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(
                                  height: 124,
                                  image: AssetImage('assets/physician.png'),
                                ),
                                Text(
                                  "$e",
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
