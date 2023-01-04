import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class proformaDetail extends StatefulWidget {
  int invno;
  proformaDetail({required this.invno});

  @override
  State<proformaDetail> createState() => _proformaDetailState();
}

class _proformaDetailState extends State<proformaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('proformaInvoices')
            .where('invno', isEqualTo: widget.invno)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              //itemCount: snapshot.data!.docs.length,
              itemCount: 1,
              itemBuilder: (context, index) {
                DocumentSnapshot prInvoice = snapshot.data!.docs[index];
                return Container(
                  child: Column(
                    children: [
                      Text(prInvoice['invno'].toString()),
                      Text(prInvoice['BilledTo']),
                      Text(prInvoice['Quantity']),
                      Text(prInvoice['Rate']),
                      Text(prInvoice['TotalAmount'].toString())
                    ],
                  ),
                );
              },
            );
          }
          ;
        },
      ),
    );
  }
}
