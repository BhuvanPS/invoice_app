import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory/proformaInvoice/proformaDetail.dart';

class proinfo extends StatefulWidget {
  late int invno;
  late String partyname;
  late String docId;
  late String product;
  late String invDate;
  late String dueDate;
  late String hsn;
  late num qty;
  late num rate;
  late num exmill;
  late num sgst;
  late num cgst;
  late num total;
  late bool tcs;

  proinfo(
      {required this.invno,
      required this.partyname,
      required this.docId,
      required this.product,
      required this.invDate,
      required this.dueDate,
      required this.hsn,
      required this.qty,
      required this.rate,
      required this.exmill,
      required this.sgst,
      required this.cgst,
      required this.total,
      required this.tcs});

  @override
  State<proinfo> createState() => _proinfoState();
}

class _proinfoState extends State<proinfo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return proformaDetail(
            docId: widget.docId,
            partyname: widget.partyname,
            product: widget.product,
            invDate: widget.invDate,
            dueDate: widget.dueDate,
            hsn: widget.hsn,
            qty: widget.qty,
            rate: widget.rate,
            exmill: widget.exmill,
            sgst: widget.sgst,
            cgst: widget.cgst,
            total: widget.total,
            invno: widget.invno,
            tcs: widget.tcs,
          );
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF292B35),
          borderRadius: BorderRadius.circular(8),
        ),
        //color: Colors.blueGrey,
        padding: EdgeInsets.fromLTRB(5, 12, 10, 12),
        margin: EdgeInsets.all(7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.book_sharp,
                    color: Colors.white60,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INV NO : ${widget.invno.toString()}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.partyname,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () async {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Are you Sure?'),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('proformaInvoices')
                                        .doc(widget.docId)
                                        .delete();
                                    Navigator.of(context).pop();
                                    //  setState(() {});
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
                                    //ProformaInvoices.documentList;
                                    //Navigator.of(context).push();
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(fontSize: 20),
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    child: Text(
                                      'No',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )),
                            ],
                          ));
                },
                child: Icon(
                  Icons.delete_outlined,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}
