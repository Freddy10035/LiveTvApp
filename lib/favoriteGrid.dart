import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'model/modelChannel.dart';
import 'theme_manager.dart';
import 'youtubePlayer.dart';

class FavoriteGridPage extends StatelessWidget {
  final List<ModelChannel> channel;

  const FavoriteGridPage({Key key, this.channel}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),
      home: MyHome(channel: channel),
    );
  }
}

class MyHome extends StatefulWidget {
  final List<ModelChannel> channel;

  MyHome({Key key, this.channel}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState(channel);
}

class _MyHomeState extends State<MyHome> {
  final List<ModelChannel> channel;

  _MyHomeState(this.channel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Favorite Channels",
            ),
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LiveTvPlayer()));
                },
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          channel[index].channelimage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 16,
                    child: Text(
                      channel[index].channelname,
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
