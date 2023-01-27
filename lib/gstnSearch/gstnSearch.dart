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
  late String rcvdgst = "";
  late String address = "";
  late String category = "";
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
        pincode: data['data']['pradr']['addr']['pncd']);

    setState(() {
      isDetailsAvailable = true;
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
    });
    //print(tradeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gst Search'),
      ),
      body: Container(
        child: Column(children: [
          TextField(
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
          if (isbuttonClicked & !isDetailsAvailable & gstnumber.text.isNotEmpty)
            Container(
              child: CircularProgressIndicator(),
            ),
          if (isDetailsAvailable)
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Trade name ' + tradeName),
                  Text('Legal Name ' + legalName),
                  Text(
                    'Address: ${address}',
                    maxLines: 2,
                  ),
                  Text('Category' + category),
                ],
              ),
            )
        ]),
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

  partyDetail(
      {required this.tradename,
      required this.legalname,
      required this.doorno,
      required this.adlin1,
      required this.street,
      required this.location,
      required this.category,
      required this.pincode});
}
