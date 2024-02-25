import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ginx/constants/palette.dart';
import 'package:ginx/utils/service_account_handler.dart';
import 'package:path/path.dart';

class ServiceAccountDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const ServiceAccountDropdown({super.key, required this.onChanged});

  @override
  _ServiceAccountDropdownState createState() => _ServiceAccountDropdownState();
}

class _ServiceAccountDropdownState extends State<ServiceAccountDropdown> {
  List<String> serviceAccountNames = [];
  String? selectedAccount;
  final ServiceAccountHandler manager = ServiceAccountHandler();

  @override
  void initState() {
    super.initState();
    loadServiceAccountNames();
  }

  void loadServiceAccountNames() async {
    serviceAccountNames = await manager.getAllServiceAccountNames();
    setState(() {});
  }

  void addServiceAccount(BuildContext context) async {
    String? customName;
    String? fileName;

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: secondaryColor,
              content: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        onSubmitted: (value) => customName = value,
                        decoration: const InputDecoration(
                          labelText: 'Custom name',
                          labelStyle: TextStyle(color: textColor),
                          hintStyle: TextStyle(color: textColor),
                          errorStyle: TextStyle(color: textColor),
                          counterStyle: TextStyle(color: textColor),
                          fillColor: textColor,
                          focusColor: textColor,
                        )),
                    const SizedBox(height: 20), // Add some spacing
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return tertiaryColor;
                          } else {
                            return Colors.transparent;
                          }
                        }),
                      ),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['json'],
                        );

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          var credentials = await manager
                              .readServiceAccountCredentials(file.path);
                          await manager.storeGoogleServiceAccountCredentials(
                              customName!, credentials);
                          loadServiceAccountNames();
                          fileName = basename(file.path);
                          setState(() {});
                        }
                      },
                      child: const Text(
                        'Select Service Account JSON',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    if (fileName != null) Text('Selected file: $fileName'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: tertiaryColor),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: textColor),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: selectedAccount,
          items: serviceAccountNames.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedAccount = newValue;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => addServiceAccount(context),
        ),
      ],
    );
  }
}
