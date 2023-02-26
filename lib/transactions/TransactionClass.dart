import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionClass {
  DateTime dateTime;
  String description;
  num amount;
  String type;

  TransactionClass(
      {required this.dateTime,
      required this.description,
      required this.amount,
      required this.type});

  static List<TransactionClass> transactions = [];

  static getTransaction(String id) async {
    transactions.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('partyId', isEqualTo: id.trim())
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      transactions.add(TransactionClass(
          dateTime: data[''],
          description: data[''],
          amount: data[''],
          type: data['']));
    }
  }
}
