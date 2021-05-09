import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
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
                          "Hi,\n${_preferences.get('name')}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(35, 97, 161, 1),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image(
                            fit: BoxFit.fill,
                            height: 48,
                            width: 48,
                            image: NetworkImage(
                                _preferences.getString('profile_photo')),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Divider(),
                    Text(
                      "Ongoing Treatments",
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
