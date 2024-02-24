import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';

class ServiceAccountHandler {
  Future<void> storeGoogleServiceAccountCredentials(
      String customName, ServiceAccountCredentials credentials) async {
    final storage = new FlutterSecureStorage();

    await storage.write(key: '${customName}_email', value: credentials.email);
    await storage.write(
        key: '${customName}_privateKey', value: credentials.privateKey);
    await storage.write(
        key: '${customName}_clientId',
        value: ClientId(
                credentials.clientId.identifier, credentials.clientId.secret).toString());
    await storage.write(
        key: '${customName}_clientEmail', value: credentials.email);
  }

  Future<ServiceAccountCredentials> getGoogleServiceAccountCredentials(
      String customName) async {
    final storage = new FlutterSecureStorage();

    String? email = await storage.read(key: '${customName}_email');
    String? privateKey = await storage.read(key: '${customName}_privateKey');
    ClientId? clientId = (await storage.read(key: '${customName}_clientId')) as ClientId?;
    String? clientEmail = await storage.read(key: '${customName}_clientEmail');

    if ([email, privateKey, clientId, clientEmail]
        .contains(null)) {
      throw Exception(
          'Google Service Account credentials not found in secure storage for $customName');
    }

    return ServiceAccountCredentials(email!, clientId!, privateKey!);
  }

  Future<void> deleteGoogleServiceAccountCredentials(String customName) async {
    final storage = new FlutterSecureStorage();

    await storage.delete(key: '${customName}_email');
    await storage.delete(key: '${customName}_privateKey');
    await storage.delete(key: '${customName}_clientId');
    await storage.delete(key: '${customName}_clientEmail');
    await storage.delete(key: '${customName}_authUri');
  }

  Future<ServiceAccountCredentials> readServiceAccountCredentials(String filePath) async {
    final file = File(filePath);
    final json = jsonDecode(await file.readAsString());

    return ServiceAccountCredentials(
      json['client_email'],
      json['client_id'],
      json['private_key'],
    );
  }
}
