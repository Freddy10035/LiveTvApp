import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import 'theme_manager.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      home: Registration(),
      theme: themeNotifier.getTheme(),
    );
  }
}

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();

  final googleLogin = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  GoogleSignInAccount _currentUser;
  Map userProfile;
  String s;
  bool loggedIn = false;
  TextEditingController _fullNameController;
  TextEditingController _emailController;
  TextEditingController _userNameController;
  TextEditingController _passwordController;

  login() async {
    final res = await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken accessToken = res.accessToken;
        print('Access token: ${accessToken.token}');

        final profile = await facebookLogin.getUserProfile();
        print('Hello, ${profile.name}! You ID: ${profile.userId}');

        final email = await facebookLogin.getUserEmail();
        if (email != null) print('And your email is $email');

        break;
      case FacebookLoginStatus.cancel:
        print('cancelled');

        break;
      case FacebookLoginStatus.error:
        print('Error while log in: ${res.error}');
        break;
    }
  }

  Future<void> createUser(
      String fullName, String email, String userName, String password) async {
    final response = await http.post(
      'https://example.com/signup.php',
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: {
        'fullname': fullName,
        'email': email,
        'username': userName,
        'password': password,
      },
    );

    s = response.body;
  }

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _userNameController = TextEditingController();
    googleLogin.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {}
    });
    googleLogin.signInSilently();
  }

  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        title: Text(
          "Sign Up",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          color: Colors.black,
          onPressed: () {
            //Navigator.pop(context); returns black screen
            Navigator.of(context, rootNavigator: true).pop(context);
          },
        ),
        actions: <Widget>[],
        backgroundColor: Colors.white,
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
              controller: _fullNameController,
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
                hintText: 'Full Name',
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
              controller: _emailController,
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
                hintText: 'Email',
                prefixIcon: IconButton(
                  icon: Icon(Icons.email_outlined),
                  splashColor: Colors.blue,
                  splashRadius: 5.0,
                  color: Colors.blue,
                  onPressed: () {},
                ),
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
                //fillColor: Colors.red,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 10.0,
          ),
          Container(
            //user name
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.black12,
            ),
            padding: EdgeInsets.only(left: 16),
            child: TextField(
              controller: _userNameController,
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
                  icon: Icon(Icons.supervised_user_circle),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.black12,
            ),
            padding: EdgeInsets.only(left: 16),
            child: TextField(
              controller: _passwordController,
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
                //hintMaxLines: 3,
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
              print(_fullNameController.text);
              print(_emailController.text);
              print(_userNameController.text);
              print(_passwordController.text);
              createUser(_fullNameController.text, _emailController.text,
                  _userNameController.text, _passwordController.text);
              //to be added

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
              child: const Text('Sign Up', style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(
            height: 50.0,
            width: double.infinity,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Already a User?",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 20.0,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 50.0,
            width: double.infinity,
          ),
          Column(
            children: [
              SignInButton(Buttons.Google, onPressed: () {
                _googleLogin();
                print(s);
              })
            ],
          ),
        ],
      ),
    );
  }

  _googleLogin() async {
// TODO: have to integrate for ios
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleLogin.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      createUser(googleSignInAccount.displayName, googleSignInAccount.email,
          googleSignInAccount.id, googleSignInAccount.photoUrl);
      print("Google sign in successful");
      Navigator.of(context, rootNavigator: true).pop(context);
    } catch (error) {
      print(error);
      print('G error');
    }
  }
}
