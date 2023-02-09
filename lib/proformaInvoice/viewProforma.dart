import 'package:flutter/material.dart';
import 'package:inventory/proformaInvoice/ProformaInvoice.dart';
import 'package:inventory/proformaInvoice/proinfo.dart';

class viewProforma extends StatefulWidget {
  @override
  State<viewProforma> createState() => _viewProformaState();
}

class _viewProformaState extends State<viewProforma> {
  late ProformaInvoices proformaInvoices;
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    proformaInvoices = ProformaInvoices();
    proformaInvoices.fetchFirstList();
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      proformaInvoices.fetchNextMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proforma Invoices'),
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
              );
            },
          );
        },
      ),
    );
  }
}
