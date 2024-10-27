import 'dart:io';
import 'dart:typed_data';

// import 'package:ICARA/pages/risk_inputs.dart';
// import 'package:ICARA/pages/home_page.dart';
import 'package:ICARA/contents/correlation_inputs_content.dart';
import 'package:ICARA/contents/pick_risks_content.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:ICARA/widgets/navigation_drawer.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class CapitalModeling extends StatefulWidget {
  const CapitalModeling({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CapitalModelingState();
  }
}

class _CapitalModelingState extends State<CapitalModeling> {
  int _currentIndex = 0; // Variable to track the selected content
  final _logger = Logger(
    printer: PrettyPrinter(methodCount: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Capital Modelling'),
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
              'Validation',
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
        return PickRisksContent(); // Default Excel Viewer content
      case 1:
        return const Center(child: Text('Content of Tab 1'));
      case 2:
        return CorrelationInputsContent();
      case 3:
        return const Center(child: Text('Content of Tab 3'));
      default:
        return PickRisksContent();
    }
  }
}
