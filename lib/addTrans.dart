import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class addTrans extends StatefulWidget {
  final String id;
  final String name;
  addTrans({required this.id, required this.name});

  @override
  State<addTrans> createState() => _addTransState();
}

class _addTransState extends State<addTrans> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController dateController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  DateTime tDate = DateTime.now();

  late String amt = '';
  var typeofPayment;
  late String des = '';

  @override
  void initState() {
    dateController.text = DateFormat.yMMMMd().format(DateTime.now());
    timeController.text = DateFormat.jms().format(DateTime(
        tDate.year,
        tDate.month,
        tDate.day,
        TimeOfDay.now().hour,
        TimeOfDay.now().minute,
        0));

    // FirebaseFirestore.instance.collection('clients').snapshots();
    super.initState();
  }

  Future sendAlertMail(String content) async {
    // await GoogleSignIn().signOut();
    // print("hiiiiii");
    // return;

    late var user;

    user = await GoogleSignIn(scopes: ['https://mail.google.com/']).signIn();

    // if (user == null) return;
    final email = user.email;
    print(email);
    final auth = await user.authentication;
    print(email);
    final token = auth.accessToken;
    final smtpServer = gmailSaslXoauth2(email, token);

    final message = Message()
      ..from = Address(email, 'SHARATH AGENCIES')
      ..recipients = ['psbhuvan2002@gmail.com']
      ..subject = 'Transaction Alert'
      ..text = content;

    await send(message, smtpServer);
    print('Sent');
    //return SnackBar(content: Text('Success'));
  }

  Future<void> uploadingData(
    String amt,
    String id,
  ) async {
    await FirebaseFirestore.instance.collection("transactions").add({
      'partyId': id,
      'Amount': int.parse(amt),
      'type': typeofPayment,
      'Date': tDate,
      'Description': des,
      'partyName': widget.name
    }).then((value) => FirebaseFirestore.instance
        .collection('transactions')
        .doc(value.id)
        .update({'transactionId': value.id}));
    var content;
    if (typeofPayment == 'credit') {
      content =
          'Payment of INR ${int.parse(amt)} credited to your Account from ${widget.name} at ${DateFormat.yMMMMd().format(tDate) + ' ' + DateFormat.jms().format(tDate)}\n'
          'Description provided for the transaction ${des}';
    } else {
      content =
          'Products/Invoice with a  value of INR ${int.parse(amt)} has been debited at ${DateFormat.yMMMMd().format(tDate) + ' ' + DateFormat.jms().format(tDate)}\n'
          'Description provided for the transaction ${des}';
    }
    //sendAlertMail(content);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Text('Transaction Added'),
        duration: Duration(milliseconds: 750),
      ),
    );
    Timer(Duration(milliseconds: 1200), () {
      Navigator.of(context).pop();
    });
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      _formKey.currentState!.save();
      FocusManager.instance.primaryFocus?.unfocus();
      uploadingData(amt, widget.id.trim());

      //verified = true;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Record'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: amount,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  onFieldSubmitted: (value) {},
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return 'Enter Text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    amt = value!;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Radio(
                        value: 'debit',
                        groupValue: typeofPayment,
                        onChanged: (value) {
                          setState(() {
                            typeofPayment = value!;
                          });
                        }),
                    Text('Debit'),
                    new Radio(
                        value: 'credit',
                        groupValue: typeofPayment,
                        onChanged: (value) {
                          setState(() {
                            typeofPayment = value!;
                          });
                          print(typeofPayment);
                        }),
                    Text('Credit'),
                  ],
                ),
                TextFormField(
                  controller: description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  onFieldSubmitted: (value) {},
                  validator: (value) {
                    // if (value!.isEmpty || value == null) {
                    //   return 'Enter Text';
                    // }
                    return null;
                  },
                  onSaved: (value) {
                    des = value!;
                  },
                ),
                Container(
                  //color: Colors.yellow[100],
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Enter Date" //label text of field
                            ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));
                          print(pickedDate.toString());
                          if (pickedDate != null) {
                            tDate = pickedDate;

                            String formatDate =
                                DateFormat.yMMMMd().format(pickedDate);
                            setState(() {
                              dateController.text = formatDate;
                            });
                          }
                        },
                      ),
                      TextFormField(
                        controller: timeController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Time" //label text of field
                            ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (pickedTime != null) {
                            tDate = DateTime(tDate.year, tDate.month, tDate.day,
                                pickedTime.hour, pickedTime.minute, 0);
                            setState(() {
                              timeController.text =
                                  DateFormat.jm().format(tDate);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text('Add'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
