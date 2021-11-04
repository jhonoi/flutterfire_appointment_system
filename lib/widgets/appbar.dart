import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget myAppBar(
    {@required String title,
    @required BuildContext context,
    bool useTabBar = true}) {
  return AppBar(
    elevation: 0.0,
    centerTitle: true,
    backgroundColor: Colors.white,
    shape: Border(bottom: BorderSide(color: Color(0xFFDCDCDC), width: 1)),
    iconTheme: IconThemeData(color: Color(0xFF6A6A6A)),
    title: Text(
      title,
      style: TextStyle(
        color: Color(0xFF6A6A6A),
        fontWeight: FontWeight.w600,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          child: CircleAvatar(
            radius: 16.0,
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          onTap: () {
            if (FirebaseAuth.instance.currentUser != null) {
              Navigator.pushNamed(
                context,
                '/appointments',
              );
            } else {
              Navigator.pushNamed(
                context,
                '/login',
              );
            }
          },
        ),
      ),
    ],
    bottom: useTabBar
        ? TabBar(
            isScrollable: true,
            indicatorWeight: 3.0,
            unselectedLabelColor: Color(0xFF6A6A6A),
            labelColor: Theme.of(context).accentColor,
            tabs: [
              Tab(
                text: 'Option 1',
              ),
              Tab(
                text: 'Option 2',
              ),
              Tab(
                text: 'Option 3',
              ),
              Tab(
                text: 'Option 4',
              ),
              Tab(
                text: 'Option 5',
              ),
              Tab(
                text: 'Option 6',
              ),
            ],
          )
        : null,
  );
}
