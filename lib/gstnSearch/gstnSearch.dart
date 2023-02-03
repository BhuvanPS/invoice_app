import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class gstnSearch extends StatefulWidget {
  const gstnSearch({Key? key}) : super(key: key);

  @override
  State<gstnSearch> createState() => _gstnSearchState();
}

class _gstnSearchState extends State<gstnSearch> {
  TextEditingController gstnumber = TextEditingController();
  late Map<String, dynamic> data;
  late bool SearchStatus = false;
  late String tradeName = "";
  late String legalName = "";
  //late String rcvdgst = "";
  late String address = "";
  late String category = "";
  late String pincode = "";
  late bool success = true;
  bool isDetailsAvailable = false;
  bool isbuttonClicked = false;

  late partyDetail partyObject;

  Future getData(String gstn) async {
    http.Response response = await http.get(Uri.parse(
        "https://blog-backend.mastersindia.co/api/v1/custom/search/gstin/?keyword=${gstn}&unique_id=lakooAPaMfFDtWwaOfqt5yDaA9tfthfvvfuj4t"));
    //print(response.body);
    data = json.decode(response.body);
    partyObject = partyDetail(
        tradename: data['data']['tradeNam'],
        legalname: data['data']['lgnm'],
        doorno: data['data']['pradr']['addr']['bno'],
        adlin1: data['data']['pradr']['addr']['bnm'],
        street: data['data']['pradr']['addr']['st'],
        location: data['data']['pradr']['addr']['loc'],
        category: data['data']['ctb'],
        pincode: data['data']['pradr']['addr']['pncd'],
        success: data['success']);

    setState(() {
      isDetailsAvailable = true;
      success = partyObject.success;
      if (success) {
        tradeName = partyObject.tradename.toString();
        legalName = partyObject.legalname.toString();
        address = partyObject.doorno.toString() +
            ' ' +
            partyObject.adlin1.toString() +
            ' ' +
            partyObject.street.toString() +
            ' ' +
            partyObject.location.toString();
        category = partyObject.category;
        pincode = partyObject.pincode;
      }
    });
    //print(tradeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gst Search'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  icon: Icon(Icons.search),
                  labelText: 'Enter Gst'),
              controller: gstnumber,
            ),
            ElevatedButton(
              onPressed: () {
                //print(gstnumber.text);
                getData(gstnumber.text.trim());
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  isbuttonClicked = true;
                });
              },
              child: Text('Search'),
            ),
            if (isbuttonClicked &
                !isDetailsAvailable &
                gstnumber.text.isNotEmpty)
              Container(
                child: CircularProgressIndicator(),
              ),
            if (isDetailsAvailable)
              Container(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(18)),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: Text('Trade name ' + tradeName),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(18)),
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        child: Text('Legal Name ' + legalName)),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(18)),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: Text(
                        'Address: ${address}',
                        maxLines: 2,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(18)),
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        child: Text('Category ' + category)),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(18)),
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        child: Text('PinCode ' + pincode))
                  ],
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class partyDetail {
  final String tradename;
  final String legalname;
  final String doorno;
  final String adlin1;
  final String street;
  final String location;
  final String category;
  final String pincode;
  final bool success;

  partyDetail(
      {required this.tradename,
      required this.legalname,
      required this.doorno,
      required this.adlin1,
      required this.street,
      required this.location,
      required this.category,
      required this.pincode,
      required this.success});
}
