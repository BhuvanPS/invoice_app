import 'dart:typed_data';

import 'package:add_comma/add_comma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:inventory/proformaInvoice/pdfout.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class proformaDetail extends StatefulWidget {
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
  proformaDetail(
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
  State<proformaDetail> createState() => _proformaDetailState();
}

class _proformaDetailState extends State<proformaDetail> {
  late String gstn = '';
  late String addLin1 = '';
  late String addLin2 = '';
  late String pincode = '';

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
    print('success');
  }

  Future<void> createPDF(
    String invno,
    String gstn,
    String partyline1,
    String partyline2,
    String partypin,
    String partyname,
    String invDate,
    String dueDate,
    String product,
    String hsn,
    String gstr,
    String qty,
    String rate,
    String amount,
    String Acamount,
    bool tcs,
  ) async {
    final putComma = addCommasIndian();
    double getAmt = double.parse(Acamount);
    int gstAmt = (((double.parse(gstr)) / 200) * getAmt).round();
    int totalamt = getAmt.round() + (gstAmt * 2).round();
    var finalgst = putComma(gstAmt);
    var finTotAmt = putComma(totalamt);
    var wordamt = (NumberToWord().convert('en-in', totalamt)).toUpperCase();
    double tcsAmt = getAmt * 0.001;
    double extraHeight = 0;
    if (tcs) {
      totalamt = getAmt.round() + (gstAmt * 2).round() + tcsAmt.round();
      wordamt = (NumberToWord().convert('en-in', totalamt)).toUpperCase();
      extraHeight = 17;
      finTotAmt = putComma(totalamt);
    }
    //Create a new PDF document
    PdfDocument document = PdfDocument();
    document.pageSettings.size = PdfPageSize.a4;
    //document.pageSettings.margins = PdfMargins();
    document.pageSettings.setMargins(40, 40, 40, 30);
    final page = document.pages.add();

    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(239, 234, 248),
      ),
      bounds: Rect.fromLTWH(0, 520, 295, 125),
    );

    page.graphics.drawString(
      'Bank Details',
      PdfStandardFont(
        PdfFontFamily.timesRoman,
        15,
      ),
      brush: PdfBrushes.mediumPurple,
      bounds: Rect.fromLTWH(10, 527, 0, 0),
    );
    page.graphics.drawString(
      'Account Holder Name',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(15, 550, 0, 0),
    );
    page.graphics.drawString(
      'SHARATH AGENCIES',
      PdfStandardFont(
        PdfFontFamily.helvetica,
        11,
      ),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(150, 550, 0, 0),
    );

    page.graphics.drawString(
      'Account Number',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(15, 570, 0, 0),
    );

    page.graphics.drawString(
      '0338073000001735',
      PdfStandardFont(
        PdfFontFamily.helvetica,
        11,
      ),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(150, 570, 0, 0),
    );
    page.graphics.drawString(
      'IFSC',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(15, 590, 0, 0),
    );
    page.graphics.drawString(
      'SIBL0000338',
      PdfStandardFont(PdfFontFamily.helvetica, 11),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(150, 590, 0, 0),
    );
    page.graphics.drawString(
      'Bank',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(15, 610, 0, 0),
    );
    page.graphics.drawString(
      'SOUTH INDIAN BANK LTD',
      PdfStandardFont(PdfFontFamily.helvetica, 11),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(150, 610, 0, 0),
    );

    page.graphics.drawString(
      'Terms and Conditions',
      PdfStandardFont(
        PdfFontFamily.timesRoman,
        15,
      ),
      brush: PdfBrushes.mediumPurple,
      bounds: Rect.fromLTWH(10, 660, 0, 0),
    );

    page.graphics.drawString(
      '1. Please pay within 15 days from the date of invoice, overdue interest @ 24% will be charged on ',
      PdfStandardFont(PdfFontFamily.timesRoman, 12),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(13, 680, 0, 0),
    );
    page.graphics.drawString(
      '   delayed payments.',
      PdfStandardFont(PdfFontFamily.timesRoman, 12),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(13, 700, 0, 0),
    );

    page.graphics.drawString(
      '2. Please quote proforma invoice number when remitting funds.',
      PdfStandardFont(PdfFontFamily.timesRoman, 12),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(13, 720, 0, 0),
    );

    page.graphics.drawString(
      'For any enquiry, reach out via email at sharathagencies1977@gmail.com, call on +91 99421 08878',
      PdfStandardFont(PdfFontFamily.timesRoman, 10, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(45, 745, 0, 0),
    );

    page.graphics.drawString(
      'Invoice No',
      PdfStandardFont(PdfFontFamily.timesRoman, 14, style: PdfFontStyle.bold),
      brush: PdfBrushes.mediumPurple,
      bounds: Rect.fromLTWH(10, 45, 0, 0),
    );

    page.graphics.drawString(
      invno,
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(95, 45, 0, 0),
    );

    page.graphics.drawString(
      'Invoice Date',
      PdfStandardFont(PdfFontFamily.timesRoman, 14, style: PdfFontStyle.bold),
      brush: PdfBrushes.mediumPurple,
      bounds: Rect.fromLTWH(10, 70, 0, 0),
    );
    page.graphics.drawString(
      invDate,
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(95, 70, 0, 0),
    );
    page.graphics.drawString(
      'Due Date',
      PdfStandardFont(PdfFontFamily.timesRoman, 14, style: PdfFontStyle.bold),
      brush: PdfBrushes.mediumPurple,
      bounds: Rect.fromLTWH(10, 95, 0, 00),
    );
    page.graphics.drawString(
      dueDate,
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(95, 95, 0, 0),
    );

    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(239, 234, 248),
      ),
      bounds: Rect.fromLTWH(5, 120, 258, 125),
    );
    page.graphics.drawString(
      'Billed By',
      PdfStandardFont(
        PdfFontFamily.timesRoman,
        15,
      ),
      brush: PdfBrushes.purple,
      bounds: Rect.fromLTWH(10, 125, 0, 0),
    );
    page.graphics.drawString(
      'SHARATH AGENCIES',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(10, 145, 0, 0),
    );
    page.graphics.drawString(
      '3/1A KANDHASAMY LAYOUT 2ND STREET',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(10, 165, 0, 0),
    );
    page.graphics.drawString(
      'PITCHAMPALYAM,TIRUPUR',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(10, 185, 0, 0),
    );
    page.graphics.drawString(
      'TAMILNADU, INDIA-641603',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(10, 205, 0, 0),
    );
    page.graphics.drawString(
      'GSTIN :',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(10, 225, 0, 0),
    );
    page.graphics.drawString(
      '33BBRPC7592Q1ZS',
      PdfStandardFont(PdfFontFamily.helvetica, 11),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(62, 225, 0, 0),
    );
    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(239, 234, 248),
      ),
      bounds: Rect.fromLTWH(272, 120, 261, 125),
    );
    page.graphics.drawString(
      'Billed To',
      PdfStandardFont(
        PdfFontFamily.timesRoman,
        15,
      ),
      brush: PdfBrushes.purple,
      bounds: Rect.fromLTWH(282, 125, 0, 0),
    );
    page.graphics.drawString(
      partyname,
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(282, 145, 0, 0),
    );
    page.graphics.drawString(
      partyline1,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(282, 165, 0, 0),
    );
    page.graphics.drawString(
      partyline2,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(282, 185, 0, 0),
    );
    page.graphics.drawString(
      partypin,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(282, 205, 0, 0),
    );
    page.graphics.drawString(
      'GSTIN :',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(282, 225, 0, 0),
    );
    page.graphics.drawString(
      gstn,
      PdfStandardFont(PdfFontFamily.helvetica, 11),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(335, 225, 0, 0),
    );

    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(100, 56, 190),
      ),
      bounds: Rect.fromLTWH(5, 255, 520, 50),
    );
    page.graphics.drawString(
      'Description',
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(15, 272, 0, 0),
    );
    PdfFont font = PdfTrueTypeFont(await _readFontData(), 11);
    PdfFont font1 = PdfTrueTypeFont(await _readFontData(), 13);

    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(239, 234, 248),
      ),
      bounds: Rect.fromLTWH(5, 305, 150, 50),
    );
    page.graphics.drawString(
      product,
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(15, 322, 0, 0),
    );
    page.graphics.drawString(
      'HSN',
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(170, 272, 0, 0),
    );
    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(239, 234, 248),
      ),
      bounds: Rect.fromLTWH(156, 305, 49, 50),
    );

    page.graphics.drawString(
      hsn,
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(165, 322, 0, 0),
    );
    page.graphics.drawString(
      'GST',
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(215, 272, 0, 0),
    );
    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(239, 234, 248),
      ),
      bounds: Rect.fromLTWH(206, 305, 40, 50),
    );
    page.graphics.drawString(
      '${gstr}%',
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(216, 322, 0, 0),
    );
    page.graphics.drawString(
      'Quantity',
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(263, 263, 0, 0),
    );
    page.graphics.drawString(
      '(KGS)',
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(268, 278, 0, 0),
    );
    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(239, 234, 248),
      ),
      bounds: Rect.fromLTWH(247, 305, 75, 50),
    );
    page.graphics.drawString(
      qty,
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(270, 322, 0, 0),
    );
    page.graphics.drawString(
      'Rate',
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(343, 272, 0, 0),
    );
    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(239, 234, 248),
      ),
      bounds: Rect.fromLTWH(323, 305, 60, 50),
    );
    page.graphics.drawString(
      '₹${rate}',
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(337, 322, 0, 0),
    );
    page.graphics.drawString(
      'Amount',
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(435, 272, 0, 0),
    );
    page.graphics.drawRectangle(
      brush: PdfSolidBrush(
        PdfColor(239, 234, 248),
      ),
      bounds: Rect.fromLTWH(384, 305, 150, 50),
    );
    page.graphics.drawString(
      '₹${amount}',
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(430, 322, 0, 0),
    );

    page.graphics.drawString(
      '₹${finalgst}',
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(450, 372, 0, 0),
    );
    page.graphics.drawString(
      '₹${finalgst}',
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(450, 392, 0, 0),
    );

    page.graphics.drawString(
      'SGST   ${((double.parse(gstr)) / 2).toStringAsFixed(1)}%',
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(337, 372, 0, 0),
    );
    page.graphics.drawString(
      'CGST   ${((double.parse(gstr)) / 2).toStringAsFixed(1)}%',
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(337, 392, 0, 0),
    );
    if (tcs) {
      page.graphics.drawString(
        'TCS     0.1%',
        font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(337, 392 + extraHeight, 0, 0),
      );
      page.graphics.drawString(
        '₹${tcsAmt.toStringAsFixed(0)}',
        font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(450, 392 + extraHeight, 0, 0),
      );
    }

    page.graphics.drawLine(PdfPen(PdfColor(0, 0, 0), width: 3),
        Offset(336, 412 + extraHeight), Offset(506, 412 + extraHeight));

    page.graphics.drawString(
      'Total(INR)',
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(337, 417 + extraHeight, 0, 0),
    );
    page.graphics.drawString(
      '₹${finTotAmt}',
      font1,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(433, 417 + extraHeight, 0, 0),
    );
    page.graphics.drawString(
      'Total in Words : ${wordamt} Only',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(15, 469, 0, 0),
    );
    page.graphics.drawLine(PdfPen(PdfColor(0, 0, 0), width: 3),
        Offset(336, 438 + extraHeight), Offset(506, 438 + extraHeight));
    page.graphics.drawImage(
      PdfBitmap(await _readImageData('sign.jpg')),
      Rect.fromLTWH(360, 520, 130, 100),
    );
    //Add a new page and draw text
    page.graphics.drawString(
      'Proforma Invoice',
      PdfStandardFont(PdfFontFamily.helvetica, 25),
      brush: PdfBrushes.darkViolet,
      bounds: Rect.fromLTWH(5, 0, 0, 0),
    );

    page.graphics.drawString(
        'Authorised Signatory', PdfStandardFont(PdfFontFamily.timesRoman, 12),
        brush: PdfBrushes.black, bounds: Rect.fromLTWH(370, 610, 0, 0));

    //Save the document
    List<int> bytes = await document.save();

    //Dispose the document
    document.dispose();

    saveAndLaunch(bytes, 'proforma-inv${invno}.pdf');
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<List<int>> _readFontData() async {
    final ByteData bytes = await rootBundle.load('fonts/arial.ttf');
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
          actions: [
            IconButton(
              onPressed: () async {
                await fetchdetails(widget.partyname);
                final putComma = addCommasIndian();
                num gstr = ((widget.sgst / widget.exmill) * 200).ceil();

                createPDF(
                    widget.invno.toString(),
                    gstn,
                    addLin1,
                    addLin2,
                    pincode,
                    widget.partyname,
                    widget.invDate,
                    widget.dueDate,
                    widget.product,
                    widget.hsn,
                    gstr.toString(),
                    widget.qty.toString(),
                    widget.rate.toString(),
                    putComma(widget.exmill.ceil()).toString(),
                    widget.exmill.toString(),
                    widget.tcs);
              },
              icon: Icon(Icons.print),
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Client Name : ' + widget.partyname,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Invoice No : ' + widget.invno.toString(),
                            style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Product : ' + widget.product,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Date : ' + widget.invDate,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Hsn Code : ' + widget.hsn,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Quantity : ' + widget.qty.toString() + ' Kgs',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Rate : ₹ ' + widget.rate.toString() + '/kg',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Ex-mill : ₹ ' + widget.exmill.toString(),
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'SGST : ₹ ${widget.sgst}',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'CGST : ₹ ${widget.cgst}',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Total Gst : ₹ ${widget.sgst * 2}',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(width: 2),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Bill Amount :  ₹ ' + widget.total.toString(),
                              style: TextStyle(fontSize: 21),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        // body: Center(
        //   child: FutureBuilder<DocumentSnapshot>(
        //     future: FirebaseFirestore.instance
        //         .collection('proformaInvoices')
        //         .doc(widget.docId.trim())
        //         .get(),
        //     builder:
        //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //       //Error Handling conditions
        //       if (snapshot.hasError) {
        //         return Text("Something went wrong");
        //       }
        //
        //       if (snapshot.hasData && !snapshot.data!.exists) {
        //         return Text("Document does not exist");
        //       }
        //
        //       //Data is output to the user
        //       if (snapshot.connectionState == ConnectionState.done) {
        //         //Future.delayed(Duration(seconds: 10));
        //         Map<String, dynamic> data =
        //             snapshot.data!.data() as Map<String, dynamic>;
        //         return SingleChildScrollView(
        //           scrollDirection: Axis.vertical,
        //           child: Column(
        //             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Center(
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                     color: Colors.yellow[100],
        //                     borderRadius: BorderRadius.circular(12),
        //                   ),
        //                   padding: const EdgeInsets.all(15),
        //                   child: Text(
        //                     'Client Name : ' + data['BilledTo'],
        //                     style: TextStyle(fontSize: 20),
        //                   ),
        //                 ),
        //               ),
        //               Center(
        //                 child: Column(
        //                   //crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Container(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                           'Invoice No : ' + data['invno'].toString(),
        //                           style: TextStyle(fontSize: 20)),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                         'Product : ' + data['product'],
        //                         style: TextStyle(fontSize: 17),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                         'Date : ' + data['invDate'].toString(),
        //                         style: TextStyle(fontSize: 17),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                         'Hsn Code : ' + data['hsn'],
        //                         style: TextStyle(fontSize: 17),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                         'Quantity : ' +
        //                             data['Quantity'].toString() +
        //                             ' Kgs',
        //                         style: TextStyle(
        //                             fontSize: 17, fontWeight: FontWeight.bold),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                         'Rate : ₹ ' + data['Rate'].toString() + '/kg',
        //                         style: TextStyle(
        //                             fontSize: 17, fontWeight: FontWeight.bold),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                         'Ex-mill : ₹ ' + data['Amount'].toString(),
        //                         style: TextStyle(fontSize: 17),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                         'SGST : ₹ ${data['SGST']}',
        //                         style: TextStyle(fontSize: 17),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                         'CGST : ₹ ${data['SGST']}',
        //                         style: TextStyle(fontSize: 17),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Text(
        //                         'Total Gst : ₹ ${data['SGST'] * 2}',
        //                         style: TextStyle(fontSize: 17),
        //                       ),
        //                     ),
        //                     Center(
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(10.0),
        //                         child: Container(
        //                           decoration: BoxDecoration(
        //                             borderRadius: BorderRadius.circular(12),
        //                             border: Border.all(width: 2),
        //                           ),
        //                           padding: const EdgeInsets.all(8.0),
        //                           child: Text(
        //                             'Bill Amount :  ₹ ' +
        //                                 data['TotalAmount'].toString(),
        //                             style: TextStyle(fontSize: 21),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //         // return Text("Full Name: ${data['BilledTo']} ${data['Quantity']}");
        //       }
        //
        //       return CircularProgressIndicator(
        //         backgroundColor: Colors.redAccent,
        //         valueColor: AlwaysStoppedAnimation(Colors.green),
        //         strokeWidth: 10,
        //       );
        //     },
        //   ),
        // ),
        );
  }
}
