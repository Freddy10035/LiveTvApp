import 'package:flutter/material.dart';

import 'package:live_tv_app/gridview.dart';
import 'package:live_tv_app/modelChannel.dart';

class CountryName extends StatelessWidget {
  final List<ModelChannel> channel;

  CountryName(this.channel);

  @override
  Widget build(BuildContext context) {
    return Row(
      // first listview
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              channel.isEmpty ? "Loading" : channel[0].categoryname,
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
        Expanded(
            child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GridPage(
                          channel: channel,
                        )));
          },
          child: channel.length > 5
              ? Container(
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
                )
              : SizedBox(
                  height: 1,
                  width: 1,
                ),
        )),
      ],
    );
  }
}
