import 'package:flutter/material.dart';

class RouteTracker extends NavigatorObserver {//listen on push, pop, replace named routes
  static final RouteTracker _instance = RouteTracker._internal();
  factory RouteTracker() => _instance;//singleton

  RouteTracker._internal();

  String _currentRoute = '/';//keep track of the route

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRoute = route.settings.name ?? '/';
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _currentRoute = newRoute?.settings.name ?? '/';
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRoute = previousRoute?.settings.name ?? '/';
    super.didPop(route, previousRoute);
  }

  String getCurrentRoute() {
    return _currentRoute;
  }
}