// To parse this JSON data, do
//
//     final modelFeature = modelFeatureFromMap(jsonString);

import 'dart:convert';

class ModelFeature {
  ModelFeature({
    this.the0,
    this.the1,
    this.the2,
    this.the3,
    this.the4,
    this.the5,
    this.the6,
    this.the7,
    this.channelid,
    this.channelname,
    this.channelimage,
    this.title,
    this.channelurl,
    this.featureid,
    this.featurename,
    this.featureimagepath,
  });

  final String the0;
  final String the1;
  final String the2;
  final String the3;
  final String the4;
  final String the5;
  final String the6;
  final String the7;
  final String channelid;
  final String channelname;
  final String channelimage;
  final String title;
  final String channelurl;
  final String featureid;
  final String featurename;
  final String featureimagepath;

  // factory ModelFeature.fromJson(String str) =>
  //     ModelFeature.fromMap(json.decode(str));
  //
  // String toJson() => json.encode(toMap());
  factory ModelFeature.fromRawJson(String str) =>
      ModelFeature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelFeature.fromJson(Map<String, dynamic> json) => ModelFeature(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        the3: json["3"],
        the4: json["4"],
        the5: json["5"],
        the6: json["6"],
        the7: json["7"],
        channelid: json["channelid"],
        channelname: json["channelname"],
        channelimage: json["channelimage"],
        title: json["title"],
        channelurl: json["channelurl"],
        featureid: json["featureid"],
        featurename: json["featurename"],
        featureimagepath: json["featureimagepath"],
      );

  Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "3": the3,
        "4": the4,
        "5": the5,
        "6": the6,
        "7": the7,
        "channelid": channelid,
        "channelname": channelname,
        "channelimage": channelimage,
        "title": title,
        "channelurl": channelurl,
        "featureid": featureid,
        "featurename": featurename,
        "featureimagepath": featureimagepath,
      };
}
