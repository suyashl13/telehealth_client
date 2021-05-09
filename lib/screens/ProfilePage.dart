import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telehealth_client/helpers/AuthHelper.dart';
import 'package:telehealth_client/helpers/Dialoghelper.dart';
import 'package:telehealth_client/screens/settings/EditProfile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences _preferences;
  bool isLoading = true;
  Map userDetails;

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    String formattedDate = formatter.format(now);
    int yearNow = int.parse(formattedDate);
    _preferences = await SharedPreferences.getInstance();
    await AuthHelper().getUser(
        // ignore: missing_return
        onSuccess: (data) {
      setState(() {
        userDetails = data;
        userDetails['age'] = yearNow - userDetails['birth_year'];
      });
    },
        // ignore: missing_return
        onError: (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(225),
                  child: Image(
                    fit: BoxFit.fill,
                    height: 136,
                    width: 136,
                    image: userDetails['profile_photo'] != null
                        ? NetworkImage(userDetails['profile_photo'])
                        : NetworkImage(_preferences.getString('profile_photo')),
                  ),
                ),
                Center(
                  child: Text(
                    "${userDetails['name']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.cake),
                      title: Text("${userDetails['age']} Y/o"),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text("+91 ${userDetails['phone']}"),
                    ),
                    ListTile(
                      leading: Icon(Icons.email_outlined),
                      title: Text("${userDetails['email']}"),
                    ),
                    ListTile(
                      leading: Icon(Icons.person_outlined),
                      title: Text("${userDetails['gender']}"),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: double.maxFinite,
                        child: Center(
                          child: MaterialButton(
                            elevation: 0,
                            color: Color.fromRGBO(35, 97, 161, 1),
                            onPressed: () async {
                              await AuthHelper().signOut(context);
                            },
                            textColor: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.logout), Text("  Logout")],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: double.maxFinite,
                        child: Center(
                          child: MaterialButton(
                            elevation: 0,
                            color: Color.fromRGBO(35, 97, 161, 1),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditProfile(
                                  userDetails: userDetails,
                                ),
                              ));
                            },
                            textColor: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit),
                                Text("  Edit Profile")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
