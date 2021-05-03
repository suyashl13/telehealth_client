import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Appointments extends ChangeNotifier {
  List allAppointments = [];
  List activeAppointments = [];

  setallAppointments(List appointmentsList) {
    this.activeAppointments = [];
    this.allAppointments = [];
    this.allAppointments = appointmentsList;
    setActiveAppointments();
    notifyListeners();
  }

  setActiveAppointments() {
    for (var item in allAppointments) {
      if (!item['is_treated']) {
        activeAppointments.add(item);
      }
    }
  }
}
