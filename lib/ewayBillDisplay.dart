import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:inventory/firebase_api.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ewayBillDisplay extends StatefulWidget {
  String path;

  ewayBillDisplay({required this.path});

  @override
  State<ewayBillDisplay> createState() => _ewayBillDisplayState();
}

class _ewayBillDisplayState extends State<ewayBillDisplay> {
  Future<void> loadNetwork(String path, String name, Reference ref) async {
    Uint8List? pdf = await ref.getData();

    final dir = (await getExternalStorageDirectory())?.path;
    var file = File('${dir}/$name');

    await file.writeAsBytes(pdf!, flush: true);
    OpenFile.open('$dir/$name');
    Navigator.pop(context);
  }

  Widget buildFile(BuildContext context, FirebaseFiles file) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Loading'),
              content: LinearProgressIndicator(),
            );
          },
        );
        loadNetwork(file.url, file.name, file.ref);
      },
      title: Text(file.name),
      leading: Icon(Icons.picture_as_pdf),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<FirebaseFiles>>(
        future: FireBaseApi.listAll(widget.path),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error'),
                );
              } else {
                var files = snapshot.data!;
                var filesn = files.reversed.toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(files.length),
                    Expanded(
                        //scrollDirection: Axis.vertical,
                        child: ListView.builder(
                            itemCount: filesn.length,
                            itemBuilder: (context, index) {
                              final file = filesn[index];
                              return buildFile(context, file);
                            }))
                  ],
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildHeader(int length) {
  return ListTile(
    leading: Container(
      child: Icon(Icons.info),
    ),
    title: Text(length.toString() + ' files found'),
  );
}
