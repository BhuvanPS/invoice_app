import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class detailedView extends StatefulWidget {
  final String name;

  detailedView({required this.name});

  @override
  State<detailedView> createState() => _detailedViewState();
}

class _detailedViewState extends State<detailedView> {
  //DatabaseReference dbref = FirebaseDatabase.instance.ref();
  late String partyName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('clients')
            .where('name', isEqualTo: widget.name)
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
                DocumentSnapshot client = snapshot.data!.docs[index];
                return Container(
                  child: Text(client['name']),
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
