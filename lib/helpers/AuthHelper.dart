import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telehealth_client/helpers/Env.dart';
import 'package:http/http.dart' as http;
import 'package:telehealth_client/screens/authentication/LoginPage.dart';

class AuthHelper {
  final String baseURL = Env().baseURL;
  SharedPreferences _preferences;

  login(String email, String password) async {
    _preferences = await SharedPreferences.getInstance();

    try {
      await http.post(baseURL + 'users/signin/', body: {
        'email': email,
        'password': password,
      }).then((value) {
        if (value.statusCode != 200) {
          throw jsonDecode(value.body)['ERR'];
        } else {
          if (jsonDecode(value.body)['user']['is_doctor']) {
            throw "Doctor accounts cant use patient app.";
          }
          _preferences.setInt('id', jsonDecode(value.body)['user']['id']);
          _preferences.setString(
              'authtoken', jsonDecode(value.body)['auth_token']);

          _preferences.setString(
              'name', jsonDecode(value.body)['user']['name']);
          _preferences.setString(
              'email', jsonDecode(value.body)['user']['email']);
          _preferences.setString(
              'phone', jsonDecode(value.body)['user']['phone'].toString());
          if (jsonDecode(value.body)['user']['profile_photo'] != null) {
            _preferences.setString('profile_photo',
                jsonDecode(value.body)['user']['profile_photo']);
          } else {
            _preferences.setString('profile_photo',
                "https://cdn1.iconfinder.com/data/icons/user-pictures/101/malecostume-512.png");
          }
        }
      });
    } on SocketException {
      throw "Server Down!";
    }
  }

  Future<bool> _checkAuthentication() async {
    _preferences = await SharedPreferences.getInstance();
    try {
      var res = await http.get(baseURL + 'users/check_auth/', headers: {
        'Uid': _preferences.getInt('id').toString(),
        'Authtoken': _preferences.getString('authtoken')
      }).timeout(Duration(seconds: 20));
      return jsonDecode(res.body)['Auth'];
    } catch (e) {
      throw "Server Down";
    }
  }

  createAccountAtBackend(
      {@required name,
      @required email,
      @required phone,
      // ignore: non_constant_identifier_names
      @required birth_year,
      @required gender,
      @required password,
      // ignore: non_constant_identifier_names
      @required is_doctor}) async {
    Map accountInfo = {
      'name': name,
      'email': email,
      'phone': phone,
      'birth_year': birth_year,
      'gender': gender,
      'password': password,
      'is_doctor': is_doctor
    };

    try {
      await http.post(baseURL + 'users/', body: accountInfo).then((value) {
        if (value.statusCode != 200) {
          throw jsonDecode(value.body)['ERR'];
        } else {
          login(email, password);
        }
      });
    } on SocketException {
      throw "Server Down Error. Please try again later.";
    } catch (e) {
      if (e.toString().split(':')[0] == 'UNIQUE constraint failed') {
        throw "Account already exsists.";
      } else {
        throw e;
      }
    }
  }

  initCheck(
      {@required Function onServerDown,
      @required Function onAuthSuccess,
      @required Function onAuthFailed}) async {
    _preferences = await SharedPreferences.getInstance();
    try {
      if (_preferences.getInt('id') == null) {
        onAuthFailed();
      } else {
        bool result = await _checkAuthentication();
        if (result) {
          onAuthSuccess();
        } else {
          onAuthFailed();
        }
      }
    } catch (e) {
      onServerDown();
    }
  }

  editProfile(Map profileData, Function onSuccess(data),
      Function onError(error)) async {
    _preferences = await SharedPreferences.getInstance();

    var uri =
        Uri.parse(baseURL + 'users/${_preferences.getInt('id').toString()}/');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Uid'] = _preferences.getInt('id').toString();
    request.headers['Authtoken'] = _preferences.getString('authtoken');

    request.fields['name'] = profileData['name'];
    request.fields['email'] = profileData['email'];
    request.fields['phone'] = profileData['phone'].toString();
    request.fields['password'] = profileData['password'] ?? 'null';

    if (profileData['profile_photo'] != null) {
      http.MultipartFile file = await http.MultipartFile.fromPath(
          'profile_photo', profileData['profile_photo']);
      request.files.add(file);
    } else {
      request.fields['profile_photo'] = 'null';
    }

    try {
      var res = await request.send();
      if (res.statusCode != 200) {
        onError("Unable to update. Please try another email or phone.");
      } else {
        onSuccess("Successfully completed request.");
      }
    } catch (e) {
      print(e);
    }

    // await http.MultipartFile.fromPath(

    // try {
    //   await http
    //       .post(baseURL + 'users/${_preferences.getInt('id').toString()}/',
    //           body: jsonEncode({
    //             'name': profileData['name'],
    //             'email': profileData['email'],
    //             'phone': profileData['phone'].toString(),
    //             'password': profileData['password'] ?? 'null',
    //             'profile_photo': profileData['profile_photo'] ?? 'null',
    //           }),
    //           headers: {
    //         'Uid': _preferences.getInt('id').toString(),
    //         'Authtoken': _preferences.getString('authtoken')
    //       }).then((res) {
    //     if (res.statusCode != 200) {
    //       throw jsonDecode(res.body)['ERR'];
    //     } else {
    //       onSuccess(jsonDecode(res.body));
    //     }
    //   });
    // } catch (e) {
    //   print(e.toString());
    //   onError(e.toString());
    // }
  }

  getUser(
      {@required Function onSuccess(data),
      @required Function onError(error)}) async {
    _preferences = await SharedPreferences.getInstance();
    try {
      await http.get(baseURL + 'users/${_preferences.getInt('id').toString()}/',
          headers: {
            'Uid': _preferences.getInt('id').toString(),
            'Authtoken': _preferences.getString('authtoken')
          }).then((res) {
        if (res.statusCode != 200) {
          throw jsonDecode(res.body)['ERR'];
        } else {
          onSuccess(jsonDecode(res.body));
          if (jsonDecode(res.body)['profile_photo'] != null) {
            _preferences.setString(
                'profile_photo', jsonDecode(res.body)['profile_photo']);
          }
        }
      });
    } catch (e) {
      onError(e.toString());
    }
  }

  signOut(BuildContext context) async {
    _preferences = await SharedPreferences.getInstance();
    try {
      await http.get(baseURL + 'users/signout/${_preferences.getInt('id')}/');
    } catch (e) {
      print("Unable to erase server token.");
    }
    _preferences.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginPage()));
  }
}
