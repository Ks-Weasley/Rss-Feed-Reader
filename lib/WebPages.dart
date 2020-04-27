//list of social media

class WebPage {
  static final List<String> w=['Instagram','Facebook','Linkedin','News'];
}

//the one that builds the list
/*
 Widget MyList(){

    return ListView.builder(
        itemCount: WebPage.w.length,
        itemBuilder:(context,index) {
          final wordPair = WebPage.w[index];
          return Container(
            //padding: EdgeInsets.fromLTRB(0, 20, 80, 20),
              child: Column(
                  children: [ListTile(
                      title: Text(wordPair, style: TextStyle(fontSize: 20.0)),
                      onTap: () {
                        print(WebPage.w[index]);
                        if(WebPage.w[index]=='News')
                          Navigator.push(context,MaterialPageRoute(builder: (context)=> rssRead()));
                      }
                  ),Divider()
                  ])
          );
        }
    );
  }
 */