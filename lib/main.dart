import 'package:donate_to_click/about.dart';
import 'package:donate_to_click/login.dart';
import 'package:donate_to_click/maindrawer.dart';
import 'package:donate_to_click/nointernet.dart';
import 'package:donate_to_click/register.dart';
import 'package:donate_to_click/seconsecreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

const int maxAttempts = 3;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("oops");
          } else if (snapshot.hasData &&
              FirebaseAuth.instance.currentUser != null) {
            return MyHomePage();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            print("waitin");
            return Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      Text('WAIT '),
                      Container(
                        height: 30,
                        child: Image.asset(
                          'assets/donate2click.png',
                          height: 30,
                        ),
                      ),
                      CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    ],
                  ),
                ));
          }

          print("nothing");

          return LoginPage();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget buildBottomsheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, Colors.white, Colors.blue],
        ),
      ),
      padding: EdgeInsets.all(10.0),
      // height: MediaQuery.of(context).size.height * 1.0,
      child: Column(
        children: [
          Column(
            children: [
              Text(
                'We are working with ',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.blueGrey),
              ),
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/sharethemeal.png'),
                    Image.asset('assets/ngo1.jpg')
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  ' Each daily challenge completed, help us in supporting a good cause. Each change makes a difference.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.blue),
                margin: EdgeInsets.all(10.0),
              )
            ],
          ),
        ],
      ),
    );
  }

  int _counter = 0;
  double _clickss = 0;
  String _textin = "Challenge";
  void _incrementCounter() {
    setState(() {
      if (_counter < 10) {
        _counter++;
      } else {
        _textin = 'whalla we won';
      }
      _clickss = (_counter / 10);
    });
  }

  late BannerAd staticAd;
  bool staticAdLoaded = false;
  late BannerAd inlineAd;
  bool inlineAdLoaded = false;

  InterstitialAd? interstitialAd;
  int interstitialAttempts = 0;

  RewardedAd? rewardedAd;
  int rewardedAdAttempts = 0;

  ///Ad request settings
  static const AdRequest request = AdRequest(
      // keywords: ['', ''],
      // contentUrl: '',
      // nonPersonalizedAds: false
      );

  ///function to load static banner ad
  void loadStaticBannerAd() {
    staticAd = BannerAd(
        adUnitId: 'ca-app-pub-5024611370059426/4185892131',
        size: AdSize.banner,
        request: request,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            staticAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();

          print('ad failed to load ${error.message}');
        }));

    staticAd.load();
  }

  ///function to load inline banner ad
  void loadInlineBannerAd() {
    inlineAd = BannerAd(
        adUnitId: 'ca-app-pub-5024611370059426/4185892131',
        size: AdSize.banner,
        request: request,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            inlineAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();

          print('ad failed to load ${error.message}');
        }));

    inlineAd.load();
  }

  ///function to create Interstitial ad
  void createInterstialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-5024611370059426/2863898146',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          interstitialAd = ad;
          interstitialAttempts = 0;
        }, onAdFailedToLoad: (error) {
          interstitialAttempts++;
          interstitialAd = null;
          print('falied to load ${error.message}');

          if (interstitialAttempts <= maxAttempts) {
            createInterstialAd();
          }
        }));
  }

  ///function to show the Interstitial ad after loading it
  ///this function will get called when we click on the button
  void showInterstitialAd() {
    if (interstitialAd == null) {
      print('trying to show before loading');
      return;
    }

    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) => print('ad showed $ad'),
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createInterstialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          print('failed to show the ad $ad');

          createInterstialAd();
        });

    interstitialAd!.show();
    interstitialAd = null;
  }

  ///function to create rewarded ad
  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: RewardedAd.testAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
          rewardedAdAttempts = 0;
        }, onAdFailedToLoad: (error) {
          rewardedAdAttempts++;
          rewardedAd = null;
          print('failed to load ${error.message}');

          if (rewardedAdAttempts <= maxAttempts) {
            createRewardedAd();
          }
        }));
  }

  ///function to show the rewarded ad after loading it
  ///this function will get called when we click on the button
  void showRewardedAd() {
    if (rewardedAd == null) {
      print('trying to show before loading');
      return;
    }

    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) => print('ad showed $ad'),
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          print('failed to show the ad $ad');

          createRewardedAd();
        });

    rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      print('reward video ${reward.amount} ${reward.type}');
    });
    rewardedAd = null;
  }

  @override
  void initState() {
    loadStaticBannerAd();
    loadInlineBannerAd();
    createInterstialAd();
    createRewardedAd();
    // TODO: implement initState
    super.initState();

    getuser();
    getimessages();

    // print(user);
  }

  @override
  void dispose() {
    super.dispose();

    ///Don't forget to dispose the ads
    staticAd.dispose();
    inlineAd.dispose();
    interstitialAd?.dispose();
    rewardedAd?.dispose();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? user;
  void getclicks() async {
    final impactt = await _firestore
        .collection('totalclick')
        .doc('clicks')
        .get()
        .then((value) => {value.data()});

    final clicks = impactt.toList();
    setState(() {
      _counter = clicks[0]!['click'];
      clicksneeded = clicks[0]!['needed'];
      _clickss = (_counter / clicksneeded);
    });
  }

  void getimpact() async {
    final impactt = await _firestore
        .collection('impact')
        .doc('impact')
        .get()
        .then((value) => {value.data()});

    final imact1 = impactt.toList();
    setState(() {
      donated = imact1[0]!['donated'];
      impact = imact1[0]!['planted'];
    });
  }

  void getcurrentuser() async {
    print('user');
    user = _auth.currentUser;

    if (user != null) {
      print(user!.email);
    }
  }

  int yourclicks = 0;
  int clicksneeded = 0;
  String clickss = "";
  String names = "";
  int impact = 0;
  int donated = 0;
  void getuser() async {
    getcurrentuser();
    getimpact();
    getclicks();
    final name = await _firestore
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) => {value.data()});
    print(name.first!['name']);

    final dataa = name.toList();

    setState(() {
      yourclicks = dataa[0]!['clicks'];
      names = dataa[0]!['name'];
    });
  }

  String message = '';

  void getimessages() async {
    final impactt = await _firestore
        .collection('message')
        .doc('message')
        .get()
        .then((value) => {value.data()});

    final imact1 = impactt.toList();
    setState(() {
      print(imact1);
      message = imact1[0]!['message'];
    });
  }

  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        messages: message,
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(55, 8, 187, 1.0),
        elevation: 0.0,
        title: Text('Hii , $names'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(context: context, builder: buildBottomsheet);
            },
            icon: Icon(Icons.info),
          ),
          IconButton(
            onPressed: () async {
              await Share.share(
                  "Install The Application ClickToDonate from Playstore, and convert your clicks into something that can actually make a difference");
            },
            icon: Icon(Icons.share),
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(55, 8, 187, 1.0),
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [
            ListView(
              children: [
                Container(
                  height: 800,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 16.0),
                            Text(
                              "Daily $_textin",
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 44,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                            Text(
                              "${clicksneeded} Clicks",
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 33,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            height: 300,
                            // height: MediaQuery.of(context).size.height * 0.30,
                            margin: EdgeInsets.all(20.0),
                            // color: Colors.green,
                            // child: Image.asset('assets/image1.png'),
                            child: PhysicalModel(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              elevation: 12,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20.0, 10.0, 0, 0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Our Impact",
                                        style: TextStyle(
                                            fontFamily: 'Avenir',
                                            fontSize: 30,
                                            color:
                                                Color.fromRGBO(71, 37, 178, 1),
                                            fontWeight: FontWeight.w800),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Food Served",
                                                  style: TextStyle(
                                                      fontFamily: 'Avenir',
                                                      fontSize: 20,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Text(
                                                  "${impact}",
                                                  style: TextStyle(
                                                      fontFamily: 'Avenir',
                                                      fontSize: 34,
                                                      color: Color.fromRGBO(
                                                          71, 37, 178, 1),
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                                // Image.asset('assets/tree.png'),
                                                Image.asset(
                                                  'assets/food.png',
                                                  height: 100,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Trees Planted",
                                                  style: TextStyle(
                                                      fontFamily: 'Avenir',
                                                      fontSize: 20,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Text(
                                                  "${donated}",
                                                  style: TextStyle(
                                                      fontFamily: 'Avenir',
                                                      fontSize: 34,
                                                      color: Color.fromRGBO(
                                                          71, 37, 178, 1),
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                                Image.asset(
                                                  'assets/tree.png',
                                                  height: 100,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.all(20.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topLeft,
                            children: [
                              Column(
                                children: <Widget>[
                                  Container(
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.pinkAccent,
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10.0, 20.0, 10.0, 0.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          height: 8,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              value: _clickss,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.blueAccent,
                                              ),
                                              backgroundColor:
                                                  Color(0xffD6D6D6),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.70,
                                          // color: Colors.green,
                                          child: Text(
                                            "$_counter Clicks of $clicksneeded",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'Avenir',
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: -75,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 30.0, 0, 2.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${(_clickss * 100).toInt()}",
                                        style: TextStyle(
                                            fontFamily: 'Avenir',
                                            fontSize: 60,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        "%",
                                        style: TextStyle(
                                            fontFamily: 'Avenir',
                                            fontSize: 26,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return secondapp2(userid: user!.uid);

                                      // return LoginPage();
                                    },
                                  ),
                                );

                                // Navigator.of(context).pop();
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.navigate_next,
                                    size: 40,
                                  ),
                                  Text(
                                    'Donate Your Clicks',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                padding: EdgeInsets.all(24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (staticAdLoaded)
                  Container(
                    child: AdWidget(
                      ad: staticAd,
                    ),
                    width: staticAd.size.width.toDouble(),
                    height: staticAd.size.height.toDouble(),
                    alignment: Alignment.bottomCenter,
                  ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  height: 300,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topLeft,
                    children: [
                      Column(
                        children: <Widget>[
                          Container(
                            // height: 300.0,
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  "Achievements",
                                  style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontSize: 30,
                                      color: Color(0xffEF6C00),
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Image.asset('assets/selfie.png'),
                                      ),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Text(
                                            "Total Clicks",
                                            style: TextStyle(
                                                fontFamily: 'Avenir',
                                                fontSize: 20,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            "$yourclicks",
                                            style: TextStyle(
                                                fontFamily: 'Avenir',
                                                fontSize: 34,
                                                color: Color.fromRGBO(
                                                    71, 37, 178, 1),
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: -75,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 30.0, 0, 2.0),
                          child: Image.asset('assets/trophy.png'),
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
