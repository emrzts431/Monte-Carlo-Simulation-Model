import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:flutter/material.dart';

class ModelAssumptionDialog extends StatefulWidget {
  const ModelAssumptionDialog({super.key});

  @override
  ModelAssumptionDialogState createState() => ModelAssumptionDialogState();
}

class ModelAssumptionDialogState extends State<ModelAssumptionDialog> {
  final _defWCaseController = TextEditingController();
  final _defTCaseController = TextEditingController();

  String? dropdownValue = 'LogNormal';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final modelAssumptions = await Preferences.getModelAssumptions();
      _defTCaseController.text = modelAssumptions['typicalCase'].toString();
      _defWCaseController.text = modelAssumptions['worstCase'].toString();
      dropdownValue = modelAssumptions['sevModel'];
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
            TextField(
              controller: _defWCaseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                labelText: 'Def. of Worst Case',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _defTCaseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                labelText: 'Def. of Typical Case',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(4),
                    focusColor: Colors.white,
                    isExpanded: true,
                    value: dropdownValue,
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    items: <String>['LogNormal'].map((String value) {
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
          onPressed: () async {
            try {
              await Preferences.setModelAssumptions(
                _defWCaseController.text,
                _defTCaseController.text,
                dropdownValue ?? 'LogNormal',
              ).then((value) {
                SnackbarHolder.showSnackbar(
                  'Successfully updated model assumptions',
                  false,
                  locator<NavigationService>().navigatorKey.currentContext ??
                      context,
                );
              });
            } on Exception catch (error, stackTrace) {
              AppLogger.instance.error(error, stackTrace);
              SnackbarHolder.showSnackbar(
                'An error occured while updating model assumptions',
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
