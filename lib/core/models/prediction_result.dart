class PredictionResult {
  final String label;
  final double confidence;

  const PredictionResult({
    required this.label,
    required this.confidence,
  });

  /// Convenience getter to represent confidence as 0–100%.
  String get confidencePercentage => '${(confidence * 100).toStringAsFixed(1)}%';

  /// Create from JSON (for when backend is ready).
  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  /// Convert to JSON (useful for logging / debug).
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'confidence': confidence,
    };
  }
}