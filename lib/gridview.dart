import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_manager.dart';
import 'youtubePlayer.dart';

class GridPage extends StatelessWidget {
  final List<String> list;

  const GridPage({Key key, this.list}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),
      home: MyGrid(
        channel: list,
      ),
    );
  }
}

class MyGrid extends StatefulWidget {
  final List<String> channel;

  const MyGrid({Key key, this.channel}) : super(key: key);

  @override
  _MyGridState createState() => _MyGridState(channel);
}

class _MyGridState extends State<MyGrid> {
  final List<String> channel;

  _MyGridState(this.channel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //backgroundColor: Colors.white,
            title: (channel.length < 10)
                ? Text(
                    "Your Channels",
                  )
                : Text(
                    "All Channels",
                    style: TextStyle(),
                  ),
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(context);
              },
            )),
        body: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: List.generate(channel.length, (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(name: 'youtube player'),
                          builder: (context) => LiveTvPlayer()));
                },
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Container(
                    decoration: BoxDecoration(
                      //  borderRadius: BorderRadius.all(Radius.circular(12)),
                      image: DecorationImage(
                        image: AssetImage(
                          channel[index],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 16,
                    child: Text(
                      "Channel Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              );
            })));
  }
}
