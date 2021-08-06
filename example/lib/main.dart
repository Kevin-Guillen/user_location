import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:user_location_plugin/user_location_plugin.dart';
import 'utils/strings.dart';
import 'widgets/buttons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = Strings.defaultPlatformVersion;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await UserLocationPlugin.platformVersion ??
          Strings.unknownPlatformVersion;
    } on PlatformException {
      platformVersion = Strings.failAtGettingPlatformVersion;
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.title,
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                '${Strings.runningOn} $_platformVersion\n',
              ),
              ButtonWidget(
                onPressed: () {
                  UserLocationPlugin.requestPermission;
                },
                buttonText: Strings.requestButtonText,
              ),
              ButtonWidget(
                onPressed: () {
                  UserLocationPlugin.checkPermission;
                },
                buttonText: Strings.checkButtonText,
              ),
              StreamBuilder(
                stream: UserLocationPlugin.permissionEventChannelStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<dynamic> snapshot,
                ) {
                  return snapshot.hasData
                      ? Text(
                          snapshot.data.toString(),
                        )
                      : Text(
                          Strings.emptyString,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
