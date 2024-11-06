// import 'dart:io';
// import 'dart:typed_data';

import 'package:ICARA/contents/correlation_inputs_content.dart';
import 'package:ICARA/contents/pick_risks_content.dart';
import 'package:ICARA/contents/run_simulation_content.dart';
import 'package:ICARA/contents/insurance_parameters_content.dart';
import 'package:ICARA/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';

class InsurancePricing extends StatefulWidget {
  const InsurancePricing({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InsurancePricingState();
  }
}

class _InsurancePricingState extends State<InsurancePricing> {
  int _currentIndex = 0; // Variable to track the selected content

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Insurance Pricing'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00B0F0), elevation: 0),
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
            child: const Text(
              'Risk Inputs',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00B0F0), elevation: 0),
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            child: const Text(
              'Insurance Parameters',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00B0F0), elevation: 0),
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
            },
            child: const Text(
              'Correlation Inputs',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00B0F0), elevation: 0),
            onPressed: () {
              setState(() {
                _currentIndex = 3;
              });
            },
            child: const Text(
              'Simulation',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00B0F0), elevation: 0),
            onPressed: () {
              setState(() {
                _currentIndex = 3;
              });
            },
            child: const Text(
              'Detailed Report',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
      drawer: const CustomNavigationDrawer(),
      body: Column(
        children: [
          // Buttons at the top
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [

          //   ],
          // ),
          // Dynamic content based on the button clicked
          Expanded(
            child: _getContentWidget(),
          ),
        ],
      ),
    );
  }

  // Method to return content based on the selected index
  Widget _getContentWidget() {
    switch (_currentIndex) {
      case 0:
        return const PickRisksContent(); // Default Excel Viewer content
      case 1:
        return const InsuranceParametersContent();
      case 2:
        return const CorrelationInputsContent();
      case 3:
        return const RunSimulationContent();
      default:
        return const PickRisksContent();
    }
  }
}
