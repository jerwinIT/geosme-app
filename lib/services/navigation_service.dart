import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  // Track navigation history
  final List<String> _navigationHistory = [];

  // Add route to history
  void addRoute(String routeName) {
    _navigationHistory.add(routeName);
  }

  // Get previous route
  String? getPreviousRoute() {
    if (_navigationHistory.length > 1) {
      _navigationHistory.removeLast();
      return _navigationHistory.last;
    }
    return null;
  }

  // Clear history
  void clearHistory() {
    _navigationHistory.clear();
  }

  // Navigate with proper back button handling
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    Widget screen, {
    String? routeName,
    bool replace = false,
    bool clearStack = false,
  }) {
    if (routeName != null) {
      NavigationService().addRoute(routeName);
    }

    if (clearStack) {
      return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (route) => false,
      );
    } else if (replace) {
      return Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => screen));
    } else {
      return Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => screen));
    }
  }

  // Smart back navigation
  static void smartPop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // If can't pop, navigate to a default screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Welcome to GeoSME'))),
        ),
        (route) => false,
      );
    }
  }
}
