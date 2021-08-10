import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:user_location_plugin/user_location_plugin.dart';
import 'utils/ui_constants.dart';
import 'widgets/buttons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = UiConstants.defaultPlatformVersion;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await UserLocationPlugin.platformVersion ??
          UiConstants.unknownPlatformVersion;
    } on PlatformException {
      platformVersion = UiConstants.failAtGettingPlatformVersion;
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
            UiConstants.title,
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                '${UiConstants.runningOn} $_platformVersion\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: UiConstants.platformFontSize,
                ),
              ),
              ButtonWidget(
                onPressed: () {
                  UserLocationPlugin.requestPermission;
                },
                buttonText: UiConstants.requestButtonText,
              ),
              ButtonWidget(
                onPressed: () {
                  UserLocationPlugin.checkPermission;
                },
                buttonText: UiConstants.checkButtonText,
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
                          UiConstants.emptyString,
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
