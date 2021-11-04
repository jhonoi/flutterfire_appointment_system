import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentBox extends StatelessWidget {
  final String prodName;
  final int price;
  final String date;
  final String time;
  final String additions;
  final int duration;
  final formatter = DateFormat.yMMMMd('en_US');
  final String id;
  final Function deleteFunc;

  AppointmentBox({
    this.prodName,
    this.price,
    this.date,
    this.time,
    this.additions,
    this.duration,
    this.id,
    this.deleteFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6A6A6A).withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prodName,
                style: TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
              Text(
                '${NumberFormat.simpleCurrency(decimalDigits: 0).format(price)}',
                style: TextStyle(
                  color: Color(0xFF376BB9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          RichText(
            text: TextSpan(
              text: '${formatter.format(DateTime.parse(date))} | ',
              style: TextStyle(color: Color(0xFF6A6A6A)),
              children: <TextSpan>[
                TextSpan(
                  text: time,
                  style: TextStyle(
                    color: Color(0xFF376BB9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            additions,
            style: TextStyle(color: Color(0xFF6A6A6A)),
          ),
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Duration: ${duration.toString()}',
                style: TextStyle(color: Color(0xFF6A6A6A)),
              ),
              GestureDetector(
                onTap: () async {
                  //await deleteFunc(id);
                  await FirebaseAuth.instance.signOut();
                },
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFFF7777),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
