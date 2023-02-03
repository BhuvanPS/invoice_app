import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory/proformaInvoice/proformaDetail.dart';

class proinfo extends StatefulWidget {
  late int invno;
  late String partyname;
  late String docId;

  proinfo({required this.invno, required this.partyname, required this.docId});

  @override
  State<proinfo> createState() => _proinfoState();
}

class _proinfoState extends State<proinfo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return proformaDetail(docId: widget.docId);
        }));
      },
      onLongPress: () async {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('proformaInvoices')
                              .doc(widget.docId)
                              .delete();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Row(
                              children: [
                                Text('Deleted Successfully '),
                                Icon(
                                  Icons.done_outlined,
                                  color: Colors.green,
                                )
                              ],
                            )),
                          );
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
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue.withOpacity(0.5),
              Colors.blueAccent,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        //color: Colors.blueGrey,
        padding: EdgeInsets.fromLTRB(5, 5, 0, 8),
        margin: EdgeInsets.all(9),
        child: Row(
          children: [
            Icon(Icons.document_scanner_outlined),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Inv No : ${widget.invno.toString()}'),
                SizedBox(
                  height: 5,
                ),
                Text(widget.partyname),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
