import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory/initialise.dart';
import 'package:inventory/viewProforma.dart';

import './getInvDetails.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Sharath Agencies'),
            ),
            ListTile(
              title: Text('Clients'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return initialise();
                    },
                  ),
                );
                //
              },
            ),
            ListTile(
              title: Text('PDF'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return getInvDetails();
                    },
                  ),
                );
                //
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: TextButton(
          child: Text('View All Proforma'),
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return viewProforma();
            }));
          },
        ),
      ),
    );
  }
}
