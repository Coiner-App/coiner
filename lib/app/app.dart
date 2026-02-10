import 'package:flutter/material.dart';

import 'package:coiner/app/ctheme.dart';
import 'router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: "Coiner",
      theme: CTheme.cLightTheme,
      darkTheme: CTheme.cDarkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
