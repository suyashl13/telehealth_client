import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telehealth_client/helpers/AuthHelper.dart';
import 'package:telehealth_client/screens/authentication/LoginPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences _preferences;
  bool isLoading = true;

  _setPage() async {
    _preferences = await SharedPreferences.getInstance();
    await AuthHelper().initCheck(
        onServerDown: () {},
        onAuthSuccess: () {
          setState(() {
            isLoading = false;
          });
        },
        onAuthFailed: () {
          _preferences.clear();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
  }

  @override
  void initState() {
    super.initState();
    print("Called");
    _setPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Text("Home"),
              ),
      ),
    );
  }
}
