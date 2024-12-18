import 'package:flutter/material.dart';
import 'package:wave_container_example/screens/examples/interactive_example.dart';

import '../widgets/example_card.dart';
import 'examples/basic_example.dart';
import 'examples/gradient_example.dart';
import 'examples/shimmer_example.dart';
import 'examples/wave_shapes_example.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wave Container Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExampleCard(
            title: 'Basic Wave',
            description: 'Simple water wave animation',
            child: BasicExample(),
          ),
          SizedBox(height: 16),
          ExampleCard(
            title: 'Gradient Wave',
            description: 'Wave with gradient colors',
            child: GradientExample(),
          ),
          SizedBox(height: 16),
          ExampleCard(
            title: 'Shimmer Wave',
            description: 'Wave with shimmer effect',
            child: ShimmerExample(),
          ),
          SizedBox(height: 16),
          ExampleCard(
            title: 'Wave Shapes',
            description: 'Different wave patterns',
            child: WaveShapesExample(),
          ),
          SizedBox(height: 16),
          ExampleCard(
            title: 'Interactive',
            description: 'Interactive example',
            child: InteractiveExample(),
          ),
        ],
      ),
    );
  }
}
