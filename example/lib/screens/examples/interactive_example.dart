import 'package:flutter/material.dart';
import 'package:wave_container/wave_container.dart';

class InteractiveExample extends StatefulWidget {
  const InteractiveExample({super.key});

  @override
  State<InteractiveExample> createState() => _InteractiveExampleState();
}

class _InteractiveExampleState extends State<InteractiveExample> {
  double waterLevel = 0.5;
  double waveHeight = 0.2;
  double waveSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WaveContainer(
          height: 200,
          waterPercentage: waterLevel,
          waveHeight: waveHeight,
          waveSpeed: waveSpeed,
        ),
        const SizedBox(height: 16),
        _buildSlider(
          label: 'Water Level',
          value: waterLevel,
          onChanged: (value) => setState(() => waterLevel = value),
        ),
        _buildSlider(
          label: 'Wave Height',
          value: waveHeight,
          onChanged: (value) => setState(() => waveHeight = value),
        ),
        _buildSlider(
          label: 'Wave Speed',
          value: waveSpeed,
          max: 2.0,
          onChanged: (value) => setState(() => waveSpeed = value),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    double max = 1.0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: 0.0,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
