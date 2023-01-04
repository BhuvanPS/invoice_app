import 'package:add_comma/add_comma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/pdfgen.dart';

class getInvDetails extends StatefulWidget {
  const getInvDetails({Key? key}) : super(key: key);

  @override
  State<getInvDetails> createState() => _getInvDetailsState();
}

class _getInvDetailsState extends State<getInvDetails> {
  var selectedparty;
  late String gstn = '';
  late String addLin1 = '';
  late String addLin2 = '';
  late String pincode = '';
  String hsncode = '5205';
  late String gstRate = '5';
  late String price = '';
  late String quantity = '';
  late int Amount;
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
    dateInput.text = DateFormat.yMMMMd().format(DateTime.now());
    dueDateInput.text = DateFormat.yMMMMd().format(DateTime.now());
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
      appBar: AppBar(
        title: Text('Create Proforma'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Enter Details',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Form(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: invno,
                    decoration: InputDecoration(labelText: 'Inv No'),
                  ),
                  TextFormField(
                    controller: dateInput,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
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
                  TextFormField(
                    controller: dueDateInput,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('clients')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              child: Text(
                                ds.get('name'),
                              ),
                              value: "${ds.get('name')}",
                            ),
                          );
                        }
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Client Name',
                                style: TextStyle(fontSize: 16),
                              ),
                              DropdownButton(
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
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton(
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
                    keyboardType: TextInputType.number,
                    controller: qty,
                    decoration: InputDecoration(labelText: 'Qty'),
                    onChanged: (val) {
                      setState(() {
                        quantity = val;
                      });
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: rate,
                    decoration: InputDecoration(labelText: 'Rate'),
                    onChanged: (val) {
                      setState(() {
                        price = val;
                      });
                    },
                  ),

                  TextButton(
                    onPressed: () {
                      Amount = int.parse(price) * int.parse(quantity);
                      //print(putcomma(Amount));
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return pdfgen(
                              invno: invno.text,
                              gstn: gstn.toString(),
                              partyName: selectedparty.toString().toUpperCase(),
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
                    child: Text('Proceed'),
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
