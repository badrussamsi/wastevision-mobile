import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../config/api_config.dart';

class PredictionResult {
  final String label;
  final double confidence;

  PredictionResult({
    required this.label,
    required this.confidence,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}

class WasteVisionApiClient {
  final http.Client _client;

  WasteVisionApiClient({http.Client? client})
      : _client = client ?? http.Client();

  Future<PredictionResult> classifyImage(File imageFile) async {
    final uri = Uri.parse(ApiConfig.predictEndpoint);

    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final mimeSplit = mimeType.split('/');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',                 // param FastAPI
          imageFile.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );

    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw HttpException(
        'Failed to classify. Status: ${response.statusCode}, body: ${response.body}',
      );
    }

    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    return PredictionResult.fromJson(json);
  }

  void dispose() {
    _client.close();
  }
}