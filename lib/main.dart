import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return MaterialApp(
      title: "Welcome to Flutter",
      home: new RandomWords(),
    );
  }

}

class RandomWordsState extends State <RandomWords> {

  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    void _pushSaved(){
      Navigator.of(context).push(new MaterialPageRoute(builder: (context){
        final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return new ListTile(
                title: Text(pair.asPascalCase, style: _biggerFont,),
              ) ;
            }
        )   ;
        final List<Widget> divided = ListTile.divideTiles(tiles: tiles,context: context).toList();
        return new Scaffold(
          appBar: AppBar(title : Text("Saved Suggestions")),
          body: new ListView(children: divided),
        );
      }));
    }
    Widget _buildRow(WordPair pair) {
      final bool alreadySaved = _saved.contains(pair);
      return new ListTile(
        title: new Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: new Icon(
          alreadySaved? Icons.favorite: Icons.favorite_border,
          color: alreadySaved? Colors.red : null,
        ),
        onTap: (){
          setState(() {
            if(alreadySaved)
              _saved.remove(pair);
            else {
              _saved.add(pair);
            }
          });
        },
      );
    }
    Widget _buildSuggestions(){
      return new ListView.builder(itemBuilder: (_, int i) {
        if (i.isOdd) {
          return new Divider();
        }
        final int index = i ~/ 2;
        if (index >= _suggestions.length)
        {
          _suggestions.addAll(generateWordPairs().take(10));

        }
        return _buildRow(_suggestions[index]);
      });
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Startup Name Generator"),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomWordsState();
  }

}