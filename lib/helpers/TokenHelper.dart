import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:telehealth_client/helpers/Env.dart';

class TokenHelper {
  SharedPreferences _preferences;
  final String baseURL = Env().baseURL;

  getAppointmentTokens(Function onSuccess(data), Function onError(data)) async {
    _preferences = await SharedPreferences.getInstance();
    try {
      await http.get(baseURL + 'appointments/appt_token/', headers: {
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
      onError("Server down Error.");
    } catch (e) {
      onError(e.toString());
    }
  }
}
