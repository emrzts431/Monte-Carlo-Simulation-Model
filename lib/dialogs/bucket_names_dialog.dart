import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:flutter/material.dart';

class BucketNamesDialog extends StatefulWidget {
  const BucketNamesDialog({super.key});

  @override
  BucketNamesDialogState createState() => BucketNamesDialogState();
}

class BucketNamesDialogState extends State<BucketNamesDialog> {
  TextEditingController _bucket1Controller = TextEditingController();
  TextEditingController _bucet2Controller = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final _bucketNames = await Preferences.getBucketNames();
      _bucket1Controller.text = _bucketNames[0];
      _bucet2Controller.text = _bucketNames[1];
    });

    super.initState();
  }

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
          const Text('Bucket Names'),
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
            TextField(
              controller: _bucket1Controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                labelText: 'Bucket Name',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _bucet2Controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                labelText: 'Bucket Name',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              final updatedBucket1Name = _bucket1Controller.text;
              final updatedBucket2Name = _bucet2Controller.text;
              await Preferences.updateBucketNames(
                      updatedBucket1Name, updatedBucket2Name)
                  .then((value) {
                SnackbarHolder.showSnackbar(
                    'Successfully updated changes',
                    false,
                    locator<NavigationService>().navigatorKey.currentContext ??
                        context);
              });
            } on Exception catch (e, stackTrace) {
              AppLogger.instance.error(e, stackTrace);
              SnackbarHolder.showSnackbar(
                  'An error occured while saving bucket names',
                  true,
                  locator<NavigationService>().navigatorKey.currentContext ??
                      context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
