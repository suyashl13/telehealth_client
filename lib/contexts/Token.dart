import 'package:flutter/foundation.dart';

class Token extends ChangeNotifier {
  Map token = {
    'doctor_id': '',
    'symptoms': '',
    'note': '',
    'date_expected': '',
    'slot': '',
  };

  setDoctorId(String doctor_id) {
    this.token['doctor_id'] = doctor_id;
    notifyListeners();
  }

  setSymptoms(String symptoms) {
    this.token['symptoms'] = symptoms;
    notifyListeners();
  }

  setNote(String note) {
    this.token['note'] = note;
    notifyListeners();
  }

  setDateExpected(String date_expected) {
    this.token['date_expected'] = date_expected;
    notifyListeners();
  }

  setSlot(String slot) {
    this.token['slot'] = slot;
    notifyListeners();
  }

  setToken(Map token) {
    this.token = token;
  }

  bool checkToken() {
    if (this.token['doctor_id'] != '' &&
        this.token['date_expected'] != '' &&
        this.token['symptoms'] != '' &&
        this.token['slot'] != '') {
      return true;
    }
    return false;
  }

  clearToken() {
    this.token = token = {
      'doctor_id': '',
      'symptoms': '',
      'note': '',
      'date_expected': '',
      'slot': '',
    };
  }
}
