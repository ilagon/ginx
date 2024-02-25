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
                        // Implement your edit logic here
                        // Call widget.onUrlEdited with the index and the new URL
                      },
                    ),
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
