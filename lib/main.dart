import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:influencer_giveaway/UserPageLikes.dart';
import 'package:influencer_giveaway/UserProfile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> listOfPermission;
  final facebookLogin = FacebookLogin();
  var pageToken;

  @override
  void initState() {
    listOfPermission = [
      "user_likes",
      "pages_show_list",
      "business_management",
      "pages_read_engagement",
      "pages_manage_metadata",
      "pages_read_user_content",
      "pages_manage_ads",
      "public_profile"
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(onPressed: ()=> _loginWithFB(), child: Text("Login with facebook"),),
            /*Divider(),
            userProfile == null ? Offstage() : Image.network(userProfile["picture"]["data"]["url"]),
            Divider(),
            OutlineButton(onPressed: ()=> _logout(), child: Text("Login with facebook"),),*/
          ],
        )
      ),
    );
  }

  _loginWithFB() async{
    List<UserPageModel> userPagesList;
    Profile profile;
    final result = await facebookLogin.logIn(listOfPermission);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(

            'https://graph.facebook.com/v7.0/me?fields=likes%7Blink%2Cname%2Cbio%2Cpicture%2Cbusiness%7D&access_token=$token');
        List response = jsonDecode(graphResponse.body)["likes"]["data"];

        userPagesList = response.map((e) => UserPageModel.fromJson(e)).toList();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPages(userPagesList)));
//        print('${graphResponse.body}');


//        profile = Profile.fromJson(jsonDecode(graphResponse.body));
//        print(profile);
//        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfile(facebookLogin, profile)));
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }

  }
  _logout(){
    facebookLogin.logOut();
    /*setState(() {
      _isLoggedIn = false;
    });*/
  }
}
