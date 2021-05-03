import 'package:flutter/material.dart';
import 'package:telehealth_client/components/HomeTreatments.dart';
import 'package:telehealth_client/components/Overview.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HomePage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Take care of\nyour health.",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(35, 97, 161, 1),
                    ),
                  ),
                  Card(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(padding: EdgeInsets.all(26)),
                  ),
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      height: 38,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Search', border: InputBorder.none),
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.search), onPressed: () {}),
                ],
              ),
              Divider(),
              Text(
                "Treatments",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(35, 97, 161, 1),
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 184,
                child: HomeTreatments(),
              ),
              Expanded(child: Overview())
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
