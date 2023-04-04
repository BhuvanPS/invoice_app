import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory/addTrans.dart';
import 'package:inventory/transactionList.dart';

class detailedView extends StatefulWidget {
  final String id;
  final String name;

  detailedView({required this.id, required this.name});

  @override
  State<detailedView> createState() => _detailedViewState();
}

class _detailedViewState extends State<detailedView> {
  //DatabaseReference dbref = FirebaseDatabase.instance.ref();
  late String partyName = '';
  num sum = 0;
  num total = 0;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('transactions')
        .where('partyId', isEqualTo: widget.id.trim())
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if (element.data()['type'] == 'credit') {
          sum = sum - element.data()['Amount'];
        } else {
          sum = sum + element.data()['Amount'];
        }
      });
      setState(() {
        total = sum;
      });
      FirebaseFirestore.instance
          .collection('clients')
          .doc(widget.id.trim())
          .update({'outstanding': total});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('clients')
              .doc(widget.id.trim())
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
              return Center(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Outstanding :${total}'),
                    TextButton(
                        onPressed: () {
                          sum = 0;
                          FirebaseFirestore.instance
                              .collection('transactions')
                              .where('partyId', isEqualTo: widget.id.trim())
                              .get()
                              .then((querySnapshot) {
                            querySnapshot.docs.forEach((element) {
                              if (element.data()['type'] == 'credit') {
                                sum = sum - element.data()['Amount'];
                              } else {
                                sum = sum + element.data()['Amount'];
                              }
                              FirebaseFirestore.instance
                                  .collection('clients')
                                  .doc(widget.id.trim())
                                  .update({'outstanding': sum});
                            });
                            setState(() {
                              total = sum;
                            });
                          });
                        },
                        child: Icon(Icons.refresh)),
                    Text('GSTN :' + data['gstn']),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return transactionList(docId: data['docId']);
                          }));
                        },
                        child: Text('View Transaction')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return addTrans(
                              id: widget.id.trim(),
                              name: widget.name,
                            );
                          }));
                        },
                        child: Text('Record Transaction'))
                  ],
                ),
              );
              // return Text("Full Name: ${data['BilledTo']} ${data['Quantity']}");
            }

            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.redAccent,
                valueColor: AlwaysStoppedAnimation(Colors.green),
                strokeWidth: 10,
              ),
            );
          },
        ),
      ),
    );
  }
}
