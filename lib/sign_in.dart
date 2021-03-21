import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'model/sign_in_model.dart';
import 'theme_manager.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),
      home: LogIn(),
    );
  }
}

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String s;
  TextEditingController _userName;
  TextEditingController _password;

  Future<UserSignIn> signInUser(String username, String password) async {
    final response = await http.post(
      'https://example.com/login.php',
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: {'username': username, 'password': password},
    );

    s = jsonDecode(response.body);
    return UserSignIn.fromJson(jsonDecode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _userName = TextEditingController();
    _password = TextEditingController();
  }

  void dispose() {
    _userName.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign In",
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(context);
          },
        ),
        actions: <Widget>[],
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.black12,
            ),
            padding: EdgeInsets.only(left: 16),
            child: TextField(
              controller: _userName,
              enableInteractiveSelection: true,
              enableSuggestions: true,
              cursorColor: Colors.red,
              cursorWidth: 2,
              cursorHeight: 20,
              autofocus: false,
              onSubmitted: (string) {},
              onChanged: (string) {},
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'User Name',
                prefixIcon: IconButton(
                  icon: Icon(Icons.drive_file_rename_outline),
                  splashColor: Colors.blue,
                  splashRadius: 5.0,
                  color: Colors.blue,
                  onPressed: () {},
                ),
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 10.0,
          ),
          Container(
            //email
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.black12,
            ),
            padding: EdgeInsets.only(left: 16),
            child: TextField(
              controller: _password,
              enableInteractiveSelection: true,
              enableSuggestions: true,
              cursorColor: Colors.red,
              cursorWidth: 2,
              cursorHeight: 20,
              autofocus: false,
              onSubmitted: (string) {},
              onChanged: (string) {},
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: IconButton(
                  icon: Icon(Icons.lock),
                  splashColor: Colors.blue,
                  splashRadius: 5.0,
                  color: Colors.blue,
                  onPressed: () {},
                ),
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 30.0,
          ),
          RaisedButton(
            onPressed: () {
              signInUser(_userName.text, _password.text);

              Navigator.of(context, rootNavigator: true).pop(context);
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text('Sign In', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
