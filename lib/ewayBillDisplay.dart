import 'dart:async';
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
  late Reference _storageRef;
  late var _downloadTask;
  late Uint8List? pdf;
  double _percentage = 0.0;
  Future<void> loadNetwork(String path, String name, Reference ref) async {
    pdf = await ref.getData();

    // await _downloadTask.asStream().listen((taskSnapshot) {
    //   setState(() {
    //     _percentage =
    //         (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes * 100)
    //             .toInt();
    //   });
    // });
    // _downloadTask.then((taskSnapshot) {
    //   setState(() {
    //     _percentage = 100;
    //     pdf = _downloadTask;
    //   });
    // });

    final dir = (await getExternalStorageDirectory())?.path;
    var file = File('${dir}/$name');

    print('hi');
    await file.writeAsBytes(pdf!, flush: true);
    OpenFile.open('$dir/$name');

    Navigator.pop(context);
  }

  Widget buildFile(BuildContext context, FirebaseFiles file) {
    return ListTile(
      onTap: () async {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Loading...'),
              content: LinearProgressIndicator(
                  //value: _percentage / 100,
                  ),
            );
          },
        );
        await loadNetwork(file.url, file.name, file.ref);
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
