import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:telehealth_client/helpers/Env.dart';
import 'package:http/http.dart' as http;

class DoctorHelper {
  String baseURL = Env().baseURL;

  Future searchDoctor(
      {@required String query,
      @required Function onSuccess(data),
      @required Function onError(error)}) async {
    try {
      await http
          .get(
        baseURL + 'users/doctor/$query/',
      )
          .then((value) {
        if (value.statusCode != 200) {
          throw jsonDecode(value.body)['ERR'];
        } else {
          onSuccess(jsonDecode(value.body));
        }
      });
    } catch (e) {
      onError(e.toString());
    }
  }
}
