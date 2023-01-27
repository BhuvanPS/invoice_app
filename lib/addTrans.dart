import 'dart:async';

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
  TextEditingController description = TextEditingController();

  late String amt = '';
  var typeofPayment;
  late String des = '';

  Future<void> uploadingData(
    String amt,
    String id,
  ) async {
    await FirebaseFirestore.instance.collection("transactions").add({
      'partyId': id,
      'Amount': int.parse(amt),
      'type': typeofPayment,
      'Date': DateTime.now(),
      'Description': des
    }).then((value) => FirebaseFirestore.instance
        .collection('transactions')
        .doc(value.id)
        .update({'transactionId': value.id}));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Text('Transaction Added'),
        duration: Duration(milliseconds: 750),
      ),
    );
    Timer(Duration(milliseconds: 1200), () {
      Navigator.of(context).pop();
    });
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      _formKey.currentState!.save();
      FocusManager.instance.primaryFocus?.unfocus();
      uploadingData(amt, widget.id.trim());

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
                  keyboardType: TextInputType.number,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Radio(
                        value: 'debit',
                        groupValue: typeofPayment,
                        onChanged: (value) {
                          setState(() {
                            typeofPayment = value!;
                          });
                        }),
                    Text('Debit'),
                    new Radio(
                        value: 'credit',
                        groupValue: typeofPayment,
                        onChanged: (value) {
                          setState(() {
                            typeofPayment = value!;
                          });
                          print(typeofPayment);
                        }),
                    Text('Credit'),
                  ],
                ),
                TextFormField(
                  controller: description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  onFieldSubmitted: (value) {},
                  validator: (value) {
                    // if (value!.isEmpty || value == null) {
                    //   return 'Enter Text';
                    // }
                    return null;
                  },
                  onSaved: (value) {
                    des = value!;
                  },
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      _submit();
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
