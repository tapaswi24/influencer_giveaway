import 'package:flutter/material.dart';

class UserPageModel{
  String link;
  String name;
  String id;
  Picture picture;

  UserPageModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        link = json["link"],
        id = json["id"],
        picture = Picture.fromJson(json["picture"]["data"]);


  @override
  String toString() {
    return 'UserPageModel{_link: $link, _name: $name, id: $id}';
  }


}

class Picture{
  int height;
  bool is_silhouette;
  String url;
  int width;

  Picture.fromJson(Map<String, dynamic> json)
      : height = json["height"],
        is_silhouette = json["is_silhouette"],
        url = json["url"],
        width = json["width"];

  @override
  String toString() {
    return 'Picture{_height: $height, _is_silhouette: $is_silhouette, _url: $url, _width: $width}';
  }

}


class UserPages extends StatefulWidget {
  final List<UserPageModel> list;

  UserPages(this.list);

  @override
  _UserPagesState createState() => _UserPagesState();
}

class _UserPagesState extends State<UserPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.separated(
          itemCount: widget.list.length,
          itemBuilder: (context,index){
            return Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Image.network(widget.list[index].picture.url,
                      height: widget.list[index].picture.height.toDouble(),
                      width: widget.list[index].picture.width.toDouble(),),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(widget.list[index].name)),
                        Divider(),
                        Text(widget.list[index].link),
                        Divider(),
                        Text("ID: ${widget.list[index].id}"),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index){
              return Padding(padding: EdgeInsets.symmetric(vertical: 10));
          },
        ),
      ),
    );
  }
}
