import 'package:flutter/material.dart';
import 'package:inventory/proformaInvoice/ProformaInvoice.dart';
import 'package:inventory/proformaInvoice/proinfo.dart';

class viewProforma extends StatefulWidget {
  @override
  State<viewProforma> createState() => _viewProformaState();
}

class _viewProformaState extends State<viewProforma> {
  late ProformaInvoices proformaInvoices;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  ScrollController controller = ScrollController();
  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    super.initState();
    proformaInvoices = ProformaInvoices();
    proformaInvoices.fetchFirstList();
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      proformaInvoices.fetchNextDocuments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202020),
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          'Proforma Invoices',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF202020),
      ),
      body: StreamBuilder(
        stream: proformaInvoices.proformaStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            controller: controller,
            itemBuilder: (context, index) {
              return proinfo(
                invno: snapshot.data![index]['invno'],
                partyname: snapshot.data![index]['BilledTo'],
                docId: snapshot.data![index]['docId'],
                product: snapshot.data![index]['product'],
                invDate: snapshot.data![index]['invDate'],
                dueDate: snapshot.data![index]['dueDate'],
                hsn: snapshot.data![index]['hsn'],
                qty: snapshot.data![index]['Quantity'],
                rate: snapshot.data![index]['Rate'],
                exmill: snapshot.data![index]['Amount'],
                sgst: snapshot.data![index]['SGST'],
                cgst: snapshot.data![index]['CGST'],
                total: snapshot.data![index]['TotalAmount'],
              );
            },
          );
        },
      ),
    );
  }
}
