import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'analytics_service.dart';
import 'database_helper.dart';
import 'locator.dart';
import 'model/modelFavorite.dart';
import 'theme_manager.dart';

/// Creates [LiveTvPlayer] widget.
class LiveTvPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      home: MyHomePage(),
      theme: themeNotifier.getTheme(),
      navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
    );
  }
}

/// Homepage
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<Favorite>> f;
  InterstitialAd _interstitialAd;
  BannerAd _ad;
  bool _bannerLoaded = false;
  bool _interstitialReady = false;
  int _counter;

  bool icon = false;

  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];

  _loadCounter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _counter = (prefs.getInt("counter") ?? 0);
    });
  }

  setToZero() async {
    SharedPreferences preferences = await _prefs;
    setState(() {
      _counter = 1;
      preferences.setInt('counter', _counter);
    });
  }

  _incrementCounter() async {
    SharedPreferences preferences = await _prefs;
    setState(() {
      _counter = (preferences.getInt('counter') ?? 0) + 1;
      preferences.setInt('counter', _counter);
    });
  }

  Future<Widget> _showDialog(BuildContext c) async {
    await Future.delayed(Duration(seconds: 1));
    return await showDialog<Widget>(
        context: c,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            elevation: 24.0,
            backgroundColor: Colors.blue,
            title: Text(
              'Liking our app?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Continue as Guest",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  setToZero();
                  Navigator.pop(buildContext);
                  Navigator.pop(buildContext);
                },
              ),
              TextButton(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _loadCounter();
    _incrementCounter();
    f = DatabaseHelper.instance.retrieveFavorite();
    _controller = YoutubePlayerController(
      initialVideoId: "6ZfuNTqbHE8",
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: true,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();

    _interstitialAd = InterstitialAd(
      adUnitId: "ca-app-pub-3940256099942544/1033173712", //test
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          _interstitialReady = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error.');
          ad.dispose();
          _interstitialAd = null;
          //createInterstitialAd();
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          //createInterstitialAd();
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    );
    _interstitialAd.load();

    Future.delayed(Duration(seconds: 5), () {
      if (_counter != null && _counter % 5 == 0) {
      } else {
        _interstitialAd.show();
      }
    });

    _ad = BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/6300978111", //test
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _bannerLoaded = true;
          });
        },
        onAdFailedToLoad: (_, error) {
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad.load();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    _interstitialAd?.dispose();
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Live",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(context);
            },
          )),
      body: Column(
        children: [
          YoutubePlayerBuilder(
            onEnterFullScreen: () {
              SystemChrome.setPreferredOrientations(DeviceOrientation.values);
            },
            onExitFullScreen: () {
              SystemChrome.setPreferredOrientations(DeviceOrientation.values);
            },
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              topActions: <Widget>[
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _controller.metadata.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {
                _controller
                    .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
              },
            ),
            builder: (context, player) {
              return Column(
                children: [
                  player,
                ],
              );
            },
          ),
          Container(
            margin: EdgeInsets.all(5),
            height: 50,
            color: Colors.black12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Example',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 250,
                ),
                Container(
                  height: 45,
                  width: 45,
                  child: IconButton(
                    alignment: Alignment.center,
                    splashRadius: 60,
                    splashColor: Colors.blue,
                    onPressed: () async {
                      // await DatabaseHelper.instance.insert({
                      //   DatabaseHelper.columnChannelName: channel.channelname,
                      //   DatabaseHelper.columnChannelCategory:
                      //       channel.categoryname,
                      //   DatabaseHelper.columnChannelId: channel.channelid,
                      //   DatabaseHelper.columnChannelType: channel.channeltype,
                      //   DatabaseHelper.columnChannelUrl: channel.channelurl,
                      //   DatabaseHelper.columnChannelImage: channel.channelimage,
                      // });
                      setState(() {
                        icon = true;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Added to Favorite Successfully, Please Refresh Main Page"),
                        duration: Duration(seconds: 3),
                      ));
                    },
                    icon: !icon
                        ? Icon(
                            Icons.add,
                            color: Colors.red,
                            size: 30,
                          )
                        : Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 30,
                          ),
                  ),
                  //color: Colors.red,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black12,
                  ),
                ),
              ],
            ),
          ),
          (_counter != null && _counter % 5 == 0)
              ? FutureBuilder<Widget>(
                  future: _showDialog(context),
                  builder: (context, AsyncSnapshot<Widget> snap) {
                    if (snap.hasData) {
                      return snap.data;
                    } else {
                      return Container(height: 0.0, width: 0.0);
                    }
                  })
              : Container(
                  height: 0.0,
                  width: 0.0,
                ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: (_bannerLoaded && _counter % 5 != 0 && _counter != 1)
                  ? Container(
                      child: AdWidget(ad: _ad),
                      width: _ad.size.width.toDouble(),
                      height: 72.0,
                      alignment: Alignment.center,
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
