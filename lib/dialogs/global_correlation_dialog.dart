import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:flutter/material.dart';

class GlobalCorrelationDialog extends StatefulWidget {
  const GlobalCorrelationDialog({super.key});

  @override
  GlobalCorrelationDialogState createState() => GlobalCorrelationDialogState();
}

class GlobalCorrelationDialogState extends State<GlobalCorrelationDialog> {
  final _globalCorrelationController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final globalCorrelation = await Preferences.getGlobalCorrelation();
      _globalCorrelationController.text = globalCorrelation.toString();
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
          const Text('Global Corellation'),
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
              controller: _globalCorrelationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
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
          onPressed: () async {
            try {
              await Preferences.setGlobalCorrelation(
                double.parse(
                  _globalCorrelationController.text,
                ),
              ).then((value) {
                SnackbarHolder.showSnackbar(
                  'Global correlation successfully updated',
                  false,
                  locator<NavigationService>().navigatorKey.currentContext ??
                      context,
                );
              });
            } on Exception catch (error, stackTrace) {
              AppLogger.instance.error(error, stackTrace);
              SnackbarHolder.showSnackbar(
                'Error while updating global correlation value',
                true,
                locator<NavigationService>().navigatorKey.currentContext ??
                    context,
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
