import 'package:udhar_app/Models/event.dart';
import 'package:udhar_app/utils.dart';
import 'package:flutter/material.dart';

class EventNotifier extends ChangeNotifier {
  final List<Event> eventList = [];

  List<Event> get events => eventList;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => eventList;

  void addEvent(Event event) {
    eventList.add(event);

    notifyListeners();
  }

  void deleteEvent(Event event) {
    eventList.remove(event);

    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    final index = eventList.indexOf(oldEvent);

    eventList[index] = newEvent;

    notifyListeners();
  }
}
