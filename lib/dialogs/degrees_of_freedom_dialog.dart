import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:flutter/material.dart';

class DegreesOfFreedomDialog extends StatefulWidget {
  const DegreesOfFreedomDialog({super.key});

  @override
  DegreesOfFreedomDialogState createState() => DegreesOfFreedomDialogState();
}

class DegreesOfFreedomDialogState extends State<DegreesOfFreedomDialog> {
  final _degreesOfFreedomController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final degreesOfFreedom = await Preferences.getDegreesOfFreedom();
      _degreesOfFreedomController.text = degreesOfFreedom.toString();
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _degreesOfFreedomController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
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
          onPressed: () async {
            try {
              await Preferences.setDegreesOfFreedom(
                int.parse(
                  _degreesOfFreedomController.text,
                ),
              ).then((value) {
                SnackbarHolder.showSnackbar(
                  'Successfully updated degrees of freedom value',
                  false,
                  locator<NavigationService>().navigatorKey.currentContext ??
                      context,
                );
              });
            } on Exception catch (error, stackTrace) {
              AppLogger.instance.error(error, stackTrace);
              SnackbarHolder.showSnackbar(
                'An error occured while updating degrees of freedom value',
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
