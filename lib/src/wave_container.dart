library wave_container;

import 'package:flutter/material.dart';
import 'package:wave_container/wave_container.dart';

class WaveContainer extends StatefulWidget {
  /// Creates a wave container with customizable properties.
  ///
  /// Required parameters:
  /// - [height]: Total height of the container
  /// - [waterPercentage]: Fill level between 0.0 and 1.0
  ///
  /// Optional parameters allow customization of:
  /// - Wave appearance (colors, shapes, effects)
  /// - Animation behavior (speed, amplitude)
  /// - Container styling (borders, radius)
  const WaveContainer({
    super.key,
    required this.height,
    required this.waterPercentage,
    this.backgroundColor = WaveConstants.defaultBackgroundColor,
    this.solidColor = WaveConstants.defaultSolidColor,
    this.isShowPercentage = true,
    this.jarBorderRadius,
    this.insideJarBorderRadius,
    this.border,
    this.waveHeight = WaveConstants.defaultWaveHeight,
    this.waveFrequency = WaveConstants.defaultWaveFrequency,
    this.waveSpeed = WaveConstants.defaultWaveSpeed,
    this.initialAmplitude = WaveConstants.defaultInitialAmplitude,
    this.finalAmplitude = WaveConstants.defaultFinalAmplitude,
    this.waveColorType = WaveColorType.solid,
    this.gradientColors = WaveConstants.defaultGradientColors,
    this.gradientStops = WaveConstants.defaultGradientStops,
    this.gradientType = GradientType.vertical,
    this.shimmerBaseColor = WaveConstants.defaultShimmerBaseColor,
    this.shimmerHighlightColor = WaveConstants.defaultShimmerHighlightColor,
    this.shimmerSpeed = WaveConstants.defaultShimmerSpeed,
    this.waveShape = WaveShape.sine,
    this.customWaveFunction,
  })  : assert(
          waterPercentage >= 0 && waterPercentage <= 1,
          'waterPercentage must be between 0.0 and 1.0',
        ),
        assert(
          waveHeight >= 0 && waveHeight <= 1,
          'waveHeight must be between 0.0 and 1.0',
        ),
        assert(
          gradientColors.length == gradientStops.length,
          'gradientColors length must be equal gradientStops length',
        );

  /// Total height of the wave container
  final double height;

  /// Water level percentage (0.0 to 1.0)
  /// - 0.0 represents empty
  /// - 1.0 represents full
  final double waterPercentage;

  /// Main color for solid wave rendering
  final Color solidColor;

  /// Container's background color
  final Color backgroundColor;

  /// Whether to display percentage text overlay
  final bool isShowPercentage;

  /// Outer container border radius
  final BorderRadius? jarBorderRadius;

  /// Inner wave border radius
  final BorderRadius? insideJarBorderRadius;

  /// Container border styling
  final BoxBorder? border;

  /// Wave animation speed multiplier
  /// - Higher values = faster wave motion
  final double waveSpeed;

  /// Starting amplitude of waves when animated
  /// - Controls initial wave intensity
  final double initialAmplitude;

  /// Final amplitude of waves after animation
  /// - Controls settled wave state
  final double finalAmplitude;

  /// Height of wave peaks relative to container
  /// - Range: 0.0 to 1.0
  /// - Higher values create taller waves
  final double waveHeight;

  /// Number of complete wave cycles
  /// - Higher values create more frequent peaks
  /// - Affects wave density
  final double waveFrequency;

  /// Type of coloring effect applied to the wave
  /// - [solid]: Single color wave
  /// - [gradient]: Multi-color gradient wave
  /// - [shimmer]: Animated shimmer effect
  final WaveColorType waveColorType;

  /// List of colors used to create gradient effect
  /// - Must have same length as [gradientStops]
  /// - Minimum 2 colors required for gradient
  /// - Colors will blend smoothly between each other
  /// Example: [Colors.blue, Colors.lightBlue, Colors.cyan]
  final List<Color> gradientColors;

  /// List of position values (0.0 to 1.0) for gradient colors
  /// - Must have same length as [gradientColors]
  /// - Values determine where each color is positioned in gradient
  /// - Values must be in ascending order
  /// Example: [0.0, 0.5, 1.0]
  final List<double> gradientStops;

  /// Direction of gradient color transition
  /// - [vertical]: Top to bottom
  /// - [horizontal]: Left to right
  /// - [diagonal]: Top-left to bottom-right
  /// Only applies when [waveColorType] is [gradient]
  final GradientType gradientType;

  /// Base/background color for shimmer effect
  /// - Should be darker/less prominent color
  /// - Forms background layer of shimmer
  /// Only applies when [waveColorType] is [shimmer]
  final Color shimmerBaseColor;

  /// Highlight color for shimmer effect
  /// - Should be lighter/more prominent color
  /// - Creates moving highlight over base color
  /// - Typically lighter shade of [shimmerBaseColor]
  /// Only applies when [waveColorType] is [shimmer]
  final Color shimmerHighlightColor;

  /// Speed multiplier for shimmer animation
  /// - Higher values = faster shimmer movement
  /// - Recommended range: 0.5 to 2.0
  /// - Default: 1.0
  /// Only applies when [waveColorType] is [shimmer]
  final double shimmerSpeed;

  /// Mathematical pattern used to generate wave
  /// Available patterns:
  /// - [sine]: Smooth sine wave (default)
  /// - [square]: Rectangular wave
  /// - [triangle]: Angular wave
  /// - [sawtooth]: Sharp rise and fall
  /// - [ladder]: Step pattern
  /// - [random]: Random heights
  /// - [custom]: User-defined pattern
  final WaveShape waveShape;

  /// Custom function to generate wave pattern
  /// - Input: x position (0 to 2π)
  /// - Output: y position (-1 to 1)
  /// - Only used when [waveShape] is [custom]
  /// - Must return values between -1 and 1
  /// Example:
  /// ```dart
  /// customWaveFunction: (x) => sin(x) * cos(x)
  /// ```
  final double Function(double)? customWaveFunction;

  @override
  State<WaveContainer> createState() => _WaveContainerState();
}

class _WaveContainerState extends State<WaveContainer>
    with TickerProviderStateMixin {
  /// Primary wave animation controller
  /// - Manages continuous wave motion
  /// - Loops indefinitely
  /// - Controls horizontal wave translation
  late AnimationController _waveController;

  /// Water level animation controller
  /// - Manages vertical water level changes
  /// - Activates on:
  ///   1. Initial widget build
  ///   2. waterPercentage property updates
  /// - Uses easeInOut curve for smooth transitions
  late AnimationController _heightController;

  /// Wave amplitude animation controller
  /// - Manages wave intensity
  /// - Activates on:
  ///   1. Initial widget build
  ///   2. Container tap events
  ///   3. waterPercentage changes
  /// - Creates "splash" effect
  late AnimationController _amplitudeController;

  /// Water level animation value
  /// - Maps controller progress to actual water level
  /// - Smoothly interpolates between levels
  late Animation<double> _heightAnimation;

  /// Wave amplitude animation value
  /// - Controls current wave intensity
  /// - Transitions from initialAmplitude to finalAmplitude
  late Animation<double> _amplitudeAnimation;

  /// Shimmer effect animation controller
  /// - Manages shimmer overlay motion
  /// - Creates moving highlight effect
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _startInitialAnimations();
  }

  void startWaveAnimation() {
    _amplitudeController.forward();
  }

  /// Initialize all animation controllers with proper durations
  void _initializeControllers() {
    _waveController = AnimationController(
      duration: WaveConstants.waveDuration,
      vsync: this,
    )..repeat();

    _heightController = AnimationController(
      duration: WaveConstants.heightDuration,
      vsync: this,
    );

    _amplitudeController = AnimationController(
      duration: WaveConstants.amplitudeDuration,
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: WaveConstants.shimmerDuration,
      vsync: this,
    )..repeat();
  }

  /// Setup animation curves and mappings
  void _setupAnimations() {
    _heightAnimation = Tween<double>(
      begin: 0.0,
      end: widget.waterPercentage,
    ).animate(
      CurvedAnimation(
        parent: _heightController,
        curve: Curves.easeInOut,
      ),
    );

    _amplitudeAnimation = Tween<double>(
      begin: widget.initialAmplitude,
      end: widget.finalAmplitude,
    ).animate(
      CurvedAnimation(
        parent: _amplitudeController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  /// Start initial entrance animations
  void _startInitialAnimations() {
    _heightController.forward();
    startWaveAnimation();
  }

  @override
  void didUpdateWidget(WaveContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.waterPercentage != widget.waterPercentage) {
      _heightAnimation = Tween<double>(
        begin: _heightAnimation.value,
        end: widget.waterPercentage,
      ).animate(
        CurvedAnimation(
          parent: _heightController,
          curve: Curves.easeInOut,
        ),
      );
      _heightController.forward(from: 0);

      // Reset wave amplitude when water level changes
      _amplitudeController.reset();
      _onTapWave();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _heightController.dispose();
    _amplitudeController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapWave() {
    // Reset and start amplitude animation
    _amplitudeController.reset();
    _amplitudeAnimation = Tween<double>(
      begin: widget.initialAmplitude, // Highest amplitude at start
      end: widget.finalAmplitude, // Lowest amplitude at end
    ).animate(
      CurvedAnimation(
        parent: _amplitudeController,
        curve: Curves.easeOutCubic,
      ),
    );
    _amplitudeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _onTapWave();
          },
          child: Container(
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: widget.jarBorderRadius ??
                  BorderRadius.circular(WaveConstants.defaultBorderRadius),
              border: widget.border ??
                  Border.all(
                    color: WaveConstants.defaultBorderColor,
                    width: WaveConstants.defaultBorderWidth,
                  ),
            ),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _waveController,
                _heightAnimation,
                _amplitudeAnimation,
                _shimmerController,
              ]),
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: widget.insideJarBorderRadius ??
                      BorderRadius.circular(
                          WaveConstants.defaultInsideBorderRadius),
                  child: CustomPaint(
                    painter: WavePainter(
                      animation: _waveController,
                      solidColor: widget.solidColor,
                      waterLevel: _heightAnimation.value,
                      amplitude: _amplitudeAnimation.value,
                      waveHeight: widget.waveHeight,
                      waveFrequency: widget.waveFrequency,
                      waveSpeed: widget.waveSpeed,
                      gradientColors: widget.gradientColors,
                      gradientStops: widget.gradientStops,
                      waveColorType: widget.waveColorType,
                      gradientType: widget.gradientType,
                      shimmerAnimation: _shimmerController,
                      shimmerBaseColor: widget.shimmerBaseColor,
                      shimmerHighlightColor: widget.shimmerHighlightColor,
                      shimmerSpeed: widget.shimmerSpeed,
                      waveShape: widget.waveShape,
                      customWaveFunction: widget.customWaveFunction,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.isShowPercentage)
          Text(
            widget.waterPercentage < 0
                ? "Exceeded"
                : '${(widget.waterPercentage * 100).toInt()}%',
            style: const TextStyle(
              color: Colors.black,
              fontSize: WaveConstants.defaultFontSize,
              fontWeight: WaveConstants.defaultFontWeight,
            ),
          ),
      ],
    );
  }
}
