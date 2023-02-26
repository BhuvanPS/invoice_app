import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:inventory/ewayBillDisplay.dart';
import 'package:inventory/initialise.dart';
import 'package:inventory/proformaInvoice/viewProforma.dart';
import 'package:inventory/transactions/allTransactions.dart';

import './gstnSearch/gstnSearch.dart';
import 'proformaInvoice/getInvDetails.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int selectedIndex = 0;

  Future uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File pick = File(result!.files.single.path.toString());
    var file = pick.readAsBytesSync();

    String name = result.files.single.name;
    var ext = result.files.single.extension;
    var pdfFile = FirebaseStorage.instance
        .ref()
        .child('proformaInvoices')
        .child('${name + '.' + ext!}');
    UploadTask task = pdfFile.putData(file);
    TaskSnapshot snapshot = await task;
    String url = await snapshot.ref.getDownloadURL();
    print(url);
    //add the url as parameter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sharath Agencies'),
      ),
      body: GridView(
        padding: EdgeInsets.all(8),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
        ),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return viewProforma();
              }));
            },
            child: Container(
              //padding: const EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_books),
                    Text('View Proforma'),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pinkAccent.withOpacity(0.7),
                    Colors.purpleAccent,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ewayBillDisplay(
                  path: 'taxInvoices/',
                );
              }));
            },
            child: Container(
              //padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book),
                  Text('View Tax Invoices'),
                ],
              ),
              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue.withOpacity(0.7),
                    Colors.greenAccent,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              QuerySnapshot querySnap = await FirebaseFirestore.instance
                  .collection('proformaInvoices')
                  .orderBy('invno', descending: true)
                  .limit(1)
                  .get();

              Map<String, dynamic> data =
                  querySnap.docs.first.data() as Map<String, dynamic>;
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return getInvDetails(
                  invNo: data['invno'],
                );
              }));
            },
            child: Container(
              //padding: const EdgeInsets.all(30),

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    Text('Add Proforma'),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.7),
                    Colors.blue,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return gstnSearch();
              }));
            },
            child: Container(
              //padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  Text('GST Search'),
                ],
              ),
              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.7),
                    Colors.red,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return initialise();
              }));
            },
            child: Container(
              //padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group),
                  Text('View Clients'),
                ],
              ),
              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.7),
                    Colors.amber,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return allTransactions();
              }));
            },
            child: Container(
              //padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.swap_horiz_rounded),
                  Text('View Transactions'),
                ],
              ),
              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.7),
                    Colors.greenAccent,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ewayBillDisplay(
                  path: 'ewayBills/',
                );
              }));
            },
            child: Container(
              //padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fire_truck),
                  Text('View Eway Bills'),
                ],
              ),
              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.limeAccent.withOpacity(0.7),
                    Colors.greenAccent,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
