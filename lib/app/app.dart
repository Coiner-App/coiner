import 'package:flutter/material.dart';

import 'package:coiner/app/ctheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appRouter = ref.watch(appRouterProvider);
        return MaterialApp.router(
          routerConfig: appRouter,
          title: "Coiner",
          theme: CTheme.cLightTheme,
          darkTheme: CTheme.cDarkTheme,
          themeMode: ThemeMode.dark);
        });
  }
}
