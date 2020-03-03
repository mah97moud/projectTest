import 'package:flutter/material.dart';
import 'package:random_words/random_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Word Game',
      home: new RandomSentenses(),
    );
  }
}

class RandomSentenses extends StatefulWidget {
  @override
  _RandomSentensesState createState() => _RandomSentensesState();
}

class _RandomSentensesState extends State<RandomSentenses> {
  final _sentence = <String>[];
  final _funnies = new Set<String>();
  final _biggerFont = const TextStyle(fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Word Game'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.list,
            ),
            onPressed: _pushFunies,
          ),
        ],
      ),
      body: _buildSentences(),
    );
  }

  void _pushFunies() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _funnies.map(
            (sentence) {
              return new ListTile(
                title: new Text(
                  sentence,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Funny Sentence'),
            ),
            body: new ListView(
              children: divided,
            ),
          );
        },
      ),
    );
  }

  String _getSentence() {
    final noun = new WordNoun.random();
    final adective = new WordAdjective.random();
    return 'The Programmer wrote a ${adective.asCapitalized} '
        'app in Flutter and showed it'
        'aff to his ${noun.asCapitalized}';
  }

  Widget _buildSentences() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;

        if (i >= _sentence.length) {
          for (var i = 0; i < 10; i++) {
            _sentence.add(_getSentence());
          }
        }
        return _builderRow(_sentence[index]);
      },
    );
  }

  Widget _builderRow(String sentence) {
    final alreadyFoundFunny = _funnies.contains(sentence);
    return new ListTile(
      title: new Text(
        sentence,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadyFoundFunny ? Icons.favorite : Icons.favorite_border,
        color: alreadyFoundFunny ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadyFoundFunny) {
            _funnies.remove(sentence);
          } else {
            _funnies.add(sentence);
          }
        });
      },
    );
  }
}
