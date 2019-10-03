import 'package:flutter/material.dart';
import 'theme.dart';
import 'ThemeNotifier.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:day_night_switch/day_night_switch.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? true;

      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          builder: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
          child: MyApp(),
        ),
      );

    });
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Dark Theme',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _darkTheme = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return Scaffold(
      appBar: AppBar(
        title: Text("Dark Theme"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Dark Theme'),
            contentPadding: const EdgeInsets.only(left: 16.0),
            trailing: Transform.scale(
              scale: 0.4,
              child: DayNightSwitch(
                value: _darkTheme,
                onChanged: (val) {
                  setState(() {
                    _darkTheme = val;
                  });
                  onThemeChanged(val, themeNotifier);
                },
              ),
            ),
          )
        ],
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}
