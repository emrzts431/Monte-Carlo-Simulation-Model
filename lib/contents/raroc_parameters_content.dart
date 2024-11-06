// import 'package:ICARA/contents/correlation_inputs_content.dart';
import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RarocParametersContent extends StatefulWidget {
  const RarocParametersContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return RarocParametersContentState();
  }
}

class RarocParametersContentState extends State<RarocParametersContent> {
  String _confidenceLevel = '99.50% BBB+';
  int _numTrials = 10000;
  String _seedValue = '1';
  bool _isTCopulaChecked = false;
  final _seedValueController = TextEditingController();

  @override
  void initState() {
    _seedValueController.text = _seedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 140,
                              child: Text("Confidence Level:"),
                            ),
                            SizedBox(
                              width: 220,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _confidenceLevel,
                                focusColor: Colors.white,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                      width: 1.4,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                items: [
                                  '99.97% AAA',
                                  '99.95% AA+',
                                  '99.93% AA',
                                  '99.90% AA-',
                                  '99.87% A+',
                                  '99.83% A',
                                  '99.73% A-',
                                  '99.50% BBB+',
                                  '99.16% BBB',
                                  '98.25% BBB-',
                                  '96.60% BB+',
                                  '94.10% BB',
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _confidenceLevel = value!;
                                  });
                                },
                                dropdownColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 140,
                              child: Text("No. of Trials:"),
                            ),
                            SizedBox(
                              width: 220,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                value: _numTrials,
                                focusColor: Colors.white,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                      width: 1.4,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                items: [
                                  1000,
                                  10000,
                                  100000,
                                  500000,
                                ].map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _numTrials = value!;
                                  });
                                },
                                dropdownColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 140,
                              child: Text("Seed Value:"),
                            ),
                            SizedBox(
                              width: 220,
                              child: TextField(
                                controller: _seedValueController,
                                onChanged: (value) {
                                  setState(() {
                                    _seedValue = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                      width: 1.4,
                                      color: Colors.black,
                                    ),
                                  ),
                                  labelText: 'Seed Value',
                                ),
                                style: const TextStyle(color: Colors.black),
                                cursorColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _isTCopulaChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isTCopulaChecked = value!;
                                });
                              },
                            ),
                            const Text("T-Copula"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: context.watch<IcarasdkViewModel>().isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton.icon(
                              icon: const Icon(
                                Icons.play_arrow,
                                size: 32,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Run Simulation",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                backgroundColor: const Color(0xff00B0F0),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () async {
                                try {
                                  await context
                                      .read<IcarasdkViewModel>()
                                      .runSimulation(
                                        context,
                                        _isTCopulaChecked,
                                        _confidenceLevel,
                                        _numTrials,
                                        int.parse(_seedValue),
                                      );
                                } on Exception catch (error, stackTrace) {
                                  AppLogger.instance.error(error, stackTrace);
                                  SnackbarHolder.showSnackbar(
                                    "An error occured. Check if the values have the correct format.",
                                    true,
                                    locator<NavigationService>()
                                            .navigatorKey
                                            .currentContext ??
                                        context,
                                  );
                                }
                              },
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
