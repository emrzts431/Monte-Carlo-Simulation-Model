import 'package:flutter/material.dart';

class RunSimulationContent extends StatefulWidget {
  const RunSimulationContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return RunSimulationContentState();
  }
}

class RunSimulationContentState extends State<RunSimulationContent> {
  String _confidenceLevel = '95.0%';
  String _numTrials = '10,000';
  String _seedValue = '';
  bool _isTCopulaChecked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                            items:
                                ['95.0%', '99.0%', '99.9%'].map((String value) {
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
                      children: [
                        const SizedBox(
                          width: 140,
                          child: Text("No. of Trials:"),
                        ),
                        SizedBox(
                          width: 220,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _numTrials,
                            focusColor: Colors.white,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                            items: ['1,000', '10,000', '100,000']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
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
                      children: [
                        const SizedBox(
                          width: 140,
                          child: Text("Seed Value:"),
                        ),
                        SizedBox(
                          width: 220,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _seedValue = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                              hintText: 'Value',
                            ),
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
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
                const SizedBox(width: 50),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.play_arrow,
                      size: 32,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Run Simulation",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      backgroundColor: const Color(0xff00B0F0),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      debugPrint(_confidenceLevel);
                      debugPrint(_numTrials);
                      debugPrint(_seedValue);
                      debugPrint(_isTCopulaChecked.toString());
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
