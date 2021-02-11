import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:live_tv_app/modelChannel.dart';
import 'package:live_tv_app/youtubePlayer.dart';

class Scroll extends StatelessWidget {
  final List<ModelChannel> channel;

  Scroll(this.channel);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        //padding: const EdgeInsets.all(8),
        addAutomaticKeepAlives: false,
        scrollDirection: Axis.horizontal,
        itemCount: channel.isEmpty ? 0 : channel.length,
        itemBuilder: (BuildContext context, int index) {
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
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                  height: 200,
                  width: 200,
                  child: Image.network(
                    channel[index].channelimage,
                    //bd[index].channelimage
                  )

                  //decoration: BoxDecoration(),

                  //decoration: BoxDecoration,
                  ),
              Container(
                color: Colors.black12,
                width: 200,
                height: 25,
                child: Text(
                  channel[index].channelname,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider());
  }
}
