import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:live_tv_app/gridview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All TV',
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
  int _current = 0;//for image counter
  List<String> list=["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg"];// for carousel
  List<String> entries = <String>['assets/image/1.jpg', 'assets/image/2.jpg', 'assets/image/3.jpg','assets/image/4.jpg','assets/image/5.jpg'];// for horizontal list

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
        title: Text(widget.title,
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
            SizedBox(height: 10,
            ),
            CarouselSlider(
              options: CarouselOptions(
                  //height: 400.0,

                //pageSnapping : true,
              aspectRatio: 16/9,
              viewportFraction: 0.7,
              initialPage: 0,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              //onPageChanged: callbackFunction,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });},

              scrollDirection: Axis.horizontal
              ),
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
            Row(//for determining image position
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
            SizedBox(height: 10,
            ),
            Row(// first listview
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Latest',
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,decoration: TextDecoration.underline,decorationColor: Colors.red ),
                    textScaleFactor: 1.5,
                  ),
                ),
                Expanded(
                    //onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>GridView(gridDelegate: null,))); },
                  child: RaisedButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>GridPage())); },
                    child: const Text(
                        'See All',
                        style: TextStyle(fontSize: 15,color: Colors.white)
                    ),
                    color: Colors.red,
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
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),

                          height: 200,
                          child: Image.asset('${entries[index]}'),
                          decoration: BoxDecoration(shape: BoxShape.rectangle),
                          //decoration: BoxDecoration,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                  )
                ),

              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(height: 10,
            ),
            Row(//2nd list view
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Most View',
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,decoration: TextDecoration.underline,decorationColor: Colors.red ),
                    textScaleFactor: 1.5,
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>GridPage())); },
                  child: const Text(
                                  'See All',
                      style: TextStyle(fontSize: 15,color: Colors.white)
                          ),
                         color: Colors.red,
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
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),

                            height: 200,
                            child: Image.asset('${entries[index]}'),
                            decoration: BoxDecoration(shape: BoxShape.rectangle),
                            //decoration: BoxDecoration,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                      ),
                    )
                ),

              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Recent View',
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,decoration: TextDecoration.underline,decorationColor: Colors.red ),
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
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),

                            height: 200,
                            child: Image.asset('${entries[index]}'),
                            decoration: BoxDecoration(shape: BoxShape.rectangle),
                            //decoration: BoxDecoration,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                      ),
                    )
                ),

              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),

          ],

        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
