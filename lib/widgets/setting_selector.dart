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
  String? filePath;
  final ServiceAccountHandler manager = ServiceAccountHandler();

  @override
  void initState() {
    super.initState();
    loadServiceAccountNames();
  }

  Future<void> loadServiceAccountNames() async {
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
                      cursorColor: tertiaryColor,
                      style: const TextStyle(color: textColor),
                      onChanged: (value) => setState(() {
                        customName = value;
                      }),
                      decoration: const InputDecoration(
                        labelText: 'Service Account Name',
                        labelStyle: TextStyle(color: textColor),
                        hintStyle: TextStyle(color: textColor),
                        errorStyle: TextStyle(color: textColor),
                        counterStyle: TextStyle(color: textColor),
                        fillColor: textColor,
                        focusColor: textColor,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
                      ),
                    ),
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

                          setState(() {
                            filePath = file.path;
                            fileName = basename(file.path);
                          });
                        }
                      },
                      child: const Text(
                        'Select Service Account JSON',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    if (fileName != null)
                      Text(
                        'Selected file: $fileName',
                        style: const TextStyle(color: textColor),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: tertiaryColor),
                  onPressed: customName != null && filePath != null
                      ? () async {
                          try {
                            await manager.storeGoogleServiceAccountCredentials(
                                customName!, filePath!);
                            loadServiceAccountNames();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      : null,
                  child: const Text(
                    'OK',
                    style: TextStyle(color: textColor),
                  ),
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
          style: const TextStyle(color: textColor),
          dropdownColor: secondaryColor,
          value: selectedAccount,
          items: serviceAccountNames.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                    color: textColor, backgroundColor: Colors.transparent),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedAccount = newValue;
            });
            if (newValue != null) widget.onChanged(newValue);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.add,
            color: textColor,
          ),
          onPressed: () => addServiceAccount(context),
        ),
        IconButton(
            onPressed: () async {
              if (selectedAccount != null) {
                await manager
                    .deleteGoogleServiceAccountCredentials(selectedAccount!);
                await loadServiceAccountNames();
                setState(() {
                  if (serviceAccountNames.isNotEmpty) {
                    selectedAccount = serviceAccountNames[0];
                    widget.onChanged(selectedAccount!);
                  } else {
                    selectedAccount = null;
                    widget.onChanged("");
                  }
                });
              }
            },
            icon: const Icon(
              Icons.delete,
              color: textColor,
            ))
      ],
    );
  }
}
