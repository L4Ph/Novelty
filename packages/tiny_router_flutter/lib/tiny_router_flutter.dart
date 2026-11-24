/// Navigator 2.0 adapter for `tiny_router`.
///
/// Turns a `RouteStack` into `Navigator.pages`, which is the part of
/// Navigator 2.0 that is painful to write by hand: page keys, the
/// `onDidRemovePage` bookkeeping, and forwarding the system back to the
/// right navigator.
library;

export 'src/page_factory.dart';
export 'src/route_stack_delegate.dart';
export 'src/route_stack_navigator.dart';
