import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ui/screens/home/home_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
