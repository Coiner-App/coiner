import 'package:flutter/widgets.dart';

import 'package:coiner/app/main_nav_shell.dart';
import 'package:coiner/features/home/home_view.dart';
import 'package:coiner/features/explore/explore_view.dart';
import 'package:coiner/features/account/account_view.dart';

import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
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
      navigatorContainerBuilder: (context, state, child) => MainNavShell(navigationShell: state, children: child)
    )
  ],
  initialLocation: '/'
);