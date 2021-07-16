import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:udhar_app/Models/transaction.dart';

class TransactionNotifier with ChangeNotifier {
  List<Trans> _transList = [];
  Trans _currTrans = Trans();

  UnmodifiableListView<Trans> get transList => UnmodifiableListView(_transList);

  Trans get currTrans => _currTrans;

  set transList(List<Trans> transactionList) {
    _transList = transactionList;
    notifyListeners();
  }

  set currTrans(Trans transaction) {
    _currTrans = transaction;
    notifyListeners();
  }
}
