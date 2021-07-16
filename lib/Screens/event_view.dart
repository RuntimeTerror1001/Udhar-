import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:udhar_app/Models/event.dart';
import 'package:udhar_app/Screens/cal_screen.dart';
import 'package:udhar_app/utils.dart';
import 'package:udhar_app/Notifiers/event_notifier.dart';
import 'package:velocity_x/velocity_x.dart';
import 'eventForm_screen.dart';

class EventView extends StatelessWidget {
  final Event event;

  EventView({required this.event});
  @override
  Widget build(BuildContext context) {
    Padding buildDate(String text1, DateTime dateTime) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text1.text.white.textStyle(TextStyle(fontSize: 20)).make(),
            (Utils.toDateTime(dateTime))
                .toString()
                .text
                .white
                .textStyle(TextStyle(fontSize: 18))
                .make(),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventForm(event: event)));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              final eventNotifier =
                  Provider.of<EventNotifier>(context, listen: false);
              eventNotifier.deleteEvent(event);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CalScreen()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
        child: VStack(
          [
            (event.title)
                .text
                .color(Theme.of(context).accentColor)
                .textStyle(TextStyle(fontSize: 30))
                .makeCentered(),
            event.isAllDay ? 30.heightBox : 70.heightBox,
            event.isAllDay
                ? 'All Day Event'
                    .text
                    .textStyle(TextStyle(color: Colors.yellow, fontSize: 25))
                    .makeCentered()
                : Column(
                    children: [
                      buildDate('From', event.from),
                      buildDate('To', event.to),
                    ],
                  ),
            event.isAllDay ? 40.heightBox : 25.heightBox,
            'Event Description'.text.headline5(context).teal200.make(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: event.desc.text.textStyle(TextStyle(fontSize: 18)).make(),
            )
          ],
        ).scrollVertical(),
      ),
    );
  }
}
