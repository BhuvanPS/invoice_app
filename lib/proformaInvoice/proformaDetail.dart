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
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Client Name : ' + data['BilledTo'],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                'Invoice No : ' + data['invno'].toString(),
                                style: TextStyle(fontSize: 20)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Product : ' + data['product'],
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Hsn Code : ' + data['hsn'],
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Quantity : ' +
                                  data['Quantity'].toString() +
                                  ' Kgs',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Rate : ₹ ' + data['Rate'].toString() + '/kg',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Ex-mill : ₹ ' + data['Amount'].toString(),
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'SGST : ₹ ${data['SGST']}',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'CGST : ₹ ${data['SGST']}',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Total Gst : ₹ ${data['SGST'] * 2}',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(width: 2),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Bill Amount :  ₹ ' +
                                      data['TotalAmount'].toString(),
                                  style: TextStyle(fontSize: 21),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
