import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telehealth_client/helpers/Env.dart';

class AppointmentsHelper {
  SharedPreferences _preferences;
  final String baseURL = Env().baseURL;

  getAllAppointments(Function onSuccess(data), Function onError(error)) async {
    _preferences = await SharedPreferences.getInstance();
    try {
      await http.get(baseURL + 'appointments/', headers: {
        'Uid': _preferences.getInt('id').toString(),
        'Authtoken': _preferences.getString('authtoken')
      }).then((value) {
        if (value.statusCode != 200) {
          throw jsonDecode(value.body)['ERR'];
        } else {
          onSuccess(value.body);
        }
      });
    } on SocketException {
      onError("Server down");
    } catch (e) {
      onError(e);
    }
  }
}
