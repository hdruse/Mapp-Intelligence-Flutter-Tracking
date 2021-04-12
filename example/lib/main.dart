import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:plugin_mappintelligence/plugin_mappintelligence.dart';
import 'package:plugin_mappintelligence_example/ActionTracking.dart';
import 'package:plugin_mappintelligence_example/Campaign.dart';
import 'package:plugin_mappintelligence_example/Details.dart';
import 'package:plugin_mappintelligence_example/Ecommerce.dart';
import 'package:plugin_mappintelligence_example/Media.dart';
import 'package:plugin_mappintelligence_example/PageTracking.dart';
import 'package:plugin_mappintelligence_example/Webview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build MyApp');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color(0xFF00BAFF),
          primaryColorDark: Color(0xFF0592D7),
          accentColor: Color(0xFF58585A),
          cardColor: Color(0xFF888888)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _platformVersion = 'Unknown';
  List<String> _screens = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PluginMappintelligence.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _screens = [
        "Configuration",
        "Page Tracking",
        "Action",
        "Campaign",
        "Ecommerce",
        "Webview",
        "Media"
      ];
      print('set state: $_screens');
    });
  }

  StatelessWidget _determineWidget(int index) {
    switch (index) {
      case 0:
        return DetailsView(index);
      case 1:
        return PageTracking();
      case 2:
        return ActionTracking();
      case 3:
        return Campaign();
      case 4:
        return Ecommerce();
      case 5:
        return WebviewApp();
      case 6:
        return Media();
      default:
        return DetailsView(index);
    }
  }

  ListView _buildListView(BuildContext context) {
    print('broj ekrana je: $_screens.length');
    PluginMappintelligence.initialize(
        [21322312, 231312312], 'www.testDomain.com');
    PluginMappintelligence.setLogLevel(1);
    PluginMappintelligence.setBatchSupportEnabled(true);
    PluginMappintelligence.setBatchSupportSize(150);
    PluginMappintelligence.setRequestInterval(60);
    PluginMappintelligence.setRequestPerQueue(300);

    return ListView.builder(
      itemCount: _screens.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(
              _screens[index],
              style: TextStyle(color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              print('On tap is pressed');
              print('this is $context and $index');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _determineWidget(index),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Mapp Intelligence Demo'),
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          body: _buildListView(context)),
    );
  }
}
