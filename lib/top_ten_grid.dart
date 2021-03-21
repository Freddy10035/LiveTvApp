import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'model/modelChannel.dart';
import 'youtubePlayer.dart';

class TopGridPage extends StatelessWidget {
  List<ModelChannel> parseChannel(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ModelChannel>((json) => ModelChannel.fromJson(json))
        .toList();
  }

  Future<List<ModelChannel>> getData(http.Client client) async {
    final response = await http.get('https://example.com/toptenchannels.php');
    if (response.statusCode == 200) {
      return parseChannel(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Top 10 Channels",
            ),
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: FutureBuilder(
          future: getData(http.Client()),
          builder: (context, snap) {
            return (snap.hasData)
                ? GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: List.generate(snap.data.length, (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings:
                                      RouteSettings(name: 'youtube player'),
                                  builder: (context) => LiveTvPlayer()));
                        },
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  snap.data[index].channelimage,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 16,
                            child: Text(
                              snap.data[index].channelname,
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
                    }))
                : Container();
          },
        ));
  }
}
