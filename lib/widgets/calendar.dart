import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:web_app_firebase/widgets/optionBox.dart';

import '../appointment.dart';
import '../breakpoints.dart';
import '../event.dart';
import 'option_box_group.dart';

class Calendar extends StatefulWidget {
  final Function scrollFunc;
  final List workDays;
  Appointment appointment;
  bool
      isShowingApps; //Is this calendar only for displaying appointments made by the user, or is it for creating appointments instead

  Calendar(
      {this.scrollFunc,
      this.workDays,
      this.appointment,
      @required this.isShowingApps});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Event>> selectedEvents;
  var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate;
  List timeslots = [];

  List<Event> getEventsForDay(DateTime day) {
    return selectedEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;

        var events = getEventsForDay(_selectedDay);
        formattedDate = formatter.format(_selectedDay);
        bool timeSlotsFound = false;

        if (!widget.isShowingApps) {
          //If this calendar isnt for showing appointments then continue
          widget.workDays.forEach((element) {
            if (element['date'] == formattedDate) {
              timeslots = element['timeslots'];
              timeSlotsFound = true;
              widget.appointment.date = formattedDate;
              widget.scrollFunc();
              return;
            }
          });
        }

        if (!timeSlotsFound) {
          timeslots = [];
        } else {
          timeSlotsFound = false;
        }

        if (events != null && events.length > 0 && !widget.isShowingApps) {
          widget.scrollFunc();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isShowingApps) {
      formattedDate = formatter.format(_selectedDay);
      widget.workDays.forEach((e) {
        if (e['date'] == formattedDate) {
          timeslots = e['timeslots'];
          widget.appointment.date = formattedDate;
          return;
        }
      });
    }

    selectedEvents = {
      DateTime.utc(2021, 7, 21): [
        Event('12:00'),
        Event('3:00'),
        Event('6:00'),
      ],
      DateTime.utc(2021, 8, 8): [Event('12:00')],
    };
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > kTabletBreakpoint
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF75ACFF),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TableCalendar<Event>(
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2021, 1, 1),
                    lastDay: DateTime.utc(2021, 12, 31),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    enabledDayPredicate: (day) {
                      List dates = !widget.isShowingApps
                          ? [
                              ...widget.workDays
                                  .map((e) => DateTime.parse(e['date']))
                            ]
                          : null;
                      return !widget.isShowingApps
                          ? dates.contains(
                                  DateTime(day.year, day.month, day.day)) ||
                              DateTime(day.year, day.month, day.day) ==
                                  DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day)
                          : true;
                    },
                    onDaySelected: _onDaySelected,
                    eventLoader: (day) {
                      return getEventsForDay(day);
                    },
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white),
                      outsideTextStyle: TextStyle(color: Colors.grey),
                      disabledTextStyle: TextStyle(color: Color(0xFFB4D1FF)),
                      markerDecoration: BoxDecoration(
                        color: Color(0xFF376BB9).withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color(0xFFB4D1FF),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFF376BB9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(color: Colors.white),
                      leftChevronIcon:
                          Icon(Icons.chevron_left_rounded, color: Colors.white),
                      rightChevronIcon: Icon(Icons.chevron_right_rounded,
                          color: Colors.white),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Color(0xFF376BB9),
                      ),
                      weekendStyle: TextStyle(
                        color: Color(0xFF376BB9),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              !widget.isShowingApps
                  ? Expanded(
                      child: OptionBoxGroup(
                        timeslots: timeslots,
                        appointment: widget.appointment,
                      ),
                    )
                  : Container(),
              widget.isShowingApps
                  ? Column(
                      children: [
                        ...getEventsForDay(_selectedDay).map(
                          (e) => OptionBox(title: e.title) ?? Container(),
                        ),
                      ],
                    )
                  : Container(),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF75ACFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TableCalendar<Event>(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2021, 1, 1),
                  lastDay: DateTime.utc(2021, 12, 31),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  enabledDayPredicate: (day) {
                    List dates = !widget.isShowingApps
                        ? [
                            ...widget.workDays
                                .map((e) => DateTime.parse(e['date']))
                          ]
                        : null;
                    return !widget.isShowingApps
                        ? dates.contains(
                                DateTime(day.year, day.month, day.day)) ||
                            DateTime(day.year, day.month, day.day) ==
                                DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day)
                        : true;
                  },
                  onDaySelected: _onDaySelected,
                  eventLoader: (day) {
                    return getEventsForDay(day);
                  },
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.white),
                    outsideTextStyle: TextStyle(color: Colors.grey),
                    disabledTextStyle: TextStyle(color: Color(0xFFB4D1FF)),
                    markerDecoration: BoxDecoration(
                      color: Color(0xFF376BB9).withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFFB4D1FF),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF376BB9),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(color: Colors.white),
                    leftChevronIcon:
                        Icon(Icons.chevron_left_rounded, color: Colors.white),
                    rightChevronIcon:
                        Icon(Icons.chevron_right_rounded, color: Colors.white),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Color(0xFF376BB9),
                    ),
                    weekendStyle: TextStyle(
                      color: Color(0xFF376BB9),
                    ),
                  ),
                ),
              ),
              !widget.isShowingApps
                  ? OptionBoxGroup(
                      timeslots: timeslots,
                      appointment: widget.appointment,
                    )
                  : Container(),
              widget.isShowingApps
                  ? Column(
                      children: [
                        ...getEventsForDay(_selectedDay).map(
                          (e) => OptionBox(title: e.title) ?? Container(),
                        ),
                      ],
                    )
                  : Container(),
            ],
          );
  }
}
