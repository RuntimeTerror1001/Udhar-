import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';
import 'package:udhar_app/Notifiers/event_notifier.dart';
import 'event_datasource.dart';
import 'task_widget.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventNotifier>(context, listen: false).events;

    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onLongPress: (details) {
        final EventNotifer = Provider.of<EventNotifier>(context, listen: false);
        EventNotifer.setDate(details.date!);
        showModalBottomSheet(
            context: context, builder: (context) => TaskWidget());
      },
    );
  }
}
