import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telehealth_client/helpers/AppointmentsHelper.dart';
import 'package:telehealth_client/screens/payments/PaymentInfoScreen.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MakePayment extends StatefulWidget {
  Map token, doctorDetails;
  MakePayment({@required this.token, @required this.doctorDetails});
  @override
  _MakePaymentState createState() =>
      _MakePaymentState(this.token, this.doctorDetails);
}

class _MakePaymentState extends State<MakePayment> {
  Razorpay _razorpay;
  Map token, doctorDetails;
  _MakePaymentState(this.token, this.doctorDetails);

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await AppointmentsHelper().postAppointmentToken(
        token: token,
        onError: (error) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PaymentInfoScreen(isSuccessed: false)));
        },
        onSuccess: (data) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PaymentInfoScreen(isSuccessed: true)));
        });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error occoured during payment. Please try again"),
      backgroundColor: Colors.red,
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("External Wallet error"),
      backgroundColor: Colors.red,
    ));
  }

  void _makePayment(
      int amount, String doctorName, String custContact, custEmail) {
    try {
      _razorpay.open({
        'key': 'rzp_test_DnMK5zSPPsGswb',
        'amount': amount * 100,
        'name': 'TeleHealth Corp.',
        'description': 'Consulatation fees for of Dr. $doctorName',
        'prefill': {'contact': '+91 $custContact', 'email': '$custEmail'},
        'external': {
          'wallets': ['paytm']
        }
      });
    } catch (e) {
      print("*************************************************");
      debugPrint("FLUTTER ERR : " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body: Container(
        margin: EdgeInsets.symmetric(vertical: 26, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment\nOverview",
              style: TextStyle(
                  fontSize: 26,
                  color: Color.fromRGBO(35, 97, 161, 1),
                  fontWeight: FontWeight.bold),
            ),
            Divider(),
            Card(
              child: Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "Doctor Details",
                        style: TextStyle(
                          color: Color.fromRGBO(35, 97, 161, 1),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Name"),
                          Text(
                            "Dr. ${doctorDetails['profile']['name']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Specialization"),
                          Text(
                            "${doctorDetails['specializations']}",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Email"),
                          GestureDetector(
                            onTap: () {
                              try {
                                launch(
                                    "mailto:${doctorDetails['profile']['email']}");
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Unable to send email")));
                              }
                            },
                            child: Text(
                              "${doctorDetails['profile']['email']}",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "Appointment Overview",
                        style: TextStyle(
                          color: Color.fromRGBO(35, 97, 161, 1),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Symptoms"),
                          Text(
                            "${token['symptoms']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Consultation Fee"),
                          Text(
                            "Rs. ${doctorDetails['consultation_fee']}",
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Note"),
                          Text(
                            "${token['note']}",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Date"),
                          Text(
                            "${token['date_expected']}",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Slot"),
                          Text(
                            "${token['slot']}",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Padding(padding: EdgeInsets.zero)),
            Container(
                width: double.infinity,
                child: MaterialButton(
                    elevation: 0,
                    textColor: Colors.white,
                    color: Color.fromRGBO(35, 97, 161, 1),
                    child: Text("Make Payment and book an appointment."),
                    onPressed: () async {
                      SharedPreferences _pref =
                          await SharedPreferences.getInstance();

                      _makePayment(
                          doctorDetails['consultation_fee'],
                          doctorDetails['profile']['name'],
                          _pref.get('phone').toString(),
                          _pref.get('email').toString());
                    }))
          ],
        ),
      )),
    );
  }
}
