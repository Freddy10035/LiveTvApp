import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:live_tv_app/gridview.dart';

import 'package:live_tv_app/modelChannel.dart';
import 'package:live_tv_app/youtubePlayer.dart';

class Scroll extends StatelessWidget {
  final List<ModelChannel> channel;

  Scroll(this.channel);

  @override
  Widget build(BuildContext context) {
    return (channel.length == 0)
        ? SizedBox(
            height: 0.1,
          )
        : Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 200.0,
                  child: ListView.separated(
                      //padding: const EdgeInsets.all(8),
                      addAutomaticKeepAlives: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: channel.isEmpty ? 0 : channel.length,
                      itemBuilder: (BuildContext context, int index) {
                        return (index < 6)
                            ? InkWell(
                                onTap: () {
                                  if (index == 5) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GridPage(
                                                  channel: channel,
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LiveTvPlayer(
                                                  channel: channel[index],
                                                )));
                                  }
                                },
                                child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 3.0),
                                          height: 200,
                                          width: 200,
                                          child: (index == 5)
                                              ? ImageBlur.network(
                                                  channel[index].channelimage,
                                                  scale: 2.5,
                                                  height: 200,
                                                  blur: 4,
                                                  overlay: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      //to be added icon
                                                      Icon(Icons.list,
                                                      size: 50,
                                                      color: Colors.white,
                                                      ),
                                                      Text(
                                                        "See More",
                                                        textAlign:
                                                            TextAlign.center,
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
                                              : Image.network(
                                                  channel[index].channelimage,
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ]),
                              )
                            : SizedBox();
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider()),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          );
  }
}
