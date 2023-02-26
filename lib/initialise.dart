import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './addClient.dart';
import './clientInfo.dart';

class initialise extends StatefulWidget {
  const initialise({Key? key}) : super(key: key);

  @override
  State<initialise> createState() => _initialiseState();
}

class _initialiseState extends State<initialise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 15),
              child: GestureDetector(
                child: Text(
                  ' + Add Client',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return addClient();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        title: Text('Clients'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('clients')
            .orderBy('name')
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return clientInfo(
                  name: document['name'],
                  gstn: document['gstn'],
                  docId: document['docId']);
            }).toList(),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blueAccent,
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (_) {
      //           return addClient();
      //         },
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
