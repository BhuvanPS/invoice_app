import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addTrans extends StatefulWidget {
  final String id;
  addTrans({required this.id});

  @override
  State<addTrans> createState() => _addTransState();
}

class _addTransState extends State<addTrans> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController type = TextEditingController();

  late String amt = '';
  late String typeofPayment = '';

  Future<void> uploadingData(
    String amt,
    String id,
  ) async {
    await FirebaseFirestore.instance.collection("transactions").add({
      'partyId': id,
      'Amount': int.parse(amt),
      'type': typeofPayment,
      'Date': DateTime.now()
    }).then((value) => FirebaseFirestore.instance
        .collection('transactions')
        .doc(value.id)
        .update({'transactionId': value.id}));
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      _formKey.currentState!.save();
      FocusManager.instance.primaryFocus?.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction Added')),
      );
      //verified = true;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Record'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: amount,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  onFieldSubmitted: (value) {},
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return 'Enter Text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    amt = value!;
                  },
                ),
                TextFormField(
                  controller: type,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  onFieldSubmitted: (value) {},
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return 'Enter Text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    typeofPayment = value!;
                  },
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      _submit();
                      uploadingData(amt, widget.id.trim());
                    },
                    child: Text('Add'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
