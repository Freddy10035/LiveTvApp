import 'package:flutter/material.dart';

import 'package:live_tv_app/modelChannel.dart';
import 'package:live_tv_app/youtubePlayer.dart';

void main() {
  // runApp(GridPage());
}

class Search extends StatelessWidget {
  final List<ModelChannel> filteredChannel;
  final List<ModelChannel> allChannel;
  final String string;

  const Search({Key key, this.filteredChannel, this.allChannel, this.string})
      : super(key: key);

  // ModelChannel foundChannel;
  //
  // bool check(){
  //   bool found=false;
  //   channel.forEach((element) {
  //     if(element.channelname == string){
  //       foundChannel=element;
  //       found=true;
  //     }
  //
  //   });
  //   return found;
  // }

  // This widget is the root of your application.
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
          )
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          ),
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
                                    builder: (context) => LiveTvPlayer(
                                          channel: filteredChannel[index],
                                        )));
                          },
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    //  borderRadius: BorderRadius.all(Radius.circular(12)),
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
  List<ModelChannel> filteredChannel = new List();
  final myController = TextEditingController();
  bool string = true;

  _SearchChannelsState(this.channel, this.channel2);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //search bar
      width: 320,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.black12,
        //boxShadow: kElevationToShadow[6],
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
                //autofillHints:
                // buildCounter: (
                //   BuildContext context, {
                //   int currentLength,
                //   int maxLength,
                //   bool isFocused,
                // }) {
                //   return Text(
                //     '$currentLength of $maxLength characters',
                //     semanticsLabel: 'character count',
                //   );
                // },
                onTap: () {},
                //readOnly: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  //errorText: string? null: "Input Channel Name",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  // counter: ListView.builder(
                  //     padding: const EdgeInsets.all(8),
                  //     itemCount: filteredChannel.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Container(
                  //         height: 50,
                  //         child: Center(child: Text(filteredChannel[index].channelname)),
                  //       );
                  //     }
                  // ),
                  //counterText: ,
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
