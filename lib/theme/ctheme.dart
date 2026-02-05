import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class CTheme {
    // Base colors
    static const Color primary = Color(0xFF72BBFF);
    static const Color onPrimary = Color(0xFF1B1B1C);
    static const Color secondary = primary; // we don't have a secondary color, use primary
    static const Color onSecondary = onPrimary; 
    static const Color positive = Color(0xFF52D29D);
    static const Color negative = Color(0xFFDE1212);
    // Dark mode
    static const Color opacityBG = Color(0x0AFFFFFF);
    static const Color surface = Color(0xFF161617);
    static const Color onSurface = Colors.white;
    static const Color surfaceContainer = Color(0xFF242424);
    // Light mode
    static const Color lopacityBG = Color(0x0AFFFFFF);
    static const Color lsurface = Color(0xFF161617);
    static const Color lonSurface = Colors.white;
    static const Color lsurfaceContainer = Color(0xFF242424);

    static ColorScheme cDarkScheme = ColorScheme(brightness: Brightness.dark, primary: primary, onPrimary: onPrimary, primaryContainer: surfaceContainer, secondary: secondary, onSecondary: onPrimary, error: negative, onError: onSurface, surface: surface, onSurface: onSurface, surfaceContainer: surfaceContainer);
    static ColorScheme cLightScheme = ColorScheme.light().copyWith(primary: primary, onPrimary: onPrimary); // TODO: FIX
    static TextTheme cTextTheme(Brightness brightness) {
        final theme = brightness == Brightness.dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
        return GoogleFonts.plusJakartaSansTextTheme(theme);
    }
    static ThemeData get cLightTheme => ThemeData.from(colorScheme: cLightScheme, textTheme: cTextTheme(Brightness.light));
    static ThemeData get cDarkTheme => ThemeData.from(colorScheme: cDarkScheme, textTheme: cTextTheme(Brightness.dark));
}