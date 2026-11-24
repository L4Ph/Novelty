/// A tiny navigation stack.
///
/// Holds an ordered list of destinations and tells listeners when it changes.
/// It deliberately knows nothing about widgets, tabs, URLs or data: a host
/// adapter turns a `RouteStack` into whatever its declarative router
/// consumes (on Flutter, `Navigator.pages`).
library;

export 'src/route_stack.dart';
