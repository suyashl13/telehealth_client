import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:telehealth_client/components/AppointmentsList.dart';
import 'package:telehealth_client/components/Overview.dart';
import 'package:telehealth_client/contexts/Appointments.dart';
import 'package:telehealth_client/contexts/Token.dart';
import 'package:telehealth_client/contexts/Treatments.dart';
import 'package:telehealth_client/screens/appointment/NewAppointmentScreen.dart';
import 'package:telehealth_client/screens/appointment/SlotBookingHelper.dart';
import 'package:telehealth_client/screens/history_page/AllAppointments.dart';
import 'package:telehealth_client/screens/payments/PaymentInfoScreen.dart';
import 'package:telehealth_client/screens/treatments/TreatmentPage.dart';
import 'package:telehealth_client/screens/wrapper.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => Treatments(),
      ),
      ChangeNotifierProvider(
        create: (_) => Appointments(),
      ),
      ChangeNotifierProvider(
        create: (_) => Token(),
      ),
      // Providers
      Provider(create: (_) => AppointmentList()),
      Provider(create: (_) => Overview()),
      Provider(create: (_) => TreatmentPage(treatmentData: {})),
      Provider(create: (_) => AllAppointments()),
      Provider(create: (_) => SlotBookingHelper()),
      Provider(create: (_) => NewAppointmentScreen(doctorDetails: {})),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'TeleHealth Client.',
      theme: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(child: wrapper()),
    );
  }
}
