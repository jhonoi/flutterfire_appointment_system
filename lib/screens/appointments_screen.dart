import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_app_firebase/widgets/appbar.dart';
import 'package:web_app_firebase/widgets/appointment_box.dart';
import 'package:web_app_firebase/widgets/max_container.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  Query<Map<String, dynamic>> appointments;

  Future<void> deleteApp(String id) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(id)
        .delete();
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    appointments = FirebaseFirestore.instance
        .collection('appointments')
        .orderBy('date')
        .where('clientID', isEqualTo: FirebaseAuth.instance.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(
          useTabBar: false,
          context: context,
          title: 'Appointments',
        ),
        body: StreamBuilder(
          stream: appointments.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.data.docs.length == 0) {
              signOut();
            }

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500.0),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return AppointmentBox(
                      prodName: snapshot.data.docs[index]['productName'],
                      price: snapshot.data.docs[index]['price'],
                      date: snapshot.data.docs[index]['date'],
                      time: snapshot.data.docs[index]['time'],
                      additions: snapshot.data.docs[index]['additions'],
                      duration: snapshot.data.docs[index]['duration'],
                      id: snapshot.data.docs[index].id,
                      deleteFunc: deleteApp,
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}
