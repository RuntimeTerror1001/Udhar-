import 'package:udhar_app/Models/transaction.dart';
import 'package:udhar_app/Notifiers/transaction_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

getTransactions(TransactionNotifier transactionNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Transactions')
      .orderBy('date')
      .get();

  List<Trans> _transList = [];

  snapshot.docs.forEach((doc) {
    Map<String, dynamic> data = {
      'uid': doc.id,
      'name': doc['name'],
      'amt': doc['amt'],
      'meth': doc['meth'],
      'date': doc['date'],
      'createdAt': doc['createdAt'],
      'updatedAt': doc['updatedAt'],
    };
    print(data);
    Trans transaction = Trans.fromMap(data);

    _transList.add(transaction);
  });

  transactionNotifier.transList = _transList;
}

uploadTrans(Trans trans, bool isUpdating) async {
  CollectionReference stockRef =
      FirebaseFirestore.instance.collection('Transactions');

  if (isUpdating) {
    trans.updatedAt = Timestamp.now();
    await stockRef.doc(trans.uid.toString()).update(trans.toMap());
  } else {
    trans.createdAt = Timestamp.now();
    DocumentReference documentReference = await stockRef.add(trans.toMap());
    trans.uid = documentReference.id;
    await documentReference.set(trans.toMap(), SetOptions(merge: true));
  }
}

deleteTrans(Trans trans) async {
  await FirebaseFirestore.instance
      .collection('Transactions')
      .doc(trans.uid)
      .delete();
}
