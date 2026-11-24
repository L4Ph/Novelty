/// A tiny navigation stack, and the adapter that renders it on Flutter.
///
/// `RouteStack` is plain Dart and holds the state: an ordered list of
/// destinations that tells listeners when it changes. It knows nothing about
/// widgets, tabs, URLs or data, so it stays usable from a host that is not
/// Flutter.
///
/// The rest turns a stack into `Navigator.pages`, which is the part of
/// Navigator 2.0 that is painful to write by hand: page keys, the
/// `onDidRemovePage` bookkeeping, and forwarding the system back to the right
/// navigator.
library;

export 'src/page_factory.dart';
export 'src/route_stack.dart';
export 'src/route_stack_delegate.dart';
export 'src/route_stack_navigator.dart';
