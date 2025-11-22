import 'dart:io';

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    super.key,
    required this.imageFile,
    required this.label,
    required this.confidence,
  });

  final File imageFile;
  final String label;
  final double confidence;

  String get confidenceText => '${(confidence * 100).toStringAsFixed(1)}%';

  Color _chipColor(BuildContext context) {
    final theme = Theme.of(context);
    if (confidence >= 0.9) {
      return theme.colorScheme.primaryContainer;
    } else if (confidence >= 0.7) {
      return theme.colorScheme.tertiaryContainer;
    } else {
      return theme.colorScheme.errorContainer;
    }
  }

  String get confidenceLevel {
    if (confidence >= 0.9) return 'High confidence';
    if (confidence >= 0.7) return 'Medium confidence';
    return 'Low confidence';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classification Result'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(theme),
              const SizedBox(height: 16),
              _buildResultSummary(context),
              const SizedBox(height: 24),
              _buildInfoCard(theme),
              const Spacer(),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
          ),
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildResultSummary(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                confidenceLevel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Chip(
          label: Text(
            confidenceText,
            style: theme.textTheme.labelLarge,
          ),
          backgroundColor: _chipColor(context),
        ),
      ],
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: theme.textTheme.bodyMedium!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What this means',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'WasteVision predicts this image as "$label" with a confidence of $confidenceText.',
              ),
              const SizedBox(height: 8),
              Text(
                'In a real model, this could help route the item to the correct recycling or disposal bin.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop(); // back to HomePage
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Try another image'),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: const Icon(Icons.home_outlined),
          label: const Text('Back to home'),
        ),
      ],
    );
  }
}