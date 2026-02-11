
import 'dart:ui';
import 'package:flutter/material.dart';

/// Navigation Bar with divider and blur
class BlurredNavigationBar extends StatelessWidget {
  final double filterX;
  final double filterY;
  final double opacity;
  final double? height;
  final Color? backgroundColor;
  final int selectedIndex;
  final List<Widget> destinations;
  final Function(int) onDestinationSelected;

  const BlurredNavigationBar(
      {super.key,
      this.filterX = 5.0,
      this.filterY = 5.0,
      this.opacity = 0.5,
      this.height,
      this.backgroundColor,
      this.selectedIndex = 0,
      required this.destinations,
      required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const Align(
          alignment: Alignment.bottomCenter,
          child: Divider(
            height: 1,
            thickness: 2,
            indent: 0.0,
            endIndent: 0.0,
            color: Color(0x0FFFFFFF),
          ),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: filterX,
              sigmaY: filterY,
            ),
            child: Opacity(
              opacity: opacity,
              child: NavigationBar(
                height: height,
                backgroundColor: backgroundColor,
                destinations: destinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
