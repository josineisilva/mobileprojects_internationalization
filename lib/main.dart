import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/home.dart';
import 'utils/globaltranslations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes the translation module
  await translations.init();
  // then start the application
  runApp( MyApp(),);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    // Initializes a callback should something need
    // to be done when the language is changed
    translations.onLocaleChangedCallback = _onLocaleChanged;
  }

  // If there is anything special to do when the user changes the language
  _onLocaleChanged() async {
    // do anything you need to do if the language changes
    print('Language has been changed to: ${translations.currentLanguage}');
  }

  // Main initialization
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which are the supported languages
      supportedLocales: translations.supportedLocales(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}