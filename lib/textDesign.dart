import 'package:flutter/material.dart';

import 'gridview.dart';

class CountryName extends StatelessWidget {
  final List<String> list;

  const CountryName({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // first listview
      children: <Widget>[
        (list.length == 0)
            ? SizedBox(
                height: 0.1,
              )
            : Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Movies",
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
                          settings: RouteSettings(name: 'Grid View'),
                          builder: (context) => GridPage(
                                list: list,
                              )));
                },
                child: Container(
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
                ))),
      ],
    );
  }
}
