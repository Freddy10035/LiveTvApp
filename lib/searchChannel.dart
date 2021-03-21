import 'package:flutter/material.dart';

import 'model/modelChannel.dart';
import 'youtubePlayer.dart';

class Search extends StatelessWidget {
  final List<ModelChannel> filteredChannel;
  final List<ModelChannel> allChannel;
  final String string;

  const Search({Key key, this.filteredChannel, this.allChannel, this.string})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Search",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            width: double.infinity,
          ),
          SearchChannels(
              string: string, channel: filteredChannel, channel2: allChannel),
          SizedBox(
            height: 10,
          ),
          (filteredChannel.isNotEmpty)
              ? Expanded(
                  child: GridView.count(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      addAutomaticKeepAlives: false,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: List.generate(filteredChannel.length, (index) {
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
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        filteredChannel[index].channelimage,
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
                                    filteredChannel[index].channelname,
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
                      })),
                )
              : Text("Not Found")
        ],
      ),
    );
  }
}

class SearchChannels extends StatefulWidget {
  final List<ModelChannel> channel;
  final List<ModelChannel> channel2;
  final String string;

  const SearchChannels({Key key, this.channel, this.channel2, this.string})
      : super(key: key);

  @override
  _SearchChannelsState createState() => _SearchChannelsState(channel, channel2);
}

class _SearchChannelsState extends State<SearchChannels> {
  final List<ModelChannel> channel;
  final List<ModelChannel> channel2;
  List<ModelChannel> filteredChannel = [];
  final myController = TextEditingController();
  bool string = true;

  _SearchChannelsState(this.channel, this.channel2);

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.black12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: TextField(
                controller: myController,
                autofocus: false,
                onSubmitted: (string) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Search(
                                filteredChannel: channel,
                                string: string,
                                allChannel: channel2,
                              )));
                },
                onChanged: (string) {
                  setState(() {
                    filteredChannel = channel2
                        .where((element) => (element.channelname
                            .toLowerCase()
                            .contains(string.toLowerCase())))
                        .toList();
                  });
                },

                onTap: () {},
                //readOnly: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,

                  hintText: 'Search Channel Name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    splashColor: Colors.blue,
                    splashRadius: 5.0,
                    color: Colors.blue,
                    onPressed: () {
                      if (myController.text.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Search(
                                      filteredChannel: filteredChannel,
                                      string: myController.text,
                                      allChannel: channel2,
                                    )));
                      } else {
                        setState(() {
                          string = false;
                        });
                      }
                    },
                  ),
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                  //fillColor: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
