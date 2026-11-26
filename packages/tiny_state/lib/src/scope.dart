import 'package:flutter/widgets.dart';

/// Provides the app's terminal services to the widget tree.
///
/// This is the DI seam: the database, the API client and the clock are looked
/// up by type, and tests wrap the widget under test in a `Scope` whose map
/// swaps them for fakes. Everything above this layer takes its collaborators as
/// constructor arguments.
class Scope extends InheritedWidget {
  /// Creates a scope.
  const Scope({required this.services, required super.child, super.key});

  /// The services, keyed by the type they are looked up with.
  final Map<Type, Object> services;

  /// The nearest scope.
  static Scope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<Scope>();
    assert(scope != null, 'No Scope above this widget');
    return scope!;
  }

  /// The nearest scope, or null.
  static Scope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Scope>();

  /// A service by type.
  T get<T extends Object>() {
    final service = services[T];
    if (service is T) {
      return service;
    }
    throw StateError(
      'Scope has no $T. Registered: ${services.keys.join(', ')}',
    );
  }

  /// A service by type, or null.
  T? maybe<T extends Object>() {
    final service = services[T];
    return service is T ? service : null;
  }

  @override
  bool updateShouldNotify(Scope oldWidget) =>
      !identical(services, oldWidget.services);
}

/// Reads a service without subscribing to scope changes.
///
/// Use this in callbacks; use [Scope.of] with `get` in `build` when the widget
/// should rebuild if the scope is replaced.
T servicesOf<T extends Object>(BuildContext context) =>
    Scope.of(context).get<T>();
