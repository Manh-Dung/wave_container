import 'package:flutter/material.dart';

class WaveConstants {
  WaveConstants._();

  // Animation Durations
  static const Duration waveDuration = Duration(seconds: 4);
  static const Duration heightDuration = Duration(milliseconds: 1200);
  static const Duration amplitudeDuration = Duration(seconds: 3);
  static const Duration shimmerDuration = Duration(seconds: 2);

  // Default Wave Properties
  static const double defaultWaveHeight = 0.2;
  static const double defaultWaveFrequency = 4.0;
  static const double defaultWaveSpeed = 1.0;
  static const double defaultInitialAmplitude = 0.4;
  static const double defaultFinalAmplitude = 0.0;

  // Border Properties
  static const double defaultBorderWidth = 6.0;
  static const double defaultBorderRadius = 25.0;
  static const double defaultInsideBorderRadius = 20.0;

  // Shimmer Properties
  static const double defaultShimmerSpeed = 1.0;
  static const List<double> defaultGradientStops = [0.0, 0.5, 1.0];

  // Default Colors
  static const Color defaultBackgroundColor = Colors.white;
  static const Color defaultSolidColor = Colors.blue;
  static const Color defaultBorderColor = Color(0xFFF6F6F6);
  static const Color defaultShimmerBaseColor = Colors.blue;
  static const Color defaultShimmerHighlightColor = Colors.lightBlue;

  // Default Text Properties
  static const double defaultFontSize = 10.0;
  static const FontWeight defaultFontWeight = FontWeight.w500;

  // Default Gradient Colors
  static const List<Color> defaultGradientColors = [
    Colors.blue,
    Colors.lightBlue,
    Colors.blueAccent,
  ];
}
