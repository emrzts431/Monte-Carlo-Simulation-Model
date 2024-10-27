import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Bucket Names"),
            leading: Image.asset(
              'assets/icons/manageBucketSettings.png',
              scale: 10,
              width: 36,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bucket Names'),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    content: const SizedBox(
                      width: 350,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              labelText: 'Bucket 1 Title',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              labelText: 'Bucket 2 Title',
                            ),
                          ),
                        ],
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
                },
              );
            },
          ),
          ListTile(
            title: const Text("Bucket 1 Categories"),
            leading: Image.asset(
              'assets/icons/Sand_bucket.png',
              scale: 10,
              width: 32,
            ),
            onTap: () {
              String selectedChoice = 'Use default';

              showDialog(
                context: context,
                builder: (BuildContext context) {
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
                                    selected:
                                        selectedChoice == 'Use own values',
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
                },
              );
            },
          ),
          ListTile(
            title: const Text("Bucket 2 Categories"),
            leading: Image.asset(
              'assets/icons/Sand_bucket.png',
              scale: 10,
              width: 32,
            ),
            onTap: () {
              String selectedChoice = 'Use default';

              showDialog(
                context: context,
                builder: (BuildContext context) {
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
                                    selected:
                                        selectedChoice == 'Use own values',
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
                },
              );
            },
          ),
          ListTile(
            title: const Text("Global Corellation"),
            leading: Image.asset(
              'assets/icons/global_correlation.png',
              scale: 10,
              width: 32,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Global Corellation'),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    content: const SizedBox(
                      width: 350,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              labelText: 'Global Corellation Value',
                            ),
                          ),
                        ],
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
                },
              );
            },
          ),
          ListTile(
            title: const Text("Degrees of Freedom"),
            leading: Image.asset(
              'assets/icons/degrees_of_freedom.png',
              scale: 10,
              width: 32,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
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
                    content: const SizedBox(
                      width: 350,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              labelText: 'Degrees of Freedom',
                            ),
                          ),
                        ],
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
                },
              );
            },
          ),
          ListTile(
            title: const Text("Model Assumptions"),
            leading: Image.asset(
              'assets/icons/model_assumption.png',
              scale: 10,
              width: 32,
            ),
            onTap: () {
              String? dropdownValue = 'Item 1';

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Model Assumptions'),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              labelText: 'Textfield 1',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              labelText: 'Textfield 2',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButton(
                                  underline: Container(),
                                  borderRadius: BorderRadius.circular(4),
                                  focusColor: Colors.white,
                                  isExpanded: true,
                                  value: dropdownValue,
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  items: <String>['Item 1', 'Item 2', 'Item 3']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ],
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
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
