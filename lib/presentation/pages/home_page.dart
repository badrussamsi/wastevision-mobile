import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();

  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WasteVision'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 24),
              _buildImagePreview(theme),
              const SizedBox(height: 16),
              _buildPickButtons(context),
              const Spacer(),
              _buildClassifyButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Classify your waste with AI',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Take a photo or choose from gallery, then let WasteVision detect the waste type.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.dividerColor,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            child: _selectedFile == null
                ? _buildEmptyPreview(theme)
                : Image.file(
                    _selectedFile!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyPreview(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 8),
          Text(
            'No image selected',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Gallery'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Camera'),
          ),
        ),
      ],
    );
  }

  Widget _buildClassifyButton(BuildContext context) {
    final hasImage = _selectedFile != null;

    return FilledButton.icon(
      onPressed: hasImage
          ? () {
              _showSnack(
                context,
                'This will send the image to the AI backend (coming soon).',
              );
            }
          : () {
              _showSnack(
                context,
                'Pick or capture an image first.',
              );
            },
      icon: const Icon(Icons.auto_awesome),
      label: const Text('Classify (dummy)'),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked == null) return;

      setState(() {
        _selectedFile = File(picked.path);
      });
    } catch (e) {
      _showSnack(context, 'Failed to pick image: $e');
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
