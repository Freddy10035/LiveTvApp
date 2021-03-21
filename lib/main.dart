import 'dart:async';
import 'dart:convert';
import 'package:blur/blur.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'analytics_service.dart';
import 'database_helper.dart';
import 'gridview.dart';
import 'horizontalScrollView.dart';
import 'locator.dart';
import 'model/feature_model.dart';
import 'model/modelChannel.dart';
import 'model/modelFavorite.dart';
import 'settings.dart';
import 'sign_in.dart';
import 'textDesign.dart';
import 'theme_manager.dart';
import 'top_ten_grid.dart';

Future<void> main() async {
  setUpLocator();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  //await Firebase.initializeApp();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Demo',
      theme: themeNotifier.getTheme(),
      navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
      home: MyHomePage(
          title: 'Live TV',
          analytics: locator<AnalyticsService>().getAnalytics(),
          observer: locator<AnalyticsService>().getAnalyticsObserver()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);
  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _MyHomePageState createState() => _MyHomePageState(analytics, observer);
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  String _connectionStatus = 'Unknown';
  BannerAd _ad;
  bool _isAdLoaded = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  _MyHomePageState(this.analytics, this.observer);

  TextEditingController _controller;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _current = 0; //for image carousel counter
  List<String> list = [
    "assets/image/1.jpg",
    "assets/image/2.jpg",
    "assets/image/3.jpg",
    "assets/image/4.jpg",
    "assets/image/5.jpg",
    "assets/image/6.jpg",
    "assets/image/7.jpg"
  ]; // for carousel

  List<List<ModelChannel>> countryList = [];
  List<List<ModelFeature>> featureList = [];
  List<String> channelType = [];
  List<String> featureChannelType = [];
  List<ModelChannel> filteredChannel = [];
  List<ModelChannel> listTemp = [];
  List<ModelFeature> allFeatures = [];
  List<ModelChannel> allChannels = [];

  Future<void> _sendChannelInfo(
      FirebaseAnalytics a, ModelChannel modelChannel) async {
    await a.logEvent(name: "Tapped_Channel", parameters: <String, String>{
      "Channel_Name": modelChannel.channelname,
    });
  }

  List<ModelChannel> convert(AsyncSnapshot<List<Favorite>> s) {
    List<ModelChannel> temp = [];
    s.data.forEach((element) {
      ModelChannel modelTemp = new ModelChannel(
          the0: element.channelId,
          the1: element.channelName,
          the2: element.channelType,
          the3: element.channelCategory,
          the4: element.channelImage,
          the6: element.channelUrl,
          channelid: element.channelId,
          categoryname: element.channelCategory,
          channeltype: element.channelType,
          channelname: element.channelName,
          channelimage: element.channelImage,
          channelurl: element.channelUrl);
      temp.add(modelTemp);
    });
    return temp;
  }

  List<ModelChannel> convertFeatured(List<ModelFeature> f) {
    List<ModelChannel> temp = [];
    f.forEach((element) {
      ModelChannel modelTemp = new ModelChannel(
          the0: element.channelid,
          the1: element.featurename,
          the2: element.channelid,
          the3: element.channelname,
          the4: element.channelimage,
          the6: element.channelurl,
          channelid: element.channelid,
          categoryname: element.featurename,
          channeltype: element.channelid,
          channelname: element.channelname,
          channelimage: element.channelimage,
          channelurl: element.channelurl);
      temp.add(modelTemp);
    });
    return temp;
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      this.getData(http.Client());
      DatabaseHelper.instance.retrieveFavorite();
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  List<ModelChannel> parseChannel(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ModelChannel>((json) => ModelChannel.fromJson(json))
        .toList();
  }

  List<ModelFeature> parseFeaturedChannel(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ModelFeature>((json) => ModelFeature.fromJson(json))
        .toList();
  }

  Future<List<ModelFeature>> getFeaturedData(http.Client client) async {
    final r = await http.get('https://xyz.com');
    if (r.statusCode == 200) {
      setState(() {
        allFeatures = parseFeaturedChannel(r.body);
      });
      allFeatures.forEach((element) {
        if (featureChannelType.isEmpty) {
          featureChannelType.add(element.featurename);
        } else {
          if (featureChannelType.contains(element.featurename)) {
          } else {
            featureChannelType.add(element.featurename);
          }
        }
      });
      featureChannelType.forEach((countryCode) {
        List<ModelFeature> t = [];
        allFeatures.forEach((element) {
          if (element.featurename == countryCode) {
            t.add(element);
          }
        });
        featureList.add(t);
      });
      return parseFeaturedChannel(r.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<ModelChannel>> getData(http.Client client) async {
    final response = await http.get('https://xyz.com');
    if (response.statusCode == 200) {
      this.setState(() {
        allChannels = parseChannel(response.body);
      });

      allChannels.forEach((element) {
        if (channelType.isEmpty) {
          channelType.add(element.channeltype);
        } else {
          if (channelType.contains(element.channeltype)) {
          } else {
            channelType.add(element.channeltype);
          }
        }
      });

      channelType.forEach((countryCode) {
        List<ModelChannel> t = [];
        allChannels.forEach((element) {
          if (element.channeltype == countryCode) {
            t.add(element);
          }
        });
        countryList.add(t);
      });
      return parseChannel(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result.toString();
        });
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        if (_connectionStatus.contains("Failed")) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_connectionStatus),
            duration: Duration(seconds: 3),
          ));
        }

        break;
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    this.getData(http.Client());
    this.getFeaturedData(http.Client());
    DatabaseHelper.instance.retrieveFavorite();
    _ad = BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/6300978111", //test
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (_, error) {
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad.load();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    _connectivitySubscription.cancel();
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: DrawerHeader(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(right: 5.0),
                            height: 100.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/icon/logo1.png",
                                    ))),
                            width: 100.0,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Favorites',
                                softWrap: true,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Quality Time Pass',
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView(children: [
                ListTile(
                  title: Text("Home"),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text("Category"),
                  leading: Icon(Icons.file_copy),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text("Top 10 Views"),
                  leading: Icon(Icons.bar_chart),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: 'Top 10 page'),
                            builder: (context) => TopGridPage()));
                  },
                ),
                ListTile(
                  title: Text("Sign In"),
                  leading: Icon(Icons.perm_identity_outlined),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: 'login page'),
                            builder: (context) => SignIn()));
                  },
                ),
                ListTile(
                  title: Text("Settings"),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: 'Settings'),
                            builder: (context) => Settings()));
                  },
                ),
              ]),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: <Widget>[],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(
          waterDropColor: Colors.blue,
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          reverse: true,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                    height: 150.0,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    viewportFraction: 0.85,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                    scrollDirection: Axis.horizontal),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int itemIndex, r) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                          image: AssetImage(list[itemIndex]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                //for determining image position
                mainAxisAlignment: MainAxisAlignment.center,
                children: list.map((url) {
                  int index = list.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(246, 3, 3, 0.9019607843137255)
                          : Color.fromRGBO(113, 111, 111, 1.0),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                //search bar
                width: 320,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.black12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 16),
                        child: TextField(
                          controller: _controller,
                          enableInteractiveSelection: true,
                          enableSuggestions: true,
                          cursorColor: Colors.red,
                          cursorWidth: 2,
                          cursorHeight: 20,
                          autofocus: false,
                          onSubmitted: (string) {},
                          onChanged: (string) {
                            setState(() {
                              filteredChannel = allChannels
                                  .where((element) => (element.channelname
                                      .toLowerCase()
                                      .contains(string.toLowerCase())))
                                  .toList();
                            });
                          },
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Search Channel Name',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              splashColor: Colors.blue,
                              splashRadius: 5.0,
                              color: Colors.blue,
                              onPressed: () {},
                            ),
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Favorite>>(
                future: DatabaseHelper.instance.retrieveFavorite(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Favorite>> snapshot) {
                  return snapshot.hasData
                      ? Column(
                          children: [
                            snapshot.data.length > 0
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Favorite Channels",
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.red),
                                            textScaleFactor: 1.5,
                                          ),
                                        ),
                                      ),
                                      (snapshot.data.length > 5)
                                          ? Expanded(
                                              child: InkWell(
                                              onTap: () {
                                                listTemp = convert(snapshot);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  "See All",
                                                  softWrap: true,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    backgroundColor: Colors.red,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ))
                                          : SizedBox(),
                                    ],
                                  )
                                : SizedBox(),
                            snapshot.data.length > 0
                                ? Row(
                                    //data from sqflite
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          height: 200.0,
                                          child: ListView.separated(
                                              addAutomaticKeepAlives: false,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return (index < 6)
                                                    ? InkWell(
                                                        onTap: () {},
                                                        child: Stack(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            children: [
                                                              Container(
                                                                  margin: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          3.0),
                                                                  height: 200,
                                                                  width: 200,
                                                                  child: (index ==
                                                                          5)
                                                                      ? ImageBlur
                                                                          .network(
                                                                          snapshot
                                                                              .data[index]
                                                                              .channelImage,
                                                                          scale:
                                                                              2.5,
                                                                          height:
                                                                              200,
                                                                          blur:
                                                                              4,
                                                                          overlay:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              //to be added icon
                                                                              Icon(
                                                                                Icons.list,
                                                                                size: 50,
                                                                                color: Colors.white,
                                                                              ),
                                                                              Text(
                                                                                "See More",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  fontSize: 30,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              // Icon(Icons.list,
                                                                              //   color: Colors.red,
                                                                              //   // size: 10,
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                          //bd[index].channelimage
                                                                        )
                                                                      : Image
                                                                          .network(
                                                                          snapshot
                                                                              .data[index]
                                                                              .channelImage,
                                                                        )),
                                                              Container(
                                                                color: Colors
                                                                    .black12,
                                                                width: 200,
                                                                height: 25,
                                                                child: Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .channelName,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ]),
                                                      )
                                                    : SizedBox();
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider()),
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  )
                                : SizedBox()
                          ],
                        )
                      : SizedBox();
                },
              ),
              Row(
                // first listview
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Movies",
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red),
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                  (list.length > 4)
                      ? Expanded(
                          child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GridPage(
                                          list: list,
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "See All",
                              softWrap: true,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                backgroundColor: Colors.red,
                                color: Colors.white,
                                // background:,
                              ),
                            ),
                          ),
                        ))
                      : SizedBox(),
                ],
              ),
              Scroll(list, analytics, observer),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: countryList.length,
                physics: const NeverScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      children: [
                        CountryName(
                          list: list,
                        ),
                        Scroll(list, analytics, observer),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
              (_isAdLoaded)
                  ? Container(
                      child: AdWidget(ad: _ad),
                      width: _ad.size.width.toDouble(),
                      height: 72.0,
                      alignment: Alignment.center,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // modelFavorite to modelChannel
  ModelChannel convertSingle(Favorite data) {
    ModelChannel m = ModelChannel(
        the0: data.channelId,
        the1: data.channelName,
        the2: data.channelType,
        the3: data.channelCategory,
        the4: data.channelImage,
        the6: data.channelUrl,
        channelid: data.channelId,
        categoryname: data.channelCategory,
        channeltype: data.channelType,
        channelname: data.channelName,
        channelimage: data.channelImage,
        channelurl: data.channelUrl);
    return m;
  }
}
