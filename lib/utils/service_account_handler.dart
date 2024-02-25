import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';

class ServiceAccountHandler {
  final storage = const FlutterSecureStorage();

  Future<void> storeGoogleServiceAccountCredentials(
      String customName, String filePath) async {
    String jsonContent = await File(filePath).readAsString();
    final json = jsonDecode(jsonContent);

    // Define the expected keys
    const expectedKeys = [
      'type',
      'project_id',
      'private_key_id',
      'private_key',
      'client_email',
      'client_id',
      'auth_uri',
      'token_uri',
      'auth_provider_x509_cert_url',
      'client_x509_cert_url',
      'universe_domain',
    ];

    // Check if all expected keys are present
    for (var key in expectedKeys) {
      if (!json.containsKey(key)) {
        throw FormatException('Invalid JSON structure: missing key $key');
      }
    }

    // Store the JSON content in FlutterSecureStorage
    await storage.write(key: customName, value: jsonContent);
  }

  Future<ServiceAccountCredentials> getGoogleServiceAccountCredentials(
      String customName) async {
    // Read JSON credentials
    String? jsonCredentials = await storage.read(key: customName);

    if (jsonCredentials == null) {
      throw Exception(
          'Google Service Account credentials not found in secure storage for $customName');
    }

    var jsonKey = json.decode(jsonCredentials);

    return ServiceAccountCredentials.fromJson(jsonKey);
  }

  Future<void> deleteGoogleServiceAccountCredentials(String customName) async {
    await storage.delete(key: customName);
  }

  Future<List<String>> getAllServiceAccountNames() async {
    final allKeys = await storage.readAll();

    return allKeys.keys.toList();
  }
}
