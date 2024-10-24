import 'package:flutter/material.dart';
import 'package:ICARA/pages/home_page.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 1));

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => IcarasdkViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monte Carlo Simulation Model',
      color: Colors.white,
      //theme: ThemeData(elevatedButtonTheme: ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
