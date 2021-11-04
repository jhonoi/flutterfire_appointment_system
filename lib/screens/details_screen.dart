import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:web_app_firebase/appointment.dart';
import 'package:web_app_firebase/breakpoints.dart';
import 'package:web_app_firebase/widgets/appbar.dart';
import 'package:web_app_firebase/widgets/calendar.dart';
import 'package:web_app_firebase/widgets/max_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:web_app_firebase/widgets/option_box_group.dart';

class DetailsScreen extends StatelessWidget {
  final String id;
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference workDays =
      FirebaseFirestore.instance.collection('work_days');
  final FirebaseAuth auth = FirebaseAuth.instance;
  Appointment appointment = Appointment();

  DetailsScreen({@required this.id});

  final scrollController = ScrollController();

  void scrollToBottom() {
    //Scroll to the bottom of the listview when appointment times are loaded
    Timer(Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 100),
      );
    });
  }

  void bookApp(BuildContext context) async {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (appointment.time == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please Select a Time for Your Appointment.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[400],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      );

      if (currentUser == null) {
        kIsWeb ? Navigator.pop(context) : null;
        Navigator.of(context)
            .pushReplacementNamed('/login', arguments: appointment);
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get()
            .then((value) {
          if (value.exists) {
            Map<String, dynamic> username =
                value.data() as Map<String, dynamic>;
            appointment.clientName = username['username'];
            appointment.clientID = currentUser.uid;

            FirebaseFirestore.instance
                .collection('appointments')
                .add(appointment.toMap());
            kIsWeb ? Navigator.pop(context) : null;
            Navigator.of(context).pushReplacementNamed(
              '/appointments',
            );
          }
        });
      }
    }
  }

  Future<List> getWorkingDaysInfo() async {
    //This is the parent collection
    final QuerySnapshot wDaysLevel1 = await workDays.get();

    Future<QuerySnapshot> getIt(var item) async {
      return await item.get();
    }

    List list = [
      ...wDaysLevel1.docs.map((dayDoc) {
        return workDays.doc(dayDoc.id).collection("timeslots");
      })
    ];

    List<Future<QuerySnapshot>> list2 = [
      ...list.map((element) async {
        QuerySnapshot test = await getIt(element);
        return test;
      })
    ];

    List<QuerySnapshot> list3 = await Future.wait(list2);
    List list4 = [
      ...list3.map((e) => [...e.docs.map((ev) => ev['timeslot'])])
    ];

    List finalfinal = [];
    for (int i = 0; i < wDaysLevel1.docs.length; i++) {
      Map dateMap = {
        'date': wDaysLevel1.docs[i].data() as Map<String, dynamic>,
      };

      dateMap['date'] = dateMap['date']['date'];

      list4[i].sort((a, b) =>
          int.parse(a.split(':')[0]).compareTo(int.parse(b.split(':')[0])));

      dateMap['timeslots'] = list4[i];

      finalfinal.add(dateMap);
    }

    return finalfinal;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<DocumentSnapshot>(
      future: products.doc(this.id).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          String duration =
              (snapshot.data['duration'] / 60).floor().toString() + ' Hours ';
          String minsDuration = snapshot.data['duration'] % 60 != 0
              ? (snapshot.data['duration'] % 60).toString() + ' Mins'
              : '';
          appointment.productName = snapshot.data['name'];
          appointment.productID = snapshot.data.id;
          appointment.price = snapshot.data['price'];
          appointment.duration = snapshot.data['duration'];
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: myAppBar(
                title: snapshot.data[
                    "short_name"], //When using adaptive widget you can always use the long name on desktop
                context: context,
                useTabBar: false),
            body: Stack(
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  return MaxContainer(
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.all(20.0),
                      scrollDirection: Axis.vertical,
                      children: [
                        screenWidth >= kTabletBreakpoint
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.blue,
                                            ),
                                            child: Image.asset(
                                              'images/${snapshot.data['imgUrl']}.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                snapshot.data['name'],
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(top: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2.0),
                                                    child: Text(
                                                      '• Product Info Here',
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2.0),
                                                    child: Text(
                                                      '• Product Info Here, more info. Details etc...',
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2.0),
                                                    child: Text(
                                                      '• Additional details, policies, requirements etc.',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              child: Divider(
                                                thickness: 0.8,
                                                color: Color(0xFFDCDCDC),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                'Additions',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            OptionBoxGroup(
                                              usesTime: false,
                                              additions: [
                                                'Add Curls (Goddess Faux Locs)',
                                                'Detangling, Blow Drying, and Sectioning'
                                              ],
                                              appointment: appointment,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Divider(
                                      thickness: 0.8,
                                      color: Color(0xFFDCDCDC),
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: getWorkingDaysInfo(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text("Something went wrong"),
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Calendar(
                                          scrollFunc: scrollToBottom,
                                          workDays: snapshot.data,
                                          appointment: appointment,
                                          isShowingApps: false,
                                        );
                                      }

                                      return Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.blue,
                                      ),
                                      child: Image.asset(
                                        'images/${snapshot.data['imgUrl']}.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      snapshot.data['name'],
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                          child: Text(
                                            '• Product Info Here',
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                          child: Text(
                                            '• Product Info Here, more info. Details etc...',
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                          child: Text(
                                            '• Additional details, policies, requirements etc.',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: Divider(
                                      thickness: 0.8,
                                      color: Color(0xFFDCDCDC),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      'Additions',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  OptionBoxGroup(
                                    usesTime: false,
                                    additions: [
                                      'Add Curls (Goddess Faux Locs)',
                                      'Detangling, Blow Drying, and Sectioning'
                                    ],
                                    appointment: appointment,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: Divider(
                                      thickness: 0.8,
                                      color: Color(0xFFDCDCDC),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    child: Text(
                                      'Appointment Date',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: getWorkingDaysInfo(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text("Something went wrong"),
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Calendar(
                                          scrollFunc: scrollToBottom,
                                          workDays: snapshot.data,
                                          appointment: appointment,
                                          isShowingApps: false,
                                        );
                                      }

                                      return Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                        Container(
                          height: 60.0,
                        ),
                      ],
                    ),
                  );
                }),
                Positioned(
                  height: 60.0,
                  bottom: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Color(0xFFDCDCDC), width: 1),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: screenWidth > kTabletBreakpoint
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        screenWidth > kTabletBreakpoint
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${NumberFormat.simpleCurrency(decimalDigits: 0).format(snapshot.data['price'])}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2.0),
                                  Text(duration + minsDuration),
                                ],
                              )
                            : Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${NumberFormat.simpleCurrency(decimalDigits: 0).format(snapshot.data['price'])}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 2.0),
                                    Text(duration + minsDuration),
                                  ],
                                ),
                              ),
                        screenWidth > kTabletBreakpoint
                            ? SizedBox(width: 40)
                            : Container(),
                        screenWidth > kTabletBreakpoint
                            ? Container(
                                child: TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(horizontal: 30)),
                                    minimumSize: MaterialStateProperty.all(
                                        Size(150, 40)),
                                    side: MaterialStateProperty.all<BorderSide>(
                                      BorderSide(
                                          color: Color(0xFF86B6FF), width: 0.5),
                                    ),
                                    shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered))
                                          return Colors.blue.withOpacity(0.04);
                                        if (states.contains(
                                                MaterialState.focused) ||
                                            states.contains(
                                                MaterialState.pressed))
                                          return Colors.blue.withOpacity(0.12);
                                        return null; // Defer to the widget's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () async {
                                    bookApp(context);
                                  },
                                  child: Text(
                                    'Book Appointment',
                                    style: TextStyle(
                                      color: Color(0xFF86B6FF),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          Size(150, 40)),
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                        BorderSide(
                                            color: Color(0xFF86B6FF),
                                            width: 0.5),
                                      ),
                                      shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero)),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.blue),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.hovered))
                                            return Colors.blue
                                                .withOpacity(0.04);
                                          if (states.contains(
                                                  MaterialState.focused) ||
                                              states.contains(
                                                  MaterialState.pressed))
                                            return Colors.blue
                                                .withOpacity(0.12);
                                          return null; // Defer to the widget's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () async {
                                      bookApp(context);
                                    },
                                    child: Text(
                                      'Book Appointment',
                                      style: TextStyle(
                                        color: Color(0xFF86B6FF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
