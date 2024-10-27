import 'dart:io';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/scaffold_messenger_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:ICARA/pages/home_page.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 1));

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Monte Carlo Simulation Model');
    setWindowMinSize(const Size(1000, 500));
  }
  setUpLocator();
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
      navigatorKey: locator<NavigationService>().navigatorKey,
      scaffoldMessengerKey: locator<ScaffoldMessengerService>().scaffoldKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(Colors.black),
          accentColor: createMaterialColor(Colors.black),
          brightness: Brightness.light,
        ),
      ),
      //theme: ThemeData(elevatedButtonTheme: ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
