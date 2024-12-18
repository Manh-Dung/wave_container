import 'package:flutter/material.dart';
import 'package:wave_container/wave_container.dart';

class GradientExample extends StatelessWidget {
  const GradientExample({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveContainer(
      height: 200,
      waterPercentage: 0.75,
      waveColorType: WaveColorType.gradient,
      gradientColors: const [
        Colors.purple,
        Colors.deepPurple,
        Colors.blue,
      ],
      gradientType: GradientType.diagonal,
    );
  }
}
