import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:udhar_app/Components/event_datasource.dart';
import 'package:udhar_app/Notifiers/event_notifier.dart';
import 'package:udhar_app/Screens/event_view.dart';

class TaskWidget extends StatefulWidget {
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final eventNotifier = Provider.of<EventNotifier>(context, listen: true);
    final selectedEvents = eventNotifier.eventsOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'No Events Found!',
          style: TextStyle(color: Colors.tealAccent, fontSize: 24),
        ),
      );
    }
    return SfCalendarTheme(
      data: SfCalendarThemeData(
        backgroundColor: Colors.white12,
        headerTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        timeTextStyle: TextStyle(color: Colors.white),
        cellBorderColor: Colors.white54,
      ),
      child: SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(eventNotifier.events),
        initialDisplayDate: eventNotifier.selectedDate,
        appointmentBuilder: appointmentsBuilder,
        onTap: (details) {
          if (details.appointments == null) return null;

          final event = details.appointments!.first;

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EventView(event: event)));
        },
      ),
    );
  }

  Widget appointmentsBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: event.bgCol.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
