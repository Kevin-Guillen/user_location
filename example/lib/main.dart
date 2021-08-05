import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:user_location_plugin/user_location_plugin.dart';
import 'utils/buttons_strings.dart';
import 'widgets/buttons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await UserLocationPlugin.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
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
            ButtonsStrings.title,
          ),
        ),
        body: Center(
          child: Column(
            children: [
              ButtonWidget(
                onPressed: () {
                  UserLocationPlugin.requestPermission;
                },
                buttonText: ButtonsStrings.requestButtonText,
              ),
              ButtonWidget(
                onPressed: () {
                  UserLocationPlugin.checkPermission;
                },
                buttonText: ButtonsStrings.checkButtonText,
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
                          '',
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
