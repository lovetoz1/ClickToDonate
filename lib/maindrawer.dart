import 'package:donate_to_click/about.dart';
import 'package:donate_to_click/login.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({Key? key, required this.messages}) : super(key: key);
  final String messages;

  final _auth = FirebaseAuth.instance;

  // String message = "";

  // void initState() {
  //   // TODO: implement initState
  //   getimpact();
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,

        children: [
          const DrawerHeader(
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/trees.png'), fit: BoxFit.cover),
            ),
            child: Text(
              'ClickToDonate',
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.blue,
            ),
            title: const Text('Who are we ?'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return AboutPage();
                }),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.blue,
            ),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Row(
                          children: [
                            CircularProgressIndicator(),
                            Container(
                                margin: EdgeInsets.only(left: 7),
                                child: Text("")),
                          ],
                        ),
                      ),
                  barrierDismissible: false);
              _auth.signOut();

              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Text(
              'About Developer',
            ),
          ),
          ListTile(
            title: Text(
              'Developed by Lovetoz',
              // textAlign: TextAlign.center,
            ),
          ),
          ListTile(
              title: Text(
                'Founder\'s Message',
                textAlign: TextAlign.left,
              ),
              leading: Icon(
                Icons.message,
                color: Colors.black,
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text('${messages}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: Text(
              '~Lovetoz',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
