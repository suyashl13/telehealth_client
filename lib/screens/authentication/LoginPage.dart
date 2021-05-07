import 'package:flutter/material.dart';
import 'package:telehealth_client/helpers/AuthHelper.dart';
import 'package:telehealth_client/screens/authentication/CreateAccountPage.dart';
import 'package:telehealth_client/screens/wrapper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                color: Color.fromRGBO(35, 97, 161, 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                        child: Text(
                      "TELEHEALTH",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )),
                    SizedBox()
                  ],
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.2,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ]),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(),
                        Text(
                          "Login".toUpperCase(),
                          style: TextStyle(
                              color: Color.fromRGBO(51, 152, 255, 1),
                              fontSize: 22),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(6)),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: TextFormField(
                                    onChanged: (e) {
                                      setState(() {
                                        email = e;
                                      });
                                    },
                                    // ignore: missing_return
                                    validator: (e) {
                                      if (!e.contains("@")) {
                                        return "Enter a valid email.";
                                      }
                                      if (!e.contains(".")) {
                                        return "Enter a valid email.";
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Email',
                                        hintStyle: TextStyle(fontSize: 14),
                                        border: InputBorder.none),
                                  )),
                              Container(
                                  height: 50,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(6)),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: TextFormField(
                                    onChanged: (e) {
                                      setState(() {
                                        password = e;
                                      });
                                    },
                                    // ignore: missing_return
                                    validator: (e) {
                                      if (e.length < 6) {
                                        return "Password too short.";
                                      }
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle: TextStyle(fontSize: 14),
                                        border: InputBorder.none),
                                  )),
                            ],
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              try {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                                await AuthHelper().login(email, password);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => wrapper(),
                                    ));
                                setState(() {
                                  isLoading = !isLoading;
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(e),
                                  backgroundColor: Colors.red,
                                  duration: Duration(milliseconds: 1000),
                                ));
                                setState(() {
                                  isLoading = !isLoading;
                                });
                              }
                            }
                          },
                          color: Color.fromRGBO(35, 97, 161, 1),
                          textColor: Colors.white,
                          child: isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                      strokeWidth: 5.0),
                                )
                              : Text("Login"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 56),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAccountPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Create an account.",
                    style: TextStyle(color: Color.fromRGBO(51, 152, 255, 1)),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
