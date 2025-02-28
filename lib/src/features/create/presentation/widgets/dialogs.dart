import 'package:anitier2/src/features/shared/models/tier_list.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';

Future<TierList?> showTierListCreationDialog(BuildContext context) async {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  const typeOptions = ["Anime", "Manga", "Character"];
  int typeIndex = 0;

  return await showDialog<TierList?>(
    context: context,
    builder: (BuildContext context) => Builder(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              FilledButton(
                onPressed: () {
                  final newTierList = TierList(
                    type: typeOptions[typeIndex].toLowerCase(),
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                  Navigator.of(context).pop(newTierList);
                },
                child: Text("Save"),
              )
            ],
            title: Text("New Tier List Setup"),
            content: Container(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    maxLines: 2,
                    maxLength: 256,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Title',
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description(optional)',
                      hintText: 'Description(optional)',
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Choose list type"),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Wrap(
                        spacing: 5.0,
                        children: List<Widget>.generate(typeOptions.length,
                            (int index) {
                          return ChoiceChip(
                            label: Text('${typeOptions[index]}'),
                            selected: typeIndex == index,
                            onSelected: (bool selected) {
                              setState(() {
                                typeIndex = (selected ? index : null)!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
