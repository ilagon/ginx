import 'dart:convert';
import 'package:ginx/utils/service_account_handler.dart';
import 'package:googleapis_auth/auth_io.dart';

class GoogleIndexing {
  Future<AuthClient> obtainAuthenticatedClient(String customName) async {
    final accountCredentials = await ServiceAccountHandler()
        .getGoogleServiceAccountCredentials(customName);

    var scopes = ['https://www.googleapis.com/auth/indexing'];

    AuthClient client =
        await clientViaServiceAccount(accountCredentials, scopes);

    return client; // Remember to close the client when you are finished with it.
  }
}
