import 'package:flutter/foundation.dart';

class Treatments extends ChangeNotifier with DiagnosticableTreeMixin {
  List allTreatments = [];
  List activeTreatments = [];

  setAllTreatments(List onGoingTreatmentsList) {
    this.allTreatments = onGoingTreatmentsList;
    notifyListeners();
  }

  setActiveTreatments(List onGoingTreatmentsList) {
    this.activeTreatments = onGoingTreatmentsList;
    notifyListeners();
  }

  deleteTreatment(Map treatment) {
    int index = this.activeTreatments.indexOf(treatment);
    this.activeTreatments.removeAt(index);
    notifyListeners();
  }

  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(IterableProperty('allTreatments', allTreatments));
  }
}
