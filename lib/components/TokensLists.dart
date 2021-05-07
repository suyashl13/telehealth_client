import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telehealth_client/helpers/TokenHelper.dart';
import 'package:telehealth_client/screens/appointment_token/TokenScreen.dart';

class TokensList extends StatefulWidget {
  @override
  _TokensListState createState() => _TokensListState();
}

class _TokensListState extends State<TokensList>
    with AutomaticKeepAliveClientMixin {
  List activeTokens = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    await TokenHelper().getAppointmentTokens(
        // ignore: missing_return
        (data) {
      setState(() {
        activeTokens = jsonDecode(data);
        isLoading = false;
      });
    },
        // ignore: missing_return
        (error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: activeTokens.length,
            itemBuilder: (context, index) => !activeTokens[index]['is_assigned']
                ? ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TokenScreen(activeTokens[index]),
                        )),
                    title:
                        Text("Dr. " + activeTokens[index]['doctor'].toString()),
                    subtitle: Text("${activeTokens[index]['symptoms']}"),
                    trailing: Card(
                      elevation: 0,
                      color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "See Token",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
