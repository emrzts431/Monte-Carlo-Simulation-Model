import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:flutter/material.dart';

class Bucket1CategoriesDialog extends StatefulWidget {
  const Bucket1CategoriesDialog({super.key});

  @override
  Bucket1CategoriesDialogState createState() => Bucket1CategoriesDialogState();
}

class Bucket1CategoriesDialogState extends State<Bucket1CategoriesDialog> {
  final _categoryValuesController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final categories = await Preferences.getBucketCategories(
          Preferences.BUCKET_1_CATEGORIES);
      String categoriesString = "";
      for (var category in categories) {
        categoriesString += '$category\n';
      }
      _categoryValuesController.text = categoriesString;
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
          const Text('Bucket 1 Categories'),
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
                TextField(
                  controller: _categoryValuesController,
                  maxLines: 7,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
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
          onPressed: () async {
            try {
              final categories = _categoryValuesController.text.split('\n');
              await Preferences.setBucketCategories(
                      categories, Preferences.BUCKET_1_CATEGORIES)
                  .then((value) {
                SnackbarHolder.showSnackbar(
                    'Successfully saved changes',
                    false,
                    locator<NavigationService>().navigatorKey.currentContext ??
                        context);
              });
            } on Exception catch (e, stackTrace) {
              AppLogger.instance.error(e, stackTrace);
              SnackbarHolder.showSnackbar(
                  'An error occured while updating categories',
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
