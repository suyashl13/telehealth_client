import 'package:flutter/material.dart';
import 'package:telehealth_client/helpers/AuthHelper.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String name, email, phone, birth_year, password, confirm_password = '';
  String gender = 'Male';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 97, 161, 1),
      body: Container(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(),
                    Column(
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          "TeleHealth".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Create an account".toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextFormField(
                                // ignore: missing_return
                                validator: (val) {
                                  if (val.split(' ').length > 2) {
                                    return "Cannot contain more than 2 empty spaces.";
                                  }
                                  if (val.length < 5) {
                                    return "Must contain atleas 5 characters";
                                  }
                                },
                                onChanged: (e) {
                                  setState(() {
                                    name = e;
                                  });
                                },
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 14),
                                    hintText: 'Full Name',
                                    border: InputBorder.none),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextFormField(
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
                                onChanged: (e) {
                                  setState(() {
                                    email = e;
                                  });
                                },
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 14),
                                    hintText: 'Email',
                                    border: InputBorder.none),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextFormField(
                                // ignore: missing_return
                                validator: (val) {
                                  if (val.length != 10) {
                                    return "Please provide valid phone number.";
                                  }
                                },
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                onChanged: (e) {
                                  setState(() {
                                    phone = e;
                                  });
                                },
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 14),
                                    hintText: 'Phone',
                                    border: InputBorder.none),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextFormField(
                                // ignore: missing_return
                                validator: (val) {
                                  if (val.length != 4) {
                                    return "Must contain 4 characters";
                                  }
                                  if (val[0] != '1' && val[0] != '2') {
                                    return "Enter valid year of birth";
                                  }
                                },
                                maxLength: 4,
                                onChanged: (e) {
                                  setState(() {
                                    birth_year = e;
                                  });
                                },
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 14),
                                    hintText: 'Birth Year',
                                    border: InputBorder.none),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextFormField(
                                // ignore: missing_return
                                validator: (val) {
                                  if (val.length < 6) {
                                    return "Must contain more than 6 characters";
                                  }
                                },
                                onChanged: (e) {
                                  setState(() {
                                    password = e;
                                  });
                                },
                                obscureText: true,
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 14),
                                    hintText: 'Password',
                                    border: InputBorder.none),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  if (val != password) {
                                    return "Passwords donot match";
                                  }
                                },
                                onChanged: (e) {
                                  setState(() {
                                    confirm_password = e;
                                  });
                                },
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 14),
                                    hintText: 'Confirm Password',
                                    border: InputBorder.none),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: DropdownButtonFormField<String>(
                              items: <String>["Male", "Female", "Other"]
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  gender = val;
                                });
                              },
                              value: gender,
                              hint: Text("Select"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          try {
                            await AuthHelper().createAccountAtBackend(
                                name: name,
                                email: email,
                                phone: phone,
                                birth_year: '$birth_year-06-13',
                                gender: gender,
                                password: password,
                                is_doctor: 'false');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      },
                      color: Colors.white,
                      textColor: Color.fromRGBO(35, 97, 161, 1),
                      child: Text("Create Account"),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
