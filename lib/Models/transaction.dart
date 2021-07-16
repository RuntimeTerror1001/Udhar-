import 'package:cloud_firestore/cloud_firestore.dart';

class Trans {
  String uid = '';
  String name = '';
  int amt = 0;
  String meth = 'Credited';
  Timestamp date = Timestamp.now();
  Timestamp createdAt = Timestamp.now();
  Timestamp updatedAt = Timestamp.now();

  Trans();

  Trans.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    name = data['name'];
    amt = data['amt'];
    meth = data['meth'];
    date = data['date'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'amt': amt,
      'meth': meth,
      'date': date,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
