import 'package:flutter/material.dart';
import 'package:ginx/widgets/setting_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final urlController = TextEditingController();
  final urls = <String>[];
  String? customName;

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
                TextField(
                  controller: urlController,
                  onSubmitted: (url) {
                    var urlList = url.replaceAll(" ", "").split(',');
                    for (var url in urlList) {
                      setState(() {
                        urls.add(url);
                      });
                    }
                  },
                ),
              ],
            )));
  }
}
