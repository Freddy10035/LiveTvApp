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
          child: Text(
            channel.isEmpty? "Loading" : channel[0].categoryname,
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
                    MaterialPageRoute(builder: (context) => GridPage(channel: channel,)));
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
    );
  }
}
