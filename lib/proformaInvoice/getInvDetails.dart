import 'package:add_comma/add_comma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/proformaInvoice/pdfgen.dart';
import 'package:vibration/vibration.dart';

class getInvDetails extends StatefulWidget {
  final num invNo;
  const getInvDetails({required this.invNo});

  @override
  State<getInvDetails> createState() => _getInvDetailsState();
}

class _getInvDetailsState extends State<getInvDetails> {
  final putComma = addCommasIndian();
  var selectedparty;
  late String gstn = '';
  late String addLin1 = '';
  late String addLin2 = '';
  late String pincode = '';
  String hsncode = '5205';
  late String gstRate = '5';
  late String price = '';
  late String quantity = '';
  late int Amount = 0;
  late String prevAmt = '';
  TextEditingController invno = new TextEditingController();
  TextEditingController product = new TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController dueDateInput = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController rate = TextEditingController();

  final putcomma = addCommasIndian();

  List<String> hsncodes = <String>['5202', '6006', '5205', '5208', '5206'];
  List<String> gstrates = <String>['5', '12', '18'];

  @override
  void initState() {
    Amount = 0;
    invno.text = (widget.invNo + 1).toString();
    dateInput.text = DateFormat.yMMMMd().format(DateTime.now());
    dueDateInput.text = DateFormat.yMMMMd().format(DateTime.now());

    // FirebaseFirestore.instance.collection('clients').snapshots();
    super.initState();
  }

  Future<void> fetchdetails(String selectedparty) async {
    Query<Map<String, dynamic>> ref = FirebaseFirestore.instance
        .collection('clients')
        .where('name', isEqualTo: selectedparty);

    await ref.get().then((snapshot) {
      snapshot.docs.forEach((element) {
        gstn = element['gstn'];
        print(element['gstn']);
        var Address = element['Address'].values.toList();
        addLin1 = Address[1];
        addLin2 = Address[2];
        pincode = 'Tamilnadu,India - ' + Address[0].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Create Proforma'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 5, bottom: 5),
            //   child: Text(
            //     'Enter Details',
            //     style: TextStyle(fontSize: 20),
            //   ),
            // ),
            Form(
                child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: invno,
                    decoration: InputDecoration(
                      labelText: 'Inv No',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Text('Last Proforma No : ${widget.invNo}'),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: dateInput,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Date",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ), //label text of field
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formatDate =
                            DateFormat.yMMMMd().format(pickedDate);
                        setState(() {
                          dateInput.text = formatDate;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: dueDateInput,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Due Date",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ), //label text of field
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formatDate =
                            DateFormat.yMMMMd().format(pickedDate);
                        setState(() {
                          dueDateInput.text = formatDate;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Client Name',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('clients')
                        .orderBy('name')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List<DropdownMenuItem> parties = [];
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          DocumentSnapshot ds = snapshot.data!.docs[i];

                          parties.add(
                            DropdownMenuItem(
                              value: "${ds['name']!}",
                              child: Text(
                                ds['name']!,
                              ),
                            ),
                          );
                        }
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DropdownButton(
                                borderRadius: BorderRadius.circular(18),
                                alignment: AlignmentDirectional.center,
                                menuMaxHeight: 300,
                                items: parties,
                                onChanged: (value) {
                                  setState(() {
                                    selectedparty = value;
                                  });
                                  fetchdetails(selectedparty);
                                },
                                value: selectedparty,
                                isExpanded: false,
                                hint: Text('Choose Client'),
                              ),
                            ]);
                      }
                    },
                  ),
                  TextFormField(
                    controller: product,
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      hintText: 'Enter Product Detail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(18),
                        value: hsncode,
                        items: hsncodes.map((e) {
                          return DropdownMenuItem(value: e, child: Text(e));
                        }).toList(),

                        onChanged: (String? value) {
                          setState(() {
                            hsncode = value!;
                            // print(hsncode);
                          });
                        },
                        //value: hsncode,
                        isExpanded: false,
                        hint: Text(' Choose HSN'),
                      ),
                      DropdownButton(
                        borderRadius: BorderRadius.circular(18),
                        value: gstRate,
                        items: gstrates.map((e) {
                          return DropdownMenuItem(
                              value: e, child: Text('${e}%'));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            gstRate = value!;
                          });
                        },
                        isExpanded: false,
                        hint: Text(' Choose Gst'),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  TextFormField(
                    scrollPadding: EdgeInsets.only(bottom: 130),
                    keyboardType: TextInputType.number,
                    controller: qty,
                    decoration: InputDecoration(
                      labelText: 'Qty',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        if (val.isEmpty) {
                          quantity = '0';
                        } else {
                          quantity = val;
                        }
                        Amount = double.parse(
                                (double.parse(price) * double.parse(quantity))
                                    .toString())
                            .round();
                      });
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    scrollPadding: EdgeInsets.only(bottom: 110),
                    keyboardType: TextInputType.number,
                    controller: rate,
                    decoration: InputDecoration(
                      labelText: 'Rate',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        if (val.isEmpty) {
                          price = '0';
                        } else {
                          price = val;
                        }
                        Amount = double.parse(
                                (double.parse(price) * double.parse(quantity))
                                    .toString())
                            .round();
                        print(Amount.toString());
                      });
                      // Amount = int.parse(price) * int.parse(quantity);
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Text(
                    Amount.toString(),
                    style: TextStyle(fontSize: 25),
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        //Amount = int.parse(price) * int.parse(quantity);
                        //print(putcomma(Amount));
                        Vibration.vibrate(duration: 100, amplitude: 2);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return pdfgen(
                                invno: invno.text,
                                gstn: gstn.toString(),
                                partyName:
                                    selectedparty.toString().toUpperCase(),
                                line1: addLin1.toUpperCase(),
                                line2: addLin2.toUpperCase(),
                                pin: pincode.toUpperCase(),
                                invDate: dateInput.text,
                                dueDate: dueDateInput.text,
                                product: product.text,
                                qty: quantity,
                                rate: price,
                                amt: putcomma(Amount).toString(),
                                hsn: hsncode,
                                gstr: gstRate,
                                Acamount: Amount.toString(),
                              );
                            },
                          ),
                        );
                      },
                      child: Text('Create'),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
