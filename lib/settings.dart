import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_us.dart';
import 'privacy_policy.dart';
import 'storage_manager.dart';
import 'theme_manager.dart';

//import 'package:flutter_switch/flutter_switch.dart';
Color c = Color(0xffee9aad);

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),

      //debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String version = "";

  static bool status7 = true;

  getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    getVersion();
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        setState(() {
          status7 = false;
        });
      } else {
        print('setting dark theme');
        setState(() {
          status7 = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(context);
          },
        ),
        title: Text(
          "Settings",
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50.0,
                      width: 50.0,
                      margin: EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c,
                      ),
                      child: Icon(
                        Icons.brightness_4,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "Dark Mode",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  width: 150.0,
                ),
              ),
              Expanded(
                flex: 2,
                child: Switch(
                  value: status7,
                  onChanged: (value) {
                    setState(() {
                      status7 = value;
                      if (value == false) {
                        ThemeNotifier().setLightMode();
                      } else {
                        ThemeNotifier().setDarkMode();
                      }
                    });
                    final result = FlutterRestart.restartApp();
                    print(result);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff9aacee),
                ),
                child: Icon(
                  Icons.list_alt,
                  color: Colors.blue,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()));
                },
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffc4ee9a),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.green,
                ),
              ),
              Text(
                "Version",
                style: TextStyle(fontSize: 24),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "- $version",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffcecaad),
                ),
                child: Icon(
                  Icons.insert_drive_file_outlined,
                  color: Colors.yellow,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          //settings: RouteSettings(name: 'privacy policy'),
                          builder: (context) => AboutUs()));
                },
                child: Text(
                  "About Us",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffce91cb),
                ),
                child: Icon(
                  Icons.mail_outline_sharp,
                  color: Colors.purple,
                ),
              ),
              InkWell(
                onTap: () {
                  _launchURL("example@gmail.com", "Contact Us", "");
                },
                child: Text(
                  "Contact Us",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              _share(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffa0c2d7),
                  ),
                  child: Icon(
                    Icons.share,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  "Share Us",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _share(BuildContext b) async {
    await Share.share("https://play.google.com");
  }
}
