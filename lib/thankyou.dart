import 'dart:async';

import 'package:donate_to_click/main.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:math';

const int maxAttempts = 3;

class thankYou extends StatefulWidget {
  const thankYou({Key? key}) : super(key: key);

  @override
  _thankYouState createState() => _thankYouState();
}

class _thankYouState extends State<thankYou> {
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
        adUnitId: BannerAd.testAdUnitId,
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
        adUnitId: InterstitialAd.testAdUnitId,
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

  int secondtimer = 10;

  Timer? timer;

  void startthetime() {
    const oneSec = Duration(seconds: 2);
    timer = Timer.periodic(oneSec, (Timer t) {
      timer!.cancel();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage(),
        ),
        (route) => false,
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startthetime();
    randomNumber = random.nextInt(3);
    print(randomNumber);
  }

  int randomNumber = 0;
  List imagesa = [1, 2, 3];
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Image.asset('assets/thankyou${imagesa[randomNumber]}.png'),
            Text(
              'Thank You',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 57,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
