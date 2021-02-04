import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:live_tv_app/gridview.dart';
import 'package:http/http.dart' as http;
import 'package:live_tv_app/modelChannel.dart';
//import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

List<ModelChannel> parseChannel(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<ModelChannel>((json) => ModelChannel.fromJson(json))
      .toList();
}

Future<List<ModelChannel>> getData(http.Client client) async {
  final response =
      await http.get('https://andoirdtvapp.hiphopnblog.com/fetch_jason.php');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return parseChannel(response.body);
    //return channels;
  } else {
    //If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live TV App',
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
      home: MyHomePage(title: 'Android Live TV'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  //MyHomePage({Key key,this.})

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _current = 0; //for image counter
  bool _folded = true;
  List<String> list = [
    "1.jpg",
    "2.jpg",
    "3.jpg",
    "4.jpg",
    "5.jpg"
  ]; // for carousel
  List<String> entries = <String>[
    'assets/image/1.jpg',
    'assets/image/2.jpg',
    'assets/image/3.jpg',
    'assets/image/4.jpg',
    'assets/image/5.jpg'
  ]; // for horizontal list
  //Future<List<ModelChannel>> future;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/header.jpeg"),
                          fit: BoxFit.cover)),
                  child: Text("Header"),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(children: [
                ListTile(
                  title: Text("Home"),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text("All Channel"),
                  leading: Icon(Icons.file_copy_outlined),
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
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text("Favorite"),
                  leading: Icon(Icons.favorite),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text("Settings"),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]),
            )
          ],
        ),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        iconTheme: IconThemeData(color: Colors.black38),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.black,
            ),
            onPressed: () {
              // do something
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            CarouselSlider(
              options: CarouselOptions(
                  height: 150.0,
                  //pageSnapping : true,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  //aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  //onPageChanged: callbackFunction,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                  scrollDirection: Axis.horizontal),
              items: [
                Container(
                  decoration: BoxDecoration(
                    //  borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: DecorationImage(
                      image: AssetImage('assets/image/1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    //  borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: DecorationImage(
                      image: AssetImage('assets/image/2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    //  borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: DecorationImage(
                      image: AssetImage('assets/image/3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    //  borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: DecorationImage(
                      image: AssetImage('assets/image/4.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    //  borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: DecorationImage(
                      image: AssetImage('assets/image/5.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              //for determining image position
              mainAxisAlignment: MainAxisAlignment.center,
              children: list.map((url) {
                int index = list.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // boxShadow: BoxShadow(color: ),
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
            AnimatedContainer(
              //search bar
              duration: Duration(milliseconds: 400),
              width: _folded ? 56 : 280,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white,
                boxShadow: kElevationToShadow[6],
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: !_folded
                        ? TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Channel Name',
                              hintStyle: TextStyle(color: Colors.red),
                              border: InputBorder.none,
                              fillColor: Colors.red,
                            ),
                          )
                        : null,
                  )),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(_folded ? 32 : 0),
                          topRight: Radius.circular(32),
                          bottomLeft: Radius.circular(_folded ? 32 : 0),
                          bottomRight: Radius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            _folded ? Icons.search : Icons.close,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _folded = !_folded;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              // first listview
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Bangladesh',
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red),
                    textScaleFactor: 1.5,
                  ),
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GridPage()));
                  },
                  child: const Text('See All',
                      softWrap: true,
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    minimumSize: MaterialStateProperty.all(Size.square(30)),
                  ),
                )),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: SizedBox(
                  height: 200.0,
                  child: FutureBuilder<List<ModelChannel>>(
                    future: getData(http.Client()),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Text("Loading....");
                      } else
                        return ListView.separated(
                          //padding: const EdgeInsets.all(8),
                          addAutomaticKeepAlives: false,
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 3.0),
                                height: 200,
                                width: 200,
                                child: ((snapshot.data[index].the2 ==
                                        "7")
                                    ? Image.network(
                                        snapshot.data[index].channelimage,
                                        semanticLabel:
                                            snapshot.data[index].channelname,
                                      )
                                    : null)
                                //decoration: BoxDecoration(),

                                //decoration: BoxDecoration,
                                );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        );
                    },
                  ),
                )),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              //2nd list view
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Most View',
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: '',
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red),
                    textScaleFactor: 1.5,
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => GridPage()));
                    },
                    child: const Text('See All',
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        minimumSize:
                            MaterialStateProperty.all(Size.square(30))),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: SizedBox(
                  height: 200.0,
                  child: ListView.separated(
                    //padding: const EdgeInsets.all(8),
                    addAutomaticKeepAlives: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 3.0),

                        height: 200,
                        child: Image.asset('${entries[index]}'),
                        decoration: BoxDecoration(shape: BoxShape.rectangle),
                        //decoration: BoxDecoration,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                )),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Recent View',
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red),
                    textScaleFactor: 1.5,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: SizedBox(
                  height: 200.0,
                  child: ListView.separated(
                    //padding: const EdgeInsets.all(8),
                    addAutomaticKeepAlives: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 3.0),

                        height: 200,
                        child: Image.asset('${entries[index]}'),
                        decoration: BoxDecoration(shape: BoxShape.rectangle),
                        //decoration: BoxDecoration,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                )),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
