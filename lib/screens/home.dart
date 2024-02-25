import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ginx/constants/palette.dart';
import 'package:ginx/services/google_indexing.dart';
import 'package:ginx/widgets/setting_selector.dart';
import 'package:ginx/widgets/url_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final urlController = TextEditingController();
  final urls = <String>[];
  String? customName;
  final focusNode = FocusNode();

  double progress = 0.0;
  bool isError = false;
  String errorMessage = '';
  GoogleIndexing googleIndexing = new GoogleIndexing();

  void performIndexing(String customName, List<String> urlList) async {
    var client = await googleIndexing.obtainAuthenticatedClient(customName);

    var indexingUrl = Uri.parse(
        'https://indexing.googleapis.com/v3/urlNotifications:publish');

    for (var url in urlList) {
      var response = await client.post(
        indexingUrl,
        body: jsonEncode({
          'url': url,
          'type': 'URL_UPDATED',
        }),
      );

      if (response.statusCode == 200) {
        print("Successfully indexed $url");
        setState(() {
          progress += 1.0 / urls.length;
        });
      } else {
        throw Exception('Failed to index $url: ${response.statusCode}');
      }
    }

    client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            ServiceAccountDropdown(
              onChanged: (value) {
                setState(() {
                  customName = value;
                });
              },
            ),
            Expanded(
              child: UrlList(
                urls: urls,
                onUrlDeleted: (index) {
                  setState(() {
                    urls.removeAt(index);
                  });
                },
              ),
            ),
            TextField(
              style: const TextStyle(color: textColor),
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
              ),
              cursorColor: tertiaryColor,
              controller: urlController,
              focusNode: focusNode,
              onSubmitted: (url) {
                var urlList = url.replaceAll(" ", "").split(',');
                for (var url in urlList) {
                  setState(() {
                    urls.add(url);
                  });
                }
                urlController.clear();
                FocusScope.of(context).requestFocus(focusNode);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(tertiaryColor),
                ),
                onPressed:
                    customName == null || customName == "" || urls.isEmpty
                        ? null
                        : () async {
                            try {
                              performIndexing(customName!, urls);
                            } catch (e) {
                              setState(() {
                                isError = true;
                                errorMessage = e.toString();
                              });
                            }
                          },
                child:
                    const Text('Generate', style: TextStyle(color: textColor)),
              ),
            ),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: isError ? Colors.red : null,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress < 1.0 ? textColor : tertiaryColor,
              ),
            ),
            if (isError)
              AlertDialog(
                backgroundColor: secondaryColor,
                title: const Text('Indexing Failed',
                    style: TextStyle(color: textColor)),
                content: Text(errorMessage),
                actions: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(tertiaryColor),
                    ),
                    child: const Text('OK', style: TextStyle(color: textColor)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
