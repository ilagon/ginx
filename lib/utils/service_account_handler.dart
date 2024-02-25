import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';

class ServiceAccountHandler {
  final storage = const FlutterSecureStorage();

  Future<void> storeGoogleServiceAccountCredentials(
      String customName, String filePath) async {
    String jsonContent = await File(filePath).readAsString();

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

  // Future<ServiceAccountCredentials> readServiceAccountCredentials(
  //     String filePath) async {
  //   final file = File(filePath);
  //   final json = jsonDecode(await file.readAsString());

  //   return ServiceAccountCredentials(
  //     json['client_email'],
  //     ClientId(json['client_id']['identifier'], json['client_id']['secret']),
  //     json['private_key'],
  //   );
  // }

  Future<List<String>> getAllServiceAccountNames() async {
    final allKeys = await storage.readAll();

    return allKeys.keys.toList();
  }
}
