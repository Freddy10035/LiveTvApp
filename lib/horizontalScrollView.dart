import 'package:blur/blur.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'gridview.dart';
import 'youtubePlayer.dart';

class Scroll extends StatelessWidget {
  final List<String> channel;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Scroll(this.channel, this.analytics, this.observer);

  Future<void> _sendChannelInfo(FirebaseAnalytics a, List<String> c) async {
    await a.logEvent(name: "Tapped_Channel", parameters: <String, String>{
      "Channel_Name": c[0],
    });
  }

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
                      addAutomaticKeepAlives: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: channel.isEmpty ? 0 : channel.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LiveTvPlayer()));
                          },
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 3.0),
                                  height: 180,
                                  width: 180,
                                  child: Image(
                                    image: AssetImage(channel[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                    color: Colors.black12,
                                    width: 200,
                                    height: 25,
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ))
                              ]),
                        );
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
