import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:flutter/material.dart';

class Bucket2CategoriesDialog extends StatefulWidget {
  const Bucket2CategoriesDialog({super.key});

  @override
  Bucket2CategoriesDialogState createState() => Bucket2CategoriesDialogState();
}

class Bucket2CategoriesDialogState extends State<Bucket2CategoriesDialog> {
  final _categoryValuesController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final categories = await Preferences.getBucketCategories(
          Preferences.BUCKET_2_CATEGORIES);
      String categoryString = "";
      for (var category in categories) {
        categoryString += '$category\n';
      }
      _categoryValuesController.text = categoryString;
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
          const Text('Bucket 2 Categories'),
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
                const SizedBox(
                  height: 10,
                ),
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
            } on Exception catch (e, stacktrace) {
              AppLogger.instance.error(e, stacktrace);
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
