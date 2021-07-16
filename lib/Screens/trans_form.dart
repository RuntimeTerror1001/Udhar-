import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:udhar_app/API/trans_api.dart';
import 'package:udhar_app/Models/transaction.dart';
import 'package:udhar_app/Notifiers/transaction_notifier.dart';
import 'package:udhar_app/Screens/transaction_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils.dart';

class TransForm extends StatefulWidget {
  final bool isUpdating;

  TransForm({required this.isUpdating});
  @override
  _TransFormState createState() => _TransFormState();
}

class _TransFormState extends State<TransForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Trans transaction = Trans();

  Widget _buildPayMethIP() {
    String val = transaction.meth;

    return Padding(
      padding: EdgeInsets.all(10),
      child: DropdownButtonFormField(
        value: val,
        onSaved: (meth) {
          transaction.meth = meth.toString();
        },
        onChanged: (newValue) {
          setState(() {
            val = newValue.toString();
          });
        },
        decoration: InputDecoration(
            labelText: 'Payment ',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        items: [
          DropdownMenuItem(
            value: 'Credited',
            child: 'Credited'.text.makeCentered(),
          ),
          DropdownMenuItem(
            value: 'Debited',
            child: 'Debited'.text.makeCentered(),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: transaction.name,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Name is required';
          }
        },
        onSaved: (value) {
          transaction.name = value.toString();
        },
      ),
    );
  }

  Widget _buildAmtField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Amount',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: transaction.amt.toString(),
        keyboardType: TextInputType.numberWithOptions(signed: true),
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Amount is required';
          }
          if (int.parse(value!) < 0) {
            return 'Amount cannot be negative';
          }
          return null;
        },
        onSaved: (value) {
          transaction.amt = int.parse(value.toString());
        },
      ),
    );
  }

  Widget buildDatePicker() => Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
                text: Utils.toDate(transaction.date.toDate()),
                onClicked: () => pickFromDateTime(transaction.date.toDate(),
                    pickDate: true)),
          ),
          Expanded(
            child: buildDropDownField(
                text: Utils.toTime(transaction.date.toDate()),
                onClicked: () => pickFromDateTime(transaction.date.toDate(),
                    pickDate: false)),
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

    setState(() => transaction.date = Timestamp.fromDate(date));
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

  _saveTrans() {
    if (!(_formKey.currentState!.validate())) {
      _formKey.currentState!.reset();
      return '';
    }
    _formKey.currentState!.save();

    uploadTrans(transaction, widget.isUpdating);
  }

  @override
  void initState() {
    TransactionNotifier transactionNotifier =
        Provider.of<TransactionNotifier>(context, listen: false);
    widget.isUpdating
        ? transaction = transactionNotifier.currTrans
        : transaction = Trans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: 'UDHAR'.text.make(),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: VStack(
            [
              10.heightBox,
              Center(
                  child: (widget.isUpdating
                          ? 'Update Transaction'
                          : 'Add Transaction')
                      .text
                      .xl3
                      .textStyle(GoogleFonts.raleway())
                      .make()),
              20.heightBox,
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _buildNameField()),
              20.heightBox,
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _buildAmtField()),
              20.heightBox,
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _buildPayMethIP()),
              20.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: 'Date : '.text.minFontSize(18).make(),
              ),
              10.heightBox,
              buildDatePicker(),
              45.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'button3',
                    backgroundColor: Colors.red,
                    child:
                        Center(child: Icon(Icons.cancel, color: Colors.black)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FloatingActionButton(
                    heroTag: 'button4',
                    backgroundColor: Theme.of(context).accentColor,
                    child: Center(child: Icon(Icons.save, color: Colors.black)),
                    onPressed: () => _saveTrans().then(
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionScreen()))),
                  ),
                ],
              )
            ],
          ).scrollVertical(),
        ),
      ),
    );
  }
}
