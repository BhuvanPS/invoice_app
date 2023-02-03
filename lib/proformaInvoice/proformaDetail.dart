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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.print),
          )
        ],
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
              return Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client Name : ' + data['BilledTo'],
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('Invoice No : ' + data['invno'].toString()),
                    Text('Product : ' + data['product']),
                    Text('Hsn Code : ' + data['hsn']),
                    Text('Quantity : ' + data['Quantity'] + ' Kgs'),
                    Text('Rate : Rs ' + data['Rate'] + '/kg'),
                    Text(data['Amount'].toString()),
                    Text('Bill Amount : ' + data['TotalAmount'].toString()),
                  ],
                ),
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
