import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

TextStyle style = TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.w600,
    fontFamily: 'Roboto');
PageController pageController = PageController(initialPage: 0);
int indexx = 0;

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       iconSize: 30,
      //       icon: Icon(Icons.close),
      //       onPressed: () {
      //         indexx = 1;
      //         Navigator.pop(context);
      //       },
      //     )
      //   ],
      //   title: Center(
      //     child: Text(
      //       'How we do this?',
      //       textAlign: TextAlign.center,
      //     ),
      //   ),
      //   leading: Center(
      //     child: Text(
      //       '${indexx}/3',
      //       style: TextStyle(fontSize: 20),
      //     ),
      //   ),

      //   automaticallyImplyLeading: false,
      // ),
      body: ListView(
        // onPageChanged: (index) {
        //   setState(() {
        //     indexx = index + 1;
        //   });
        // },
        // controller: pageController,
        scrollDirection: Axis.vertical,
        // pageSnapping: false,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(30.0, 70.0, 20, 20),
            child: Column(
              children: [
                Text(
                  'What is ClickToDonate?',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black54,
                      fontSize: 44),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'An application that changes your each click into something that can actually make a difference.',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black54,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffd6e862),

                  Color(0xFF40B9C1),
                  Color(0xff7ee7e8),
                  Color(0xffffffff)
                  // Color(0xFFFF559F),
                  // Color(0xFFCF5CCF),
                  // Color(0xFFFF57AC),
                  // Color(0xFFFF6D91),
                  // Color(0xFFFF8D7E)
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
            child: Column(
              children: [
                Text(
                  'The power of Many.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.orange,
                      fontSize: 44),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'If DonateToClick becomes a family of Million, then we can plant ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  '20 Million trees per month',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 80,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white30,
                  child: MaterialButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Share Your Impact",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      onPressed: () async {
                        await Share.share(
                            "Install The Application ClickToDonate and convert your clicks into something that can actually make a difference");
                      }),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage("assets/trees.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          )
        ],
      ),
    );
  }
}
