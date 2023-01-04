import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory/proinfo.dart';

class viewProforma extends StatefulWidget {
  const viewProforma({Key? key}) : super(key: key);

  @override
  State<viewProforma> createState() => _viewProformaState();
}

class _viewProformaState extends State<viewProforma> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proforma Invoices'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('proformaInvoices')
            .orderBy('invno', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return proinfo(
                invno: document['invno'],
                partyname: document['BilledTo'],
                docId: document['docId'],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
