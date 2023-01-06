import 'dart:typed_data';

import 'package:add_comma/add_comma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:inventory/pdfout.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:vibration/vibration.dart';

class pdfgen extends StatefulWidget {
  late final String invno;
  late final String gstn;
  late final String line1;
  late final String line2;
  late final String pin;
  late final String partyName;
  late final String invDate;
  late final String dueDate;
  late final String product;
  late final String hsn;
  late final String gstr;
  late final String qty;
  late final String rate;
  late final String amt;
  late final String Acamount;

  pdfgen(
      {required this.invno,
      required this.gstn,
      required this.line1,
      required this.line2,
      required this.pin,
      required this.partyName,
      required this.dueDate,
      required this.invDate,
      required this.qty,
      required this.rate,
      required this.amt,
      required this.gstr,
      required this.hsn,
      required this.product,
      required this.Acamount});

  @override
  State<pdfgen> createState() => _pdfgenState();
}

class _pdfgenState extends State<pdfgen> {
  int saveCount = 0;
  Future<void> uploadingData(
    String invno,
    String invdate,
    String dueDate,
    String gstn,
    String partyname,
    String gstr,
    String rate,
    String qty,
    String Acamount,
  ) async {
    double getAmt = double.parse(Acamount);
    int gstAmt = (((double.parse(gstr)) / 200) * getAmt).round();
    int totalamt = getAmt.round() + (gstAmt * 2).round();
    await FirebaseFirestore.instance.collection("proformaInvoices").add({
      'invno': int.parse(invno),
      'invDate': invdate,
      'dueDate': dueDate,
      'BilledTo': partyname,
      'gstn': gstn,
      'Quantity': qty,
      'Rate': rate,
      'Amount': getAmt,
      'SGST': gstAmt,
      'CGST': gstAmt,
      'TotalAmount': totalamt,
    }).then((value) {
      FirebaseFirestore.instance
          .collection('proformaInvoices')
          .doc(value.id)
          .update({'docId': value.id});
    });
    print('ADded');
  }

  final putComma = addCommasIndian();
  Future<void> _createPDF(
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
      String Acamount) async {
    double getAmt = double.parse(Acamount);
    int gstAmt = (((double.parse(gstr)) / 200) * getAmt).round();
    int totalamt = getAmt.round() + (gstAmt * 2).round();
    var finalgst = putComma(gstAmt);
    var finTotAmt = putComma(totalamt);
    var wordamt = (NumberToWord().convert('en-in', totalamt)).toUpperCase();
    //Create a new PDF document
    PdfDocument document = PdfDocument();
    document.pageSettings.size = PdfPageSize.a4;
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
      '1. Please pay within 15 days from the date of invoice, overdue interest @ 24% will be charged on delayed payments.',
      PdfStandardFont(PdfFontFamily.timesRoman, 12),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(13, 680, 0, 0),
    );

    page.graphics.drawString(
      '2. Please quote proforma invoice number when remitting funds.',
      PdfStandardFont(PdfFontFamily.timesRoman, 12),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(13, 700, 0, 0),
    );

    page.graphics.drawString(
      'For any enquiry, reach out via email at sharathagencies1977@gmail.com, call on +91 99421 08878',
      PdfStandardFont(PdfFontFamily.timesRoman, 10, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(45, 735, 0, 0),
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

    page.graphics.drawLine(PdfPen(PdfColor(0, 0, 0), width: 3),
        Offset(336, 412), Offset(506, 412));

    page.graphics.drawString(
      'Total(INR)',
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(337, 417, 0, 0),
    );
    page.graphics.drawString(
      '₹${finTotAmt}',
      font1,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(433, 417, 0, 0),
    );
    page.graphics.drawString(
      'Total in Words : ${wordamt} Only',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(15, 469, 0, 0),
    );
    page.graphics.drawLine(PdfPen(PdfColor(0, 0, 0), width: 3),
        Offset(336, 438), Offset(506, 438));
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
        appBar: AppBar(),
        body: Column(
          children: [
            Text(widget.amt),
            Text('GST' +
                ((int.parse(widget.Acamount)) *
                        (double.parse(widget.gstr)) /
                        100)
                    .toString()),
            Text('TOTAL : ' +
                ((int.parse(widget.Acamount)) +
                        ((int.parse(widget.Acamount)) *
                            (double.parse(widget.gstr)) /
                            100))
                    .toString()),
            Center(
                child: TextButton(
                    onPressed: () {
                      _createPDF(
                          widget.invno,
                          widget.gstn,
                          widget.line1,
                          widget.line2,
                          widget.pin,
                          widget.partyName,
                          widget.invDate,
                          widget.dueDate,
                          widget.product,
                          widget.hsn,
                          widget.gstr,
                          widget.qty,
                          widget.rate,
                          widget.amt,
                          widget.Acamount);
                    },
                    child: Text('Create PDF'))),
            Center(
              child: TextButton(
                onPressed: () async {
                  if (saveCount == 0) {
                    uploadingData(
                      widget.invno,
                      widget.invDate,
                      widget.dueDate,
                      widget.gstn,
                      widget.partyName,
                      widget.gstr,
                      widget.rate,
                      widget.qty,
                      widget.Acamount,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Row(
                        children: [
                          Text('Added Successfully '),
                          Icon(
                            Icons.done_outlined,
                            color: Colors.green,
                          )
                        ],
                      )),
                    );
                    setState(() {
                      saveCount = 1;
                    });
                  } else {
                    //check if device has vibration feature
                    Vibration.vibrate(); //500 millisecond vibration

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Already Saved'),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ));
  }
}
