import 'package:flutter/material.dart';

import 'utils/screen_util.dart';
import 'view/widgets/fluid_app_bar.dart';
import 'theme/ctheme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Coiner",
      theme: CTheme.cLightTheme,
      darkTheme: CTheme.cDarkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
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
      ),
    );
  }
}
