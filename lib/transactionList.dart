import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      body: Column(
        children: [
          StreamBuilder(
            stream: myStream,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('NO data'),
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot trans = snapshot.data!.docs[index];
                    // outstanding = trans['type'] == 'credit'
                    //     ? outstanding += trans['Amount']
                    //     : outstanding -= trans['Amount'];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey,
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
                    );
                  },
                );
              }
              ;
            },
          ),
        ],
      ),
    );
  }
}
