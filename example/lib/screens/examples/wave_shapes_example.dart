import 'package:flutter/material.dart';
import 'package:wave_container/wave_container.dart';

class WaveShapesExample extends StatefulWidget {
  const WaveShapesExample({super.key});

  @override
  State<WaveShapesExample> createState() => _WaveShapesExampleState();
}

class _WaveShapesExampleState extends State<WaveShapesExample> {
  WaveShape currentShape = WaveShape.sine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WaveContainer(
          height: 200,
          waterPercentage: 0.7,
          waveShape: currentShape,
          waveFrequency: 6,
        ),
        const SizedBox(height: 16),
        DropdownButton<WaveShape>(
          value: currentShape,
          items: WaveShape.values.map((shape) {
            return DropdownMenuItem(
              value: shape,
              child: Text(shape.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (shape) {
            if (shape != null) {
              setState(() => currentShape = shape);
            }
          },
        ),
      ],
    );
  }
}
