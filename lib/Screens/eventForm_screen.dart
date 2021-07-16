import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:udhar_app/Models/event.dart';
import 'package:udhar_app/Screens/cal_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:udhar_app/utils.dart';
import 'package:udhar_app/Notifiers/event_notifier.dart';
import 'package:provider/provider.dart';

class EventForm extends StatefulWidget {
  final Event? event;

  EventForm({this.event});
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  bool isAllDay = false;

  Widget buildTitleField() {
    return TextFormField(
      controller: titleController,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add Title',
      ),
      onFieldSubmitted: (_) => saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Title is required';
        }
        return null;
      },
    );
  }

  Widget buildDescField() {
    return Container(
      height: 50,
      child: TextFormField(
        controller: descController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          hintText: 'Add Description',
        ),
        onFieldSubmitted: (_) => saveForm(),
      ),
    );
  }

  Widget buildDatePicker(DateTime param) => Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
                text: Utils.toDate(param),
                onClicked: () => pickFromDateTime(param, pickDate: true)),
          ),
          Expanded(
            child: buildDropDownField(
                text: Utils.toTime(param),
                onClicked: () => pickFromDateTime(param, pickDate: false)),
          )
        ],
      );

  Widget buildDropDownField(
      {required String text, required VoidCallback onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: Icon(Icons.arrow_drop_down_outlined),
      onTap: onClicked,
    );
  }

  Future pickFromDateTime(DateTime dt, {required bool pickDate}) async {
    final date = await pickDateTime(dt, pickDate: pickDate);

    if (date == null) return;

    if (dt.isAtSameMomentAs(fromDate))
      setState(() => fromDate = date);
    else
      setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(DateTime initDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initDate,
          firstDate: firstDate ?? DateTime(2015, 8),
          lastDate: DateTime(2101));

      if (date == null) return null;
      final time = Duration(
        hours: initDate.hour,
        minutes: initDate.minute,
      );
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initDate));
      if (timeOfDay == null) return null;
      final date = DateTime(initDate.year, initDate.month, initDate.day);
      final time = Duration(
        hours: timeOfDay.hour,
        minutes: timeOfDay.minute,
      );
      return date.add(time);
    }
  }

  Future saveForm() async {
    if (_formKey.currentState!.validate()) {
      final event = Event(
          title: titleController.text,
          to: toDate,
          from: fromDate,
          desc: descController.text,
          isAllDay: isAllDay);

      final isEditing = widget.event != null;
      final eventNotifier = Provider.of<EventNotifier>(context, listen: false);

      if (isEditing) {
        eventNotifier.editEvent(event, widget.event!);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CalScreen()));
      } else {
        eventNotifier.addEvent(event);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CalScreen()));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      titleController.text = widget.event!.title;
      fromDate = widget.event!.from;
      toDate = widget.event!.to;
      descController.text = widget.event!.desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.done))],
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: VStack(
          [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildTitleField(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: 'FROM'.text.bold.textStyle(TextStyle(fontSize: 15)).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: buildDatePicker(fromDate),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: 'TO'.text.bold.textStyle(TextStyle(fontSize: 15)).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: buildDatePicker(toDate),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Checkbox(
                    value: isAllDay,
                    fillColor: MaterialStateProperty.all(Colors.white),
                    checkColor: Colors.teal,
                    onChanged: (bool? value) {
                      setState(() {
                        isAllDay = value!;
                      });
                      print(isAllDay);
                    },
                  ),
                  5.widthBox,
                  'All Day Event'.text.minFontSize(16).white.make(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildDescField(),
            ),
          ],
        ),
      ),
    );
  }
}
