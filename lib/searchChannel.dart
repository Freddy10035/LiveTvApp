import 'package:flutter/material.dart';

import 'package:live_tv_app/modelChannel.dart';
import 'package:live_tv_app/youtubePlayer.dart';

void main() {
  // runApp(GridPage());
}

class Search extends StatelessWidget {
  final List<ModelChannel> channel;
  final String string;

  Search({Key key, this.channel, this.string}) : super(key: key);
  ModelChannel foundChannel;

  bool check(){
     bool found=false;
    channel.forEach((element) {
      if(element.channelname == string){
        foundChannel=element;
        found=true;
      }

    });
    return found;
  }



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: check()
                ? Text(
              channel[0].categoryname,
              style: TextStyle(color: Colors.black),
            )
                : Text(
              "Not Found",
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
        body: check() ? Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LiveTvPlayer(
                        channel: foundChannel,
                      )));
            },
            child: Container(
              decoration: BoxDecoration(
                //  borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(foundChannel.channelimage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        )
            : Text("Not Found"),
    );
  }
}