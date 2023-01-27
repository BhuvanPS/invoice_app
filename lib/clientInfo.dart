import 'package:flutter/material.dart';

import './detailedView.dart';

class clientInfo extends StatefulWidget {
  final String name;
  final String gstn;
  final String docId;

  clientInfo({required this.name, required this.gstn, required this.docId});

  @override
  State<clientInfo> createState() => _clientInfoState();
}

class _clientInfoState extends State<clientInfo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return detailedView(
                id: widget.docId,
                name: widget.name,
              );
            },
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey, borderRadius: BorderRadius.circular(18)),
          //color: Colors.pink,
          padding: EdgeInsets.fromLTRB(0, 5, 0, 8),
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(widget.name),
              SizedBox(
                height: 5,
              ),
              Text(widget.gstn),
            ],
          ),
        ),
      ),
    );
  }
}
