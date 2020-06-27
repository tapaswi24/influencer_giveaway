import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Profile {
  String _name;
  String _picture;
  String _birthday;
  String _email;
  List<Post> _posts;

  Profile.fromJson(Map<String, dynamic> json)
      : _name = json["name"],
        _picture = json["picture"]["data"]["url"],
        _birthday = json["birthday"],
        _email = json["email"],
        _posts = json["posts"]["data"]
            .map<Post>((post) => Post.fromJson(post))
            .toList();

  @override
  String toString() {
    return 'Profile{_name: $_name, _picture: $_picture, _birthday: $_birthday, _email: $_email, _posts: $_posts}';
  }
}

class Post {
  String _fullPicture;
  String _id;

  Post.fromJson(Map<String, dynamic> json)
      : _fullPicture = json["full_picture"],
        _id = json["id"];

  @override
  String toString() {
    return 'Post{_fullPicture: $_fullPicture, _id: $_id}';
  }
}

class UserProfile extends StatefulWidget {
  final FacebookLogin facebookLogin;
  Profile profile;

  UserProfile(this.facebookLogin, this.profile);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.profile._picture),
          ),
          title: RichText(text: TextSpan(
            children: [
              TextSpan(text: "${widget.profile._name}\n"),
              TextSpan(text: "Birth date: ${widget.profile._birthday}\n", style: TextStyle(fontSize: 10)),
              TextSpan(text: "Email: ${widget.profile._email}", style: TextStyle(fontSize: 10)),
            ]
          )),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.power_settings_new), onPressed: () {
              widget.facebookLogin.logOut().then((value) =>
                  Navigator.of(context).pop());
            })
          ],
        ),
        body: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(

                child: Image.network(
                  widget.profile._posts[index]._fullPicture ?? ""),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: widget.profile._posts.length));
  }
}
