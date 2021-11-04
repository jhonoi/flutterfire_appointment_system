import 'package:flutter/material.dart';

class OptionBox extends StatelessWidget {
  Color neutral = Color(0xFF6A6A6A).withOpacity(0.5);
  Color clicked = Color(0xFF75ACFF);
  final String groupVal;
  final String title;
  final Function onSelected;

  OptionBox({this.title, this.onSelected, this.groupVal});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 450),
      child: GestureDetector(
        onTap: () {
          onSelected(title);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: groupVal == title
                ? Border.all(width: 2.0, color: const Color(0xFF75ACFF))
                : null,
            boxShadow: [
              BoxShadow(
                color: groupVal == title ? clicked : neutral,
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          margin: EdgeInsets.only(top: 10),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF6A6A6A),
            ),
          ),
        ),
      ),
    );
  }
}
