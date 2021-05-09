import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telehealth_client/helpers/AuthHelper.dart';
import 'package:telehealth_client/helpers/Dialoghelper.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  Map userDetails;
  EditProfile({@required this.userDetails});
  @override
  _EditProfileState createState() => _EditProfileState(userDetails);
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map userDetails;
  _EditProfileState(this.userDetails);

  SharedPreferences _preferences;
  TextEditingController _phoneController, _emailController;
  var file;

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    _preferences = await SharedPreferences.getInstance();

    _phoneController = TextEditingController();
    _emailController = TextEditingController();

    _setControllers();

    setState(() {
      isLoading = false;
    });
  }

  _setControllers() async {
    _phoneController.text = userDetails['phone'].toString();
    _emailController.text = userDetails['email'];
  }

  _uploadImage() async {
    try {
      var tfile = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        userDetails['profile_photo'] = tfile.path;
        file = tfile;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No image selected."), backgroundColor: Colors.red));
    }
  }

  _removeImage() async {
    setState(() {
      file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 36,
                        ),
                        GestureDetector(
                          onTap: () {
                            _uploadImage();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image(
                              fit: BoxFit.fill,
                              height: 136,
                              width: 136,
                              image: file != null
                                  ? FileImage(file)
                                  : NetworkImage(
                                      _preferences.getString('profile_photo')),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _uploadImage();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.edit),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _removeImage();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.remove_circle_outline),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ListTile(
                                leading: Icon(Icons.person),
                                title: Text("${userDetails['name']}")),
                            ListTile(
                              leading: Icon(Icons.calendar_today_outlined),
                              title: Text("${userDetails['birth_year']}"),
                            ),
                            ListTile(
                              leading: Icon(Icons.phone),
                              title: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextFormField(
                                    controller: _phoneController,
                                    // ignore: missing_return
                                    validator: (val) {
                                      if (val.length != 10) {
                                        return "Please provide valid phone number.";
                                      }
                                    },
                                    maxLength: 10,
                                    keyboardType: TextInputType.phone,
                                    onSaved: (e) {
                                      userDetails['phone'] = e;
                                    },
                                    style: TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 14),
                                        hintText: 'Phone',
                                        border: InputBorder.none),
                                  )),
                            ),
                            ListTile(
                              leading: Icon(Icons.email_outlined),
                              title: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextFormField(
                                    controller: _emailController,
                                    // ignore: missing_return
                                    validator: (val) {
                                      if (!val.contains('@') ||
                                          !val.contains('.')) {
                                        return "Please provide a vali email.";
                                      }
                                      if (val.length < 5) {
                                        return "Must contain atleas 5 characters";
                                      }
                                    },
                                    onSaved: (e) {
                                      setState(() {
                                        userDetails['email'] = e;
                                      });
                                    },
                                    style: TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 14),
                                        hintText: 'Email',
                                        border: InputBorder.none),
                                  )),
                            ),
                            ListTile(
                              leading: Icon(Icons.lock),
                              title: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextFormField(
                                    // ignore: missing_return
                                    // validator: (val) {
                                    //   if (val.length < 6) {
                                    //     return "Must contain atleas 6 characters";
                                    //   }
                                    // },
                                    obscureText: true,
                                    onSaved: (e) {
                                      setState(() {
                                        userDetails['password'] = e;
                                      });
                                    },
                                    style: TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 14),
                                        hintText: 'New Password',
                                        border: InputBorder.none),
                                  )),
                            ),
                            ListTile(
                              leading: Icon(Icons.person_outlined),
                              title: Text("${userDetails['gender']}"),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: double.maxFinite,
                              child: Center(
                                child: MaterialButton(
                                  elevation: 0,
                                  color: Color.fromRGBO(35, 97, 161, 1),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      if (userDetails['password'] == '') {
                                        userDetails['password'] = null;
                                      }
                                      await AuthHelper()
                                          .editProfile(userDetails,
                                              // ignore: missing_return
                                              (data) {
                                        DialogHelper().showSuccessMessage(
                                            context,
                                            "Successfully edited your account details.");
                                      },
                                              // ignore: missing_return
                                              (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text(error.toString())));
                                      });
                                    }
                                  },
                                  textColor: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.done),
                                      Text("  Done   ")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: double.maxFinite,
                              child: Center(
                                child: MaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  textColor: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.logout),
                                      Text("  Exit")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
