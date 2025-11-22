import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../core/config/api_config.dart';
import '../../core/models/prediction_result.dart';

class PredictionApi {
  static final PredictionApi instance = PredictionApi._internal();

  PredictionApi._internal();

  /// Call real backend /predict endpoint
  Future<PredictionResult> classifyImage(File imageFile) async {
    final uri = Uri.parse(ApiConfig.predictEndpoint);

    // Deteksi MIME type file (image/jpeg, image/png, dll)
    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final mimeSplit = mimeType.split('/');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file', // HARUS sama dengan parameter di FastAPI
          imageFile.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );

    http.StreamedResponse streamed;
    try {
      streamed = await request.send();
    } on SocketException catch (e) {
      throw Exception('Cannot reach server: $e');
    }

    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to classify image. '
            'Status: ${response.statusCode}, body: ${response.body}',
      );
    }

    final Map<String, dynamic> data =
    jsonDecode(response.body) as Map<String, dynamic>;

    return PredictionResult(
      label: data['label'] as String,
      confidence: (data['confidence'] as num).toDouble(),
    );
  }
}