import 'package:donate_to_click/main.dart';
import 'package:donate_to_click/thankyou.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

const int maxAttempts = 3;

class secondapp2 extends StatefulWidget {
  const secondapp2({Key? key, required this.userid}) : super(key: key);
  final userid;
  @override
  _secondapp2State createState() => _secondapp2State();
}

class _secondapp2State extends State<secondapp2> {
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

  ///function to load inline banner ad
  void loadInlineBannerAd() {
    inlineAd = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
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
          print('dismissed krr rha hunn');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return thankYou();
              },
            ),
          );
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

  final _firestore = FirebaseFirestore.instance;
  int secondtimer = 15;
  Timer? timer;
  int counter1 = 0;
  void startthecounter() {
    setState(() {
      counter1++;
    });
  }

  void startthetime() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer t) {
      if (secondtimer <= 0) {
        timer?.cancel();
        showDialog(
            context: context,
            builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  child: WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                            child: Column(
                              children: [
                                Text(
                                  'Congratulations',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                if (counter1 < 10) ...[
                                  Text(
                                    'You did well, but try harder',
                                    style: TextStyle(fontSize: 26),
                                  ),
                                ] else ...[
                                  Text(
                                    'You Pressed ${counter1} Times',
                                    style: TextStyle(fontSize: 26),
                                  ),
                                ],
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final increment =
                                        FieldValue.increment(counter1);
                                    final globalclicks = _firestore
                                        .collection('totalclick')
                                        .doc('clicks');
                                    globalclicks.update({'click': increment});
                                    final userkeys = _firestore
                                        .collection('users')
                                        .doc(widget.userid);
                                    userkeys.update({'clicks': increment});
                                    // startthetime();

                                    Navigator.of(context).pop();
                                    showInterstitialAd();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return thankYou();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Submit it to a cause',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.blueGrey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'We would share the donation with different NGOs.',
                                        style:
                                            TextStyle(color: Colors.blueGrey),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Image.asset('assets/lottie.gif'))
                      ],
                    ),
                  ),
                ),
            barrierDismissible: false);
      } else {
        setState(() {
          secondtimer--;
        });
      }
    });
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

  @override
  void initState() {
    createInterstialAd();
    // TODO: implement initState
    super.initState();
    print("as");
    // Timer.run(startthetime);
    Future.delayed(Duration(milliseconds: 1), () {
      setState(() {
        showDialog(
            context: context,
            builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  child: WillPopScope(
                    onWillPop: () async {
                      Navigator.pop(context, true);
                      Navigator.pop(context, true);
                      return true;
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: 350,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Colors.blue,
                                  size: 60,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'After Pressing Okay, the timer will get start and you can click as much as you can in 15 seconds',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    startthetime();
                                  },
                                  child: Text(
                                    'Okay',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Positioned(
                        //     child: Lottie.network(
                        //         'https://assets6.lottiefiles.com/packages/lf20_juesbx87.json')),
                      ],
                    ),
                  ),
                ),
            barrierDismissible: false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startthecounter,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFebf5ac),
                  // Color(0xFFa9eced),
                  Color(0xFF40B9C1),
                  Color(0xff7ee7e8),
                  Color(0xFFebf5ac)
                  // Color(0xFFFF559F),
                  // Color(0xFFCF5CCF),
                  // Color(0xFFFF57AC),
                  // Color(0xFFFF6D91),
                  // Color(0xFFFF8D7E)
                ],
              ),
            ),
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: 200,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: 200,
                      width: 200,
                      // color: Colors.green,
                      child: Stack(
                        alignment: Alignment.center,
                        // fit: StackFit.expand,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            child: CircularProgressIndicator(
                              value: secondtimer / 15,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 3,
                              backgroundColor: Colors.blue,
                              // color: Colors.white,
                            ),
                          ),
                          Positioned(
                            child: Text(
                              '$secondtimer',
                              style:
                                  TextStyle(fontSize: 60, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 20.0, height: 100.0),
                          const Text(
                            '',
                            style: TextStyle(fontSize: 43.0),
                          ),
                          const SizedBox(width: 20.0, height: 100.0),
                          DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Horizon',
                                color: Colors.white),
                            child: AnimatedTextKit(animatedTexts: [
                              RotateAnimatedText('Your Clicks create impact',
                                  duration: Duration(seconds: 4)),
                              RotateAnimatedText(
                                'You can click using two hands',
                                duration: Duration(seconds: 4),
                              ),
                              RotateAnimatedText('Every click counts',
                                  duration: Duration(seconds: 4)),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          // margin: EdgeInsets.all(40.0),
                          child: GestureDetector(
                            // onTap: startthetime,
                            child: Text(
                              '$counter1 Clicks',
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 40,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Positioned(
                          // height: 100,
                          // top: -130,
                          top: -60,
                          left: 10,
                          // child: Image.asset(
                          //   'assets/first.png',
                          //   height: 200,
                          //   width: 200,
                          // ),
                          child: Text(
                            '🤝 ',
                            style: TextStyle(fontSize: 70, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
