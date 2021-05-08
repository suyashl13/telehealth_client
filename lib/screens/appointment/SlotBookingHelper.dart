import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telehealth_client/contexts/Token.dart';

// ignore: must_be_immutable
class SlotBookingHelper extends StatefulWidget {
  Map availablity;

  SlotBookingHelper({this.availablity});

  @override
  _SlotBookingHelperState createState() =>
      _SlotBookingHelperState(this.availablity);
}

enum BestTutorSite { javatpoint, w3schools, tutorialandexample }

class _SlotBookingHelperState extends State<SlotBookingHelper> {
  Map availablity;

  String activeDate = "";
  String activeSlot = "";

  _SlotBookingHelperState(this.availablity);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      activeDate =
          Provider.of<Token>(context, listen: false).token['date_expected'];
      activeSlot = Provider.of<Token>(context, listen: false).token['slot'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Book Your Slot",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(35, 97, 161, 1),
            )),
        Divider(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...availablity.keys.toList().map(
                    (e) => GestureDetector(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                            color: activeDate == e
                                ? Colors.lightGreen[100]
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: activeDate == e
                                  ? Colors.lightGreenAccent[100]
                                  : Colors.blue,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            e,
                            style: TextStyle(
                                fontSize: 14,
                                color: activeDate == e
                                    ? Colors.green
                                    : Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          activeSlot = "";
                          this.activeDate = e;
                          Provider.of<Token>(context, listen: false)
                              .setSlot("");
                          Provider.of<Token>(context, listen: false)
                              .setDateExpected(activeDate);
                        });
                      },
                    ),
                  )
            ],
          ),
        ),
        activeDate == ""
            ? Padding(
                padding: const EdgeInsets.all(28.0),
                child: Center(child: Text("No Date Selected !")),
              )
            : Container(
                child: Column(
                  children: [
                    ...availablity[activeDate].map((slot) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            activeSlot = slot;
                            Provider.of<Token>(context, listen: false)
                                .setSlot(slot);
                            Provider.of<Token>(context, listen: false)
                                .setDateExpected(activeDate);
                          });
                        },
                        title: Text(slot),
                        leading: Radio(
                            value: slot,
                            groupValue: activeSlot,
                            onChanged: (e) {
                              setState(() {
                                activeSlot = e;
                                Provider.of<Token>(context, listen: false)
                                    .setSlot(slot);
                                Provider.of<Token>(context, listen: false)
                                    .setDateExpected(activeDate);
                              });
                            }),
                      );
                    })
                  ],
                ),
              )
      ],
    );
  }
}
