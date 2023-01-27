import 'package:flutter/material.dart';
import 'package:inventory/initialise.dart';
import 'package:inventory/viewProforma.dart';
import 'package:vibration/vibration.dart';

import './getInvDetails.dart';
import './gstnSearch/gstnSearch.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: selectedIndex,
      //   onTap: (x) {
      //     setState(() {
      //       selectedIndex = x;
      //     });
      //   },
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search')
      //   ],
      // ),
      drawer: Drawer(
        child: Column(
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
            Expanded(
                child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                title: Text('About Us'),
              ),
            ))
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('View All Proforma'),
              onPressed: () {
                Vibration.vibrate(duration: 200);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return viewProforma();
                }));
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return gstnSearch();
                  }));
                },
                child: Text('Search Gstn'))
          ],
        ),
      ),
    );
  }
}
