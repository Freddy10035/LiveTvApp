import 'package:flutter/material.dart';

import 'package:live_tv_app/modelChannel.dart';
import 'package:live_tv_app/youtubePlayer.dart';

void main() {
  // runApp(GridPage());
}

class GridPage extends StatelessWidget {
  final List<ModelChannel> channel;

  const GridPage({Key key, this.channel}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: (channel.length < 10)
                ? Text(
                    channel[0].categoryname + " Channels",
                    style: TextStyle(color: Colors.black),
                  )
                : Text(
                    "All Channels",
                    style: TextStyle(color: Colors.black),
                  ),
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            )
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            ),
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
                          builder: (context) => LiveTvPlayer(
                                channel: channel[index],
                              )));
                },
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Container(
                    decoration: BoxDecoration(
                      //  borderRadius: BorderRadius.all(Radius.circular(12)),
                      image: DecorationImage(
                        image: NetworkImage(
                          channel[index].channelimage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.black12,
                    width: 200,
                    height: 16,
                    child: Text(
                      channel[index].channelname,

                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white,),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              );
            }))
    );
  }
}
