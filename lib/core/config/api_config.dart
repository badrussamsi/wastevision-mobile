import 'dart:io';

class ApiConfig {
  // Ubah ke URL backend kamu kalau nanti sudah di-deploy.
  // Sekarang masih lokal.

  static String get baseUrl {
    // Android emulator TIDAK bisa pakai 127.0.0.1 ke host
    // harus pakai 10.0.2.2 untuk akses localhost di mesin host.
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }

    // iOS simulator / desktop bisa pakai localhost langsung
    return 'http://127.0.0.1:8000';
  }

  static String get predictEndpoint => '$baseUrl/predict';
}