import 'package:flutter/material.dart';
// import 'package:ICARA/main.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:ICARA/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<StatefulWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await context.read<IcarasdkViewModel>().init(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 235, 240),
      drawer: const CustomNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Monte Carlo Simulation Model'),
        surfaceTintColor: Colors.white,
        actions: context.watch<IcarasdkViewModel>().isLoading
            ? [
                const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 50),
              ]
            : null,
      ),
      body: Center(
        child: Image.asset(
          'assets/img/HomeViewAdvertisement.png',
        ),
      ),
    );
  }
}
