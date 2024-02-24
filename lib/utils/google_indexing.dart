import 'dart:convert';

import 'package:ginx/utils/service_account_handler.dart';
import 'package:googleapis_auth/auth_io.dart';

class GoogleIndexing {
  Future<AuthClient> _obtainAuthenticatedClient(String customName) async {

    final accountCredentials = await ServiceAccountHandler()
        .getGoogleServiceAccountCredentials(customName);

    var scopes = ['https://www.googleapis.com/auth/indexing'];

    AuthClient client =
        await clientViaServiceAccount(accountCredentials, scopes);

    return client; // Remember to close the client when you are finished with it.
  }

  void performIndexing(String customName, List<String> urlList) async {
    var client = await _obtainAuthenticatedClient(customName);

    var url = Uri.parse('https://indexing.googleapis.com/v3/urlNotifications:publish');

    var response = await client.post(
      url,
      body: jsonEncode({
        'url': 'https://example.com/',
        'type': 'URL_UPDATED',
      }),
    );

    if (response.statusCode == 200) {
      print('Successfully indexed URL');
    } else {
      print('Failed to index URL: ${response.body}');
    }

    client.close();
  }
}
