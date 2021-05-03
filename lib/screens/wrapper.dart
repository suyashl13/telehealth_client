import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telehealth_client/components/IndicateServerDown.dart';
import 'package:telehealth_client/helpers/AuthHelper.dart';
import 'package:telehealth_client/screens/HistoryPage.dart';
import 'package:telehealth_client/screens/HomePage.dart';
import 'package:telehealth_client/screens/ProfilePage.dart';
import 'package:telehealth_client/screens/SearchPage.dart';
import 'package:telehealth_client/screens/authentication/LoginPage.dart';

// ignore: camel_case_types
class wrapper extends StatefulWidget {
  @override
  _wrapperState createState() => _wrapperState();
}

// ignore: camel_case_types
class _wrapperState extends State<wrapper>
    with AutomaticKeepAliveClientMixin<wrapper> {
  SharedPreferences _preferences;
  bool isLoading = true;
  int _activePage = 0;

  final List kPages = [
    HomePage(),
    SearchPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  _setPage() async {
    _preferences = await SharedPreferences.getInstance();
    await AuthHelper().initCheck(onServerDown: () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => IndicateServerDown()));
    }, onAuthSuccess: () {
      setState(() {
        isLoading = false;
      });
    }, onAuthFailed: () {
      _preferences.clear();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : kPages[_activePage],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color.fromRGBO(35, 97, 161, 1),
          type: BottomNavigationBarType.fixed,
          onTap: (i) {
            setState(() {
              _activePage = i;
            });
          },
          currentIndex: _activePage,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), title: Text("Search")),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), title: Text("History")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Profile")),
          ]),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
