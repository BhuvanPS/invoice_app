import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addClient extends StatefulWidget {
  const addClient({Key? key}) : super(key: key);

  @override
  State<addClient> createState() => _addClientState();
}

class _addClientState extends State<addClient> {
  late String _name = "";
  late String _gstn = "";
  late String _line1 = "";
  late String _line2 = "";
  late String _pin = "";
  String sub = 'Cant Submit';
  late bool verified = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController gstnController = TextEditingController();
  TextEditingController phnoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> uploadingData(
    String _name,
    String _gstn,
  ) async {
    await FirebaseFirestore.instance.collection("clients").add({
      'name': _name.toUpperCase(),
      'gstn': _gstn,
      'Address': {
        'Line1': _line1,
        'Line2': _line2,
        'pincode': _pin,
      },
    }).then((value) {
      FirebaseFirestore.instance
          .collection('clients')
          .doc(value.id)
          .update({'docId': value.id});
    });
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() {
        verified = false;
        sub = 'Cant Update';
      });
      return;
    } else {
      _formKey.currentState!.save();
      FocusManager.instance.primaryFocus?.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verified Press Submit')),
      );
      //verified = true;
      setState(() {
        verified = true;
        sub = 'Submit';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Enter Customer Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                        _name = value!;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 15,
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        labelText: 'GST Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                      onFieldSubmitted: (value) {},
                      validator: (value) {
                        RegExp regex = RegExp(
                            r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
                        if (value!.length < 15 || !regex.hasMatch(value!)) {
                          return 'Incorrect';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _gstn = value!;
                      },
                    ),
                    Text(
                      '  Address',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 34,
                      decoration: InputDecoration(
                        labelText: 'Line 1',
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
                        _line1 = value!;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 34,
                      decoration: InputDecoration(
                        labelText: 'Line 2',
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
                        _line2 = value!;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Pincode',
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
                        _pin = value!;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => _submit(),
                        child: Text('Verify'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blueGrey),
              onPressed: verified
                  ? () {
                      uploadingData(_name, _gstn);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data Added')),
                      );
                      print(_name + _gstn);
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Verify First')),
                      );
                    },
              child: Text(sub),
            ),
          ],
        ),
      ),
    );
  }
}
