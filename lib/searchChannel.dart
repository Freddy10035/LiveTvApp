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
          title: Text("Search",
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
          Container(
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

                      autofocus: false,
                      onSubmitted: (string){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Search(channel: channel,string: string,
                                )));
                      },
                      // onChanged: (string) {
                      //   setState(() {
                      //     filteredChannel = allChannels
                      //         .where((element) => (element.channelname
                      //             .toLowerCase()
                      //             .contains(string.toLowerCase())))
                      //         .toList();
                      //   });
                      // },
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
                        suffixIcon: Icon(Icons.search),
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                        //fillColor: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          check() ? InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LiveTvPlayer(
                        channel: foundChannel,
                      )));
            },
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                height: 200,
                width: 200,
                child: Image.network(
                  foundChannel.channelimage,
                )

              //decoration: BoxDecoration(),

              //decoration: BoxDecoration,
            ),
          )
              : Text("Not Found")
        ],
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   final List<ModelChannel> channel1;
//   final String string1;
//
//   const MyHomePage({Key key, this.channel1, this.string1}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState(channel1,string1);
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController _controller;
//   final List<ModelChannel> channel2;
//   final String string2;
//
//   _MyHomePageState(this.channel2, this.string2);
//
//   ModelChannel foundChannel;
//
//   bool check(){
//     bool found=false;
//     channel2.forEach((element) {
//       if(element.channelname == string2){
//         foundChannel=element;
//         found=true;
//       }
//
//     });
//     return found;
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _controller = TextEditingController();
//   }
//
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Text(
//             "Search",
//             style: TextStyle(color: Colors.black),
//           ),
//           leading: IconButton(
//             icon: Icon(Icons.chevron_left),
//             color: Colors.black,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           )
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             height: 44,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(32),
//               color: Colors.black12,
//               //boxShadow: kElevationToShadow[6],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(left: 16),
//                     child: TextField(
//                       controller: _controller,
//                       autofocus: false,
//                       onSubmitted: (string){
//
//                       },
//                       // onChanged: (string) {
//                       //   setState(() {
//                       //     filteredChannel = allChannels
//                       //         .where((element) => (element.channelname
//                       //             .toLowerCase()
//                       //             .contains(string.toLowerCase())))
//                       //         .toList();
//                       //   });
//                       // },
//                       //autofillHints:
//                       // buildCounter: (
//                       //   BuildContext context, {
//                       //   int currentLength,
//                       //   int maxLength,
//                       //   bool isFocused,
//                       // }) {
//                       //   return Text(
//                       //     '$currentLength of $maxLength characters',
//                       //     semanticsLabel: 'character count',
//                       //   );
//                       // },
//                       onTap: () {},
//                       //readOnly: true,
//                       textAlign: TextAlign.center,
//                       decoration: InputDecoration(
//                         floatingLabelBehavior: FloatingLabelBehavior.auto,
//                         // counter: ListView.builder(
//                         //     padding: const EdgeInsets.all(8),
//                         //     itemCount: filteredChannel.length,
//                         //     itemBuilder: (BuildContext context, int index) {
//                         //       return Container(
//                         //         height: 50,
//                         //         child: Center(child: Text(filteredChannel[index].channelname)),
//                         //       );
//                         //     }
//                         // ),
//                         //counterText: ,
//                         hintText: 'Search Channel Name',
//                         suffixIcon: Icon(Icons.search),
//                         hintStyle: TextStyle(color: Colors.black54),
//                         border: InputBorder.none,
//                         //fillColor: Colors.red,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//          Row(
//            children: [
//              check() ? InkWell(
//                onTap: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => LiveTvPlayer(
//                            channel: foundChannel,
//                          )));
//                },
//                child: Container(
//                  decoration: BoxDecoration(
//                    //  borderRadius: BorderRadius.all(Radius.circular(12)),
//                    image: DecorationImage(
//                      image: NetworkImage(foundChannel.channelimage),
//                      fit: BoxFit.cover,
//                    ),
//                  ),
//                ),
//              )
//                  : Text("Not Found")
//            ],
//          ),
//         ],
//       ),
//     );
//   }
// }
