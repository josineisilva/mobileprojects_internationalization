import 'package:flutter/material.dart';
import '../utils/globaltranslations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translations.text('main_title'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              translations.text(
                (_counter==1)?'body_text_once':'body_text',
                ['$_counter']
              ),
              style: TextStyle(fontSize: 20.0)
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text(translations.text('button_en')),
            onPressed: () async {
              await translations.setNewLanguage('en',true);
              setState((){});
            },
          ),
          RaisedButton(
            child: Text(translations.text('button_pt')),
            onPressed: () async {
              await translations.setNewLanguage('pt_BR',true);
              setState((){});
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: translations.text('button_tooltip'),
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}