import 'package:flutter/material.dart';
import 'package:web_app_firebase/widgets/optionBox.dart';

import '../appointment.dart';
import '../breakpoints.dart';

class OptionBoxGroup extends StatefulWidget {
  final List timeslots;
  final bool usesTime; //Is this a timeslot box?
  final List additions;
  Appointment appointment;

  OptionBoxGroup(
      {this.timeslots,
      this.usesTime = true,
      this.additions,
      @required this.appointment});

  @override
  _OptionBoxGroupState createState() => _OptionBoxGroupState();
}

class _OptionBoxGroupState extends State<OptionBoxGroup> {
  String groupVal;

  void setGroupVal(String val) {
    setState(() {
      groupVal = val;
      widget.usesTime
          ? widget.appointment.time = groupVal
          : widget.appointment.additions = groupVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.usesTime
          ? [
              MediaQuery.of(context).size.width > kTabletBreakpoint
                  ? widget.timeslots.length > 0
                      ? Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Appointment Date',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        )
                      : Container()
                  : Container(),
              ...widget.timeslots.map(
                (e) => OptionBox(
                  title: int.parse(e.split(':')[0]) > 12
                      ? (int.parse(e.split(':')[0]) - 12).toString() + ':00 pm'
                      : e == '12:00'
                          ? e + ' pm'
                          : e + ' am',
                  onSelected: setGroupVal,
                  groupVal: groupVal,
                ),
              ),
            ]
          : [
              ...widget.additions.map(
                (e) => OptionBox(
                  title: e,
                  onSelected: setGroupVal,
                  groupVal: groupVal,
                ),
              ),
            ],
    );
  }
}
