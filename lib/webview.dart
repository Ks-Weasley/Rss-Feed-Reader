// navigates to a new page internal to the app when chosen from the list tile
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewContainer extends StatefulWidget {
  final url;
  final bool press;
  WebViewContainer(this.url, this.press);
  @override
  createState() => _WebViewContainerState(this.url, this.press, this.press);
}
class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  bool press, presst;
  final _key = UniqueKey();

  _WebViewContainerState(this._url, this.press, this.presst);
  changeState(){
    setState(()=> press=!presst);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=> Navigator.pop(context, press!= presst),),
          actions: <Widget>[
            IconButton(
              icon: (press)?Icon(Icons.favorite): Icon(Icons.favorite_border ),
              color: Colors.red,
              onPressed: (){ changeState();
          },),],
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ,]

        )
    , );
  }
}