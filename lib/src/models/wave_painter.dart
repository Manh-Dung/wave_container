import 'package:flutter/material.dart';
import 'package:wave_container/wave_container.dart';
import 'dart:math' as math;

class WavePainter extends CustomPainter {
  /// Creates a wave effect painter with specified properties
  WavePainter({
    required this.animation,
    required this.waterLevel,
    required this.amplitude,
    required this.waveHeight,
    required this.waveFrequency,
    required this.waveSpeed,
    required this.solidColor,
    required this.gradientColors,
    required this.gradientStops,
    required this.gradientType,
    required this.waveColorType,
    required this.shimmerAnimation,
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
    required this.shimmerSpeed,
    required this.waveShape,
    this.customWaveFunction,
  });

  final Animation<double> animation;
  final Animation<double> shimmerAnimation;
  final double waterLevel;
  final double amplitude;
  final double waveHeight;
  final double waveFrequency;
  final double waveSpeed;
  final Color solidColor;
  final List<Color> gradientColors;
  final List<double> gradientStops;
  final GradientType gradientType;
  final WaveColorType waveColorType;
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;
  final double shimmerSpeed;
  final WaveShape waveShape;
  final double Function(double)? customWaveFunction;

  /// Main paint configuration based on selected color type
  /// Returns configured Paint object with:
  /// - Color or gradient shader
  /// - Fill style
  Paint _createPaint(Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    switch (waveColorType) {
      case WaveColorType.solid:
        paint.color = solidColor;
        break;
      case WaveColorType.gradient:
        paint.shader = _createGradient(size);
        break;
      case WaveColorType.shimmer:
        paint.shader = _createShimmerGradient(size);
        break;
    }

    return paint;
  }

  /// Generate points for square wave pattern
  /// Returns values alternating between +1 and -1
  /// Creates rectangular oscillation effect
  double _getSquareWave(double x) {
    return math.sin(x) >= 0 ? 1.0 : -1.0;
  }

  /// Generate points for triangle wave pattern
  /// Returns linear transitions between peaks
  /// Creates angular wave effect
  double _getTriangleWave(double x) {
    const period = 2.0 * math.pi;
    x = x % period;
    if (x < period / 2) {
      return 2.0 * x / period;
    } else {
      return 2.0 * (1.0 - x / period);
    }
  }

  /// Generate points for sawtooth wave pattern
  /// Returns continuous rise followed by sharp drop
  /// Creates jagged wave effect
  double _getSawtoothWave(double x) {
    const period = 2.0 * math.pi;
    return (x % period) / period * 2.0 - 1.0;
  }

  /// Generate points for sine wave pattern
  /// Returns smooth oscillation between -1 and 1
  /// Creates standard wave effect
  double _getSineWave(double x) {
    return math.sin(x);
  }

  /// Generate points for stepped wave pattern
  /// Returns fixed values at different intervals
  /// Creates ladder-like wave effect
  double _getSteppedWave(double x) {
    const period = 2.0 * math.pi;
    x = x % period;
    if (x < period / 3) {
      return 1.0;
    }
    if (x < 2 * period / 3) {
      return 0.0;
    }
    return -1.0;
  }

  /// Generate points for random wave pattern
  /// Returns random values between -1 and 1
  /// Creates chaotic wave effect
  double _getRandomWave(double x) {
    final random = math.Random(x.toInt());
    return random.nextDouble() * 2 - 1;
  }

  /// Calculate current vertical position for any point on wave
  /// Parameters:
  /// - x: Horizontal position
  /// - width: Total width of container
  /// Returns: Normalized Y position (-1 to 1)
  double _getWaveY(double x, double width) {
    final normalizedX = (x / width * waveFrequency * math.pi) +
        (animation.value * 2 * math.pi * waveSpeed);

    switch (waveShape) {
      case WaveShape.sine:
        return _getSineWave(normalizedX);
      case WaveShape.square:
        return _getSquareWave(normalizedX);
      case WaveShape.triangle:
        return _getTriangleWave(normalizedX);
      case WaveShape.sawtooth:
        return _getSawtoothWave(normalizedX);
      case WaveShape.ladder:
        return _getSteppedWave(normalizedX);
      case WaveShape.random:
        return _getRandomWave(normalizedX);
      case WaveShape.custom:
        if (customWaveFunction != null) {
          return customWaveFunction!(normalizedX);
        }
        return _getSineWave(normalizedX);
    }
  }

  /// Create animated shimmer gradient effect
  /// - Translates gradient based on animation value
  /// - Creates moving highlight effect
  Shader _createShimmerGradient(Size size) {
    return LinearGradient(
      begin: Alignment(-1.0 + (shimmerAnimation.value * 3 * shimmerSpeed), 0.0),
      end: Alignment(0.0 + (shimmerAnimation.value * 3 * shimmerSpeed), 0.0),
      colors: [
        shimmerBaseColor,
        shimmerHighlightColor,
        shimmerBaseColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  /// Create static gradient based on selected type
  /// Supports:
  /// - Vertical gradient
  /// - Horizontal gradient
  /// - Diagonal gradient
  Shader _createGradient(Size size) {
    switch (gradientType) {
      case GradientType.vertical:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
          stops: gradientStops,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      case GradientType.horizontal:
        return LinearGradient(
          colors: gradientColors,
          stops: gradientStops,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      case GradientType.diagonal:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: gradientStops,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Configure paint style
    final paint = _createPaint(size);

    // 2. Calculate base water level
    final baseHeight = size.height * (1 - waterLevel);
    final wave = size.height * waveHeight;

    // 3. Create wave path
    final path = Path();
    path.moveTo(0, baseHeight);

    // 4. Add wave points
    for (var i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        baseHeight + _getWaveY(i, size.width) * wave * amplitude,
      );
    }

    // 5. Complete path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // 6. Draw final wave
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}
