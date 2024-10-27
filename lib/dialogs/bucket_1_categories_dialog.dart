import 'package:flutter/material.dart';

class Bucket1CategoriesDialog extends StatefulWidget {
  const Bucket1CategoriesDialog({super.key});

  @override
  Bucket1CategoriesDialogState createState() => Bucket1CategoriesDialogState();
}

class Bucket1CategoriesDialogState extends State<Bucket1CategoriesDialog> {
  String selectedChoice = 'Use default';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Degrees of Freedom'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: SizedBox(
        width: 350,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ChoiceChip(
                      backgroundColor: Colors.grey[200],
                      label: const Text('Use default'),
                      selected: selectedChoice == 'Use default',
                      onSelected: (bool value) {
                        setState(() {
                          selectedChoice = 'Use default';
                        });
                      },
                      surfaceTintColor: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ChoiceChip(
                      backgroundColor: Colors.grey[200],
                      label: const Text('Use own values'),
                      selected: selectedChoice == 'Use own values',
                      onSelected: (bool value) {
                        setState(() {
                          selectedChoice = 'Use own values';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  maxLines: 7,
                  readOnly: selectedChoice != 'Use own values',
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
                    filled: selectedChoice != 'Use own values',
                    fillColor: Colors.grey[200],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
