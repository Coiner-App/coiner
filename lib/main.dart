import 'package:coiner/view/main_view.dart';
import 'package:flutter/material.dart';

import 'package:coiner/view/nav_pages/home_view.dart';
import 'package:coiner/view/nav_pages/explore_view.dart';
import 'package:coiner/view/nav_pages/account_view.dart';
import 'package:coiner/theme/ctheme.dart';

import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// Potentially a bad idea to keep router in main but i have no where to put it rn
final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute(
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/', builder: (context, state) => HomeView()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/explore', builder: (context, state) => ExploreView()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/account', builder: (context, state) => AccountView()),
        ])
      ],
      builder: (context, state, navigationShell) => navigationShell,
      navigatorContainerBuilder: (context, state, child) => MainView(navigationShell: state, children: child)
    )
  ],
  initialLocation: '/'
);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: "Coiner",
      theme: CTheme.cLightTheme,
      darkTheme: CTheme.cDarkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
