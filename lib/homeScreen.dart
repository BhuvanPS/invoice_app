import 'package:flutter/material.dart';
import 'package:inventory/initialise.dart';
import 'package:inventory/kcbill/kcbill.dart';
import 'package:inventory/viewProforma.dart';

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
        // body: Center(
        //   child: Column(
        //     children: [
        //       ElevatedButton(
        //         child: Text('View All Proforma'),
        //         onPressed: () {
        //           Vibration.vibrate(duration: 200);
        //           Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        //             return viewProforma();
        //           }));
        //         },
        //       ),
        //       ElevatedButton(
        //           onPressed: () {
        //             Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        //               return gstnSearch();
        //             }));
        //           },
        //           child: Text('Search Gstn')),
        //       // ElevatedButton(
        //       //     onPressed: () {
        //       //       Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        //       //         return kcbill();
        //       //       }));
        //       //     },
        //       //     child: Text('KC'))
        //     ],
        //   ),
        // ),
        body: GridView(
          padding: EdgeInsets.all(8),
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
          ),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return viewProforma();
                }));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text('View Proforma'),
                decoration: BoxDecoration(
                  // image: DecorationImage(image: NetworkImage(bgurl)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.7),
                      Colors.purple,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return gstnSearch();
                }));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text('GST Search'),
                decoration: BoxDecoration(
                  // image: DecorationImage(image: NetworkImage(bgurl)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.7),
                      Colors.red,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return kcbill();
                }));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text('Kc'),
                decoration: BoxDecoration(
                  // image: DecorationImage(image: NetworkImage(bgurl)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withOpacity(0.7),
                      Colors.orange,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ));
  }
}
