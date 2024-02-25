import 'package:flutter/material.dart';
import 'package:ginx/constants/palette.dart';
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
              ],
            )));
  }
}
