import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'dart:async';
import 'package:html/parser.dart';
import 'webview.dart';
//here goes the function

class FavIcon {
  String title;
  String link;
  FavIcon({this.title, this.link});
}

class RssRead extends StatefulWidget {
  @override
  _RssReadState createState() => _RssReadState();
}

class _RssReadState extends State<RssRead> {
  final String url = "https://www.google.com/alerts/feeds/11016768836951419989/3365315696613981974";

  Future<AtomFeed> getFeed() =>
      http.read(url).then((xmlString) => AtomFeed.parse(xmlString));

  Future<AtomFeed> feed() async {
    return await _RssReadState().getFeed();
  }

  List<FavIcon> favIcon= new List<FavIcon>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Align(alignment: Alignment.bottomCenter,child: Text('Favourite List',
                style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold, color: Colors.white),)),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent[100],
              ),
            ),
            Column(
            children:favIcon.map((FavIcon x)=> Column(
              children: <Widget>[
                ListTile(
                    title: Text(x.title,style: TextStyle(fontSize: 20.0)),
                    onTap: ()=> goToScreen(context, x.link, x.title),
                ),
              Divider()],
            )).toList(),
          )],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: AppBar(title: Text("NEWS"),backgroundColor: Colors.lightBlueAccent[100],
    ),
      ),
      body: myBuild(),
    );
  }

  void changeState(String element, String link){
    FavIcon temp=FavIcon(title:element, link: link);
    int index= favIcon.map<String>((temp)=> temp.link).toList().indexOf(link);
    setState(() {
      if(favIcon.map<String>((temp)=> temp.link).toList().contains(link))
        favIcon.removeAt(index);
      else
        favIcon.add(temp);
      print(favIcon.map<String>((temp)=> temp.title).toList());
    });
  }

  Widget myBuild() {
    return FutureBuilder<AtomFeed>(
        future: feed(),
        builder: (BuildContext context, AsyncSnapshot<AtomFeed> snapshot) {
          switch (snapshot
              .connectionState) { //checks for the condition of connection- none, active, waiting, done
            case ConnectionState.none:
              return Text('Press again to start.');
              break;
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Align(alignment: Alignment.center,
                  child: CircularProgressIndicator());
              break;
            case ConnectionState
                .done: // if done- checks if error is returned. If not builds the list tile
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              return ListView.builder(
                  itemCount: snapshot.data.items.length, //feed.items.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data.items[index];
                    return Card(
                        child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                             //LATER: ENTER THE HREF},

                            child: ListTile(
                            title: Text(_parseHtmlString(item.title),
                                style: TextStyle(color: Colors.black38,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text("Published on " +
                                item.published.substring(0, 10),
                                style: TextStyle(
                                    color: Colors.black)),
                            contentPadding: EdgeInsets.all(16.0),
                            onTap: () {
                              print(item.links[0].href);
                              // Navigator.push(context,MaterialPageRoute(builder: (context)=> WebViewContainer(item.links[0].href)));
                              goToScreen(context, item.links[0].href, _parseHtmlString(item.title));
                            } ,
                              trailing: IconButton(
                                icon: favIcon.map<String>((temp)=> temp.link).toList().contains(item.links[0].href)? Icon(Icons.favorite):Icon(Icons.favorite_border),
                                color: Colors.red,
                                onPressed: () =>
                                    changeState(_parseHtmlString(item.title), item.links[0].href),
                              ),
                                )
                    ));
                  });
          }

          return Align(alignment: Alignment.center,
              child: CircularProgressIndicator());
        });
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  goToScreen(context, String link, String title) async {
    var result = await Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            WebViewContainer(link, favIcon.map<String>((temp)=> temp.link).toList().contains(link))));
    if (result)
      changeState(title, link);
  }
}