import 'package:coiner/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter/widgets.dart';

import 'package:coiner/app/main_nav_shell.dart';
import 'package:coiner/features/home/home_view.dart';
import 'package:coiner/features/explore/explore_view.dart';
import 'package:coiner/features/account/presentation/account_view.dart';
import 'package:coiner/features/authentication/presentation/screens/login_input.dart';
import 'package:coiner/features/splash/presentation/splash_view.dart';

import 'package:coiner/features/authentication/presentation/state_providers/auth_state_notifier.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStateNotifier = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authStateNotifier,
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashView()),
      GoRoute(path: '/login', builder: (context, state) => LoginInput()),
      StatefulShellRoute(
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => ExploreView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => AccountView(),
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, state, child) =>
            MainNavShell(navigationShell: state, children: child),
      ),
    ],
    initialLocation: '/',
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final goingToLogin = state.matchedLocation == '/login';
      final goingToSplash = state.matchedLocation == '/';
      return authState.when(
        data: (state) {
          switch (state) {
            case AuthenticationStatus.unauthenticated:
            case AuthenticationStatus.error:
              return goingToLogin ? null : '/login';

            case AuthenticationStatus.authenticated:
            case AuthenticationStatus.cached:
            case AuthenticationStatus.offline:
              if (goingToLogin || goingToSplash) {
                return '/dashboard'; 
              }
              return null;
          }
        },
        error: (err, stack) {
          return null; // TODO: Implement error screen
        },
        loading: () => null
      );
    },
  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref ref;

  RouterNotifier(this.ref) {
    // whem aithStateProvider changes, we tell the router to refresh
    ref.listen(authStateProvider, (_, _) => notifyListeners());
  }
}
