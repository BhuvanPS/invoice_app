import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class proformaDetail extends StatefulWidget {
  String docId;
  proformaDetail({required this.docId});

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
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('proformaInvoices')
      //       .where('invno', isEqualTo: widget.invno)
      //       .snapshots(),
      //   builder: (BuildContext context,
      //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else {
      //       return ListView.builder(
      //         //itemCount: snapshot.data!.docs.length,
      //         itemCount: 1,
      //         itemBuilder: (context, index) {
      //           DocumentSnapshot prInvoice = snapshot.data!.docs[index];
      //           return Container(
      //             child: Column(
      //               children: [
      //                 Text('INV NO :' + prInvoice['invno'].toString()),
      //                 Text(prInvoice['BilledTo']),
      //                 Text(prInvoice['Quantity']),
      //                 Text(prInvoice['Rate']),
      //                 Text(prInvoice['TotalAmount'].toString()),
      //                 Text(prInvoice['product']),
      //               ],
      //             ),
      //           );
      //         },
      //       );
      //     }
      //     ;
      //   },
      // ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('proformaInvoices')
              .doc(widget.docId.trim())
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            //Error Handling conditions
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            //Data is output to the user
            if (snapshot.connectionState == ConnectionState.done) {
              //Future.delayed(Duration(seconds: 10));
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(data['BilledTo']),
                  Text('Inv No : ' + data['invno'].toString()),
                  Text(data['product']),
                  Text(data['hsn']),
                  Text(data['Quantity'] + ' Kgs'),
                  Text('Rs ' + data['Rate'] + '/kg'),
                  Text('Bill Amount : ' + data['TotalAmount'].toString()),
                ],
              );
              // return Text("Full Name: ${data['BilledTo']} ${data['Quantity']}");
            }

            return CircularProgressIndicator(
              backgroundColor: Colors.redAccent,
              valueColor: AlwaysStoppedAnimation(Colors.green),
              strokeWidth: 10,
            );
          },
        ),
      ),
    );
  }
}
