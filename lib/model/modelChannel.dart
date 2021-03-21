import 'dart:convert';

class ModelChannel {
  final String the0;
  final String the1;
  final String the2;
  final String the3;
  final String the4;
  final The5 the5;
  final String the6;
  final String channelid;
  final String channelname;
  final String channeltype;
  final String categoryname;
  final String channelimage;
  final The5 title;
  final String channelurl;

  ModelChannel({
    this.the0,
    this.the1,
    this.the2,
    this.the3,
    this.the4,
    this.the5,
    this.the6,
    this.channelid,
    this.channelname,
    this.channeltype,
    this.categoryname,
    this.channelimage,
    this.title,
    this.channelurl,
  });

  factory ModelChannel.fromRawJson(String str) =>
      ModelChannel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelChannel.fromJson(Map<String, dynamic> json) => ModelChannel(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        the3: json["3"],
        the4: json["4"],
        the5: the5Values.map[json["5"]],
        the6: json["6"],
        channelid: json["channelid"],
        channelname: json["channelname"],
        channeltype: json["channeltype"],
        categoryname: json["categoryname"],
        channelimage: json["channelimage"],
        title: the5Values.map[json["title"]],
        channelurl: json["channelurl"],
      );

  Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "3": the3,
        "4": the4,
        "5": the5Values.reverse[the5],
        "6": the6,
        "channelid": channelid,
        "channelname": channelname,
        "channeltype": channeltype,
        "categoryname": categoryname,
        "channelimage": channelimage,
        "title": the5Values.reverse[title],
        "channelurl": channelurl,
      };
}

enum The5 { AMR_TV_LIVE }

final the5Values = EnumValues({"Amr Tv Live": The5.AMR_TV_LIVE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
