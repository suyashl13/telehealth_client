import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telehealth_client/helpers/Env.dart';
import 'package:http/http.dart' as http;

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
      });
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
}
