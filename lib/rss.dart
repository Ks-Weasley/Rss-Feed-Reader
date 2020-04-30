import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import 'apiData.dart';
import 'webview.dart';

class FavIcon {
  String title;
  String link;

  FavIcon({this.title, this.link});
}

Future<Welcome> feed() async {
  final Xml2Json xml2Json = Xml2Json();
  final response = await http.get(
      "https://www.google.com/alerts/feeds/11016768836951419989/3365315696613981974");
  if (response.statusCode == 200) {
    xml2Json.parse(response.body);
    var jsonString = xml2Json.toGData();
    return welcomeFromJson(jsonString);
  } else
    throw ('Failed to load data');
}

class RssRead extends StatefulWidget {
  @override
  _RssReadState createState() => _RssReadState();
}

class _RssReadState extends State<RssRead> {
  final String url =
      "https://www.google.com/alerts/feeds/11016768836951419989/3365315696613981974";
  Future<Welcome> futureRssContent;
  List<FavIcon> favIcon = new List<FavIcon>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureRssContent = feed();
  }

  void changeState(String element, String link) {
    FavIcon temp = FavIcon(title: element, link: link);
    int index = favIcon.map<String>((temp) => temp.link).toList().indexOf(link);
    setState(() {
      if (favIcon.map<String>((temp) => temp.link).toList().contains(link))
        favIcon.removeAt(index);
      else
        favIcon.add(temp);
      print(favIcon.map<String>((temp) => temp.title).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Favourite List',
                    style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent[100],
              ),
            ),
            Column(
              children: favIcon
                  .map((FavIcon x) =>
                  Column(
                    children: <Widget>[
                      ListTile(
                        title:
                        Text(x.title, style: TextStyle(fontSize: 20.0)),
                        onTap: () => goToScreen(context, x.link, x.title),
                      ),
                      Divider()
                    ],
                  ))
                  .toList(),
            )
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: AppBar(
          title: Text("NEWS"),
          backgroundColor: Colors.lightBlueAccent[100],
        ),
      ),
      body: myBuild(),
    );
  }

  Widget myBuild() {
    return FutureBuilder<Welcome>(
        future: futureRssContent,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press again to start.');
              break;
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
              break;
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return ListView.builder(
                  itemCount: snapshot.data.reports.entry.length,
                  //feed.items.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data.reports.entry[index];
                    return Card(
                        child: Column(
                          children: <Widget>[
                            InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                //LATER: ENTER THE HREF},
                                onTap: () {
                                  print(item.link);
                                  goToScreen(context, item.link.href,
                                      _parseHtmlString(item.title.t));
                                },
                                child: ListTile(
                                  title: Text(_parseHtmlString(item.title.t),
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                      "Published on " +
                                          item.updated.t.substring(0, 10),
                                      style: TextStyle(color: Colors.black)),
                                  contentPadding: EdgeInsets.all(16.0),
                                )),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: favIcon
                                    .map<String>((temp) => temp.link)
                                    .toList()
                                    .contains(item.link.href)
                                    ? Icon(Icons.favorite)
                                    : Icon(Icons.favorite_border),
                                color: Colors.red,
                                onPressed: () =>
                                    changeState(
                                        _parseHtmlString(item.title.t),
                                        item.link.href),
                              ),
                            )
                          ],
                        ));
                  });
          }

          return Align(
              alignment: Alignment.center, child: CircularProgressIndicator());
        });
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  goToScreen(context, String link, String title) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WebViewContainer(
                    link,
                    favIcon
                        .map<String>((temp) => temp.link)
                        .toList()
                        .contains(link))));
    if (result) changeState(title, link);
  }
}
