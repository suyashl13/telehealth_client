import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telehealth_client/helpers/Env.dart';
import 'package:http/http.dart' as http;

class TreatmentsHelper {
  String baseURL = Env().baseURL;
  SharedPreferences _preferences;

  getAllTreatments(
      {@required Function onSuccess(data),
      @required Function onError(error)}) async {
    _preferences = await SharedPreferences.getInstance();

    try {
      await http.get(baseURL + 'treatments/', headers: {
        'Uid': _preferences.get('id').toString(),
        'Authtoken': _preferences.getString('authtoken')
      }).then((value) {
        if (value.statusCode != 200) {
          throw jsonDecode(value.body)['ERR'];
        } else {
          onSuccess(value.body);
        }
      });
    } on SocketException {
      onError("Server down error.");
    } catch (e) {
      onError(e.toString());
    }
  }

  completeTreatment(int treatmentId) async {
    _preferences = await SharedPreferences.getInstance();
    try {
      await http.post(baseURL + 'treatments/${treatmentId.toString()}/', body: {
        'is_completed': 'true'
      }, headers: {
        'Uid': _preferences.getInt('id').toString(),
        'Authtoken': _preferences.getString('authtoken')
      }).then((value) {
        if (value.statusCode != 200) {
          throw jsonDecode(value.body)['ERR'];
        } else {
          print("Treatment completed / ID : " + treatmentId.toString());
        }
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
