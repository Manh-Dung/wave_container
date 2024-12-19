/// Defines the direction of gradient colors in wave
enum GradientType {
  /// Gradient flows from top to bottom
  vertical,

  /// Gradient flows from left to right
  horizontal,

  /// Gradient flows diagonally from top-left to bottom-right
  diagonal,
}

/// Defines how the wave colors are rendered
enum WaveColorType {
  /// Single solid color for the entire wave
  solid,

  /// Smooth transition between multiple colors
  gradient,

  /// Animated shimmering effect over the wave
  shimmer,
}

/// Defines the mathematical pattern used to draw the wave
enum WaveShape {
  /// Standard sine wave: smooth, continuous oscillation (default)
  sine,

  /// Alternates between two fixed values creating a rectangular pattern
  square,

  /// Linear transitions creating triangle peaks
  triangle,

  /// Continuous rise followed by sharp drop
  sawtooth,

  /// Step-like transitions between multiple levels
  ladder,

  /// Randomly generated heights creating chaos pattern
  random,

  /// User-defined wave pattern using custom function
  custom,
}
