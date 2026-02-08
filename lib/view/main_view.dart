import 'package:coiner/view/widgets/animated_index_stack.dart';
import 'package:coiner/view/widgets/blurred_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainView extends StatelessWidget {
  const MainView({super.key, required this.children, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BlurredNavigationBar(
        destinations: <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: 'Account'),
        ],
        onDestinationSelected: (index) => navigationShell.goBranch(index, initialLocation: (index == navigationShell.currentIndex)),
        selectedIndex: navigationShell.currentIndex,
      ),
      body: AnimatedIndexedStack(index: navigationShell.currentIndex, children: children),
    );
  }
}
