import 'package:flutter/material.dart';
import 'package:ginx/constants/palette.dart';

class UrlList extends StatefulWidget {
  final List<String> urls;
  final ValueChanged<int> onUrlDeleted;
  // final ValueChanged<int, String> onUrlEdited;

  const UrlList(
      {super.key,
      required this.urls,
      required this.onUrlDeleted /*, required this.onUrlEdited*/});

  @override
  _UrlListState createState() => _UrlListState();
}

class _UrlListState extends State<UrlList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: tertiaryColor,
      ),
      child: ListView.builder(
        itemCount: widget.urls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onSecondaryTapDown: (details) {
              showMenu(
                color: secondaryColor,
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                ),
                items: [
                  PopupMenuItem(
                    child: TextButton(
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: textColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close the menu
                        showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController controller =
                                TextEditingController(text: widget.urls[index]);
                            return AlertDialog(
                              backgroundColor: secondaryColor,
                              title: const Text(
                                'Edit URL',
                                style: TextStyle(color: textColor),
                              ),
                              content: TextField(
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: textColor),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: textColor),
                                  ),
                                ),
                                cursorColor: tertiaryColor,
                                style: const TextStyle(color: textColor),
                                controller: controller,
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: tertiaryColor),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: textColor),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: tertiaryColor),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: textColor),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.urls[index] =
                                          controller.text; // Update the URL
                                    });
                                    Navigator.pop(context); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    onTap: () {
                      // Navigator.pop(context); // Close the menu
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController(text: widget.urls[index]);
                          return AlertDialog(
                            backgroundColor: secondaryColor,
                            title: const Text(
                              'Edit URL',
                              style: TextStyle(color: textColor),
                            ),
                            content: TextField(
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: textColor),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: textColor),
                                ),
                              ),
                              cursorColor: tertiaryColor,
                              style: const TextStyle(color: textColor),
                              controller: controller,
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: tertiaryColor),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: textColor),
                                ),
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: tertiaryColor),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: textColor),
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.urls[index] =
                                        controller.text; // Update the URL
                                  });
                                  Navigator.pop(context); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: textColor),
                      ),
                      onPressed: () {
                        widget.onUrlDeleted(index);
                        Navigator.pop(context);
                      },
                    ),
                    onTap: () {
                      widget.onUrlDeleted(index);
                    },
                  ),
                ],
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                widget.urls[index],
                style: const TextStyle(color: textColor, fontSize: 16.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
