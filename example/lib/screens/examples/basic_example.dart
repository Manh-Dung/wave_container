import 'package:flutter/material.dart';
import 'package:wave_container/wave_container.dart';

class BasicExample extends StatelessWidget {
  const BasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveContainer(
      height: 200,
      waterPercentage: 0.65,
      solidColor: Colors.blue,
    );
  }
}
