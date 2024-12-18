import 'package:flutter/material.dart';
import 'package:wave_container/wave_container.dart';

class ShimmerExample extends StatelessWidget {
  const ShimmerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveContainer(
      height: 200,
      waterPercentage: 0.6,
      waveColorType: WaveColorType.shimmer,
      shimmerBaseColor: Colors.blue,
      shimmerHighlightColor: Colors.lightBlueAccent,
      shimmerSpeed: 1.5,
    );
  }
}
