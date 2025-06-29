import 'package:ICARA/contents/correlation_inputs_content.dart';
import 'package:ICARA/contents/pick_risks_content.dart';
import 'package:ICARA/contents/report_content.dart';
import 'package:ICARA/contents/run_simulation_content.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:ICARA/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CapitalModeling extends StatefulWidget {
  const CapitalModeling({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CapitalModelingState();
  }
}

class _CapitalModelingState extends State<CapitalModeling> {
  _CapitalModelingState();

  late int currentIndex;
  @override
  void initState() {
    currentIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await (locator<NavigationService>().navigatorKey.currentContext ??
              context)
          .read<IcarasdkViewModel>()
          .initiateSdkFolder();

      (locator<NavigationService>().navigatorKey.currentContext ?? context)
          .read<IcarasdkViewModel>()
          .resetParameters();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 235, 240),
      appBar: AppBar(
        title: const Text('Capital Modelling'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: currentIndex == 0
                    ? Colors.blueGrey
                    : const Color(0xff00B0F0),
                elevation: 0),
            onPressed: () {
              setState(() {
                currentIndex = 0;
              });
            },
            child: Text(
              'Risk Inputs',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: currentIndex == 1
                    ? Colors.blueGrey
                    : const Color(0xff00B0F0),
                elevation: 0),
            onPressed: () {
              setState(() {
                currentIndex = 1;
              });
            },
            child: Text(
              'Validation',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: currentIndex == 2
                    ? Colors.blueGrey
                    : const Color(0xff00B0F0),
                elevation: 0),
            onPressed: () {
              setState(() {
                currentIndex = 2;
              });
            },
            child: Text(
              'Correlation Inputs',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: currentIndex == 3
                    ? Colors.blueGrey
                    : const Color(0xff00B0F0),
                elevation: 0),
            onPressed: () {
              setState(() {
                currentIndex = 3;
              });
            },
            child: Text(
              'Simulation',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: currentIndex == 4
                    ? Colors.blueGrey
                    : const Color(0xff00B0F0),
                elevation: 0),
            onPressed: () {
              setState(() {
                currentIndex = 4;
              });
            },
            child: Text(
              'Report',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
      drawer: const CustomNavigationDrawer(),
      body: Stack(
        children: [
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: _getContentWidget(),
          ),
        ],
      ),
    );
  }

  // Method to return content based on the selected index
  Widget _getContentWidget() {
    switch (currentIndex) {
      case 0:
        return const PickRisksContent(); // Default Excel Viewer content
      case 1:
        return const Center(child: Text('Content of Tab 1'));
      case 2:
        return const CorrelationInputsContent();
      case 3:
        return const RunSimulationContent();
      case 4:
        return ReportContent();
      default:
        return const PickRisksContent();
    }
  }
}
