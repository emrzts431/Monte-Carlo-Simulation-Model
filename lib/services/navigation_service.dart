import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(String routeName, {Map<String, dynamic>? args}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: args);
  }

  Future<dynamic>? navigateToAndRemove(String routeName,
      {Map<String, dynamic>? args}) {
    return navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: args);
  }

  Future<dynamic>? navigateToAndRemoveUntil(String routeName,
      {Map<String, dynamic>? args}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: args);
  }
}
