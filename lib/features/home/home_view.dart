import 'package:coiner/core/widgets/fluid_app_bar.dart';
import 'package:coiner/app/ctheme.dart';

import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        body: FluidAppBar(
          title: Text.rich(TextSpan(
              style: TextTheme.of(context).headlineLarge!.copyWith(fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Coiner', style: TextStyle(color: CTheme.primary)),
                TextSpan(text: 'Dash'),
              ],
            ),
          ),
          body: Center(child: TextButton(onPressed: null, child: Text("hhelo")),),
        ),
      );
  }
}