import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/Authentication.dart';

class transactionList extends StatefulWidget {
  final String docId;
  transactionList({required this.docId});

  @override
  State<transactionList> createState() => _transactionListState();
}

class _transactionListState extends State<transactionList> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> myStream;
  num outstanding = 0;

  @override
  void initState() {
    myStream = FirebaseFirestore.instance
        .collection('transactions')
        .where('partyId', isEqualTo: widget.docId.trim())
        .orderBy('Date', descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: myStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.data!.docs.isEmpty) {
            print("no data");
            return Placeholder();
          }
          print("hiihidf");
          print(snapshot.data!.docs);
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot trans = snapshot.data!.docs[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onLongPress: () async {
                    return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text("Options"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      bool isAuthenticated =
                                          await Authentication
                                              .authenticateWithBiometrics();

                                      if (isAuthenticated) {
                                        FirebaseFirestore.instance
                                            .collection('transactions')
                                            .doc(trans['transactionId'])
                                            .delete();

                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.white,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              // margin:
                                              //     EdgeInsets.only(bottom: 10),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              content: Row(
                                                children: [
                                                  Text(
                                                    'Deleted Successfully ',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Icon(
                                                    Icons.done_outlined,
                                                    color: Colors.green,
                                                  )
                                                ],
                                              )),
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        Text('  Delete'),
                                      ],
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        Text('  Edit'),
                                      ],
                                    )),
                              ],
                            ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(7)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text((trans['Amount'].toString())),
                        Text(DateFormat('dd-MMM-yy ~ HH:mm')
                            .format(trans['Date'].toDate())
                            .toString()),
                        Text(trans['type']),
                        //Text(widget.docId),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

          ;
        },
      ),
    );
  }
}
