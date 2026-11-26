import 'package:flutter/widgets.dart';
import 'package:tiny_state/src/async_value.dart';

/// Adapts a [Stream] into [Async] states.
///
/// A thin `StreamBuilder` wrapper: drift already shares one stream per identical
/// query and cancels it when the last listener goes, so this does not cache or
/// de-duplicate anything.
///
/// An error is reported but does not end the subscription — the next event
/// replaces it with data.
class StreamLoader<T> extends StatelessWidget {
  /// Creates a stream loader.
  const StreamLoader({required this.stream, required this.builder, super.key});

  /// The stream to follow. Pass the same reference across rebuilds when you can;
  /// a new reference re-subscribes.
  final Stream<T> stream;

  /// Builds the widget for each state.
  final Widget Function(BuildContext context, Async<T> state) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return builder(
            context,
            AsyncError<T>(
              snapshot.error!,
              snapshot.stackTrace ?? StackTrace.current,
            ),
          );
        }
        final data = snapshot.data;
        if (snapshot.hasData && data is T) {
          return builder(context, AsyncData<T>(data));
        }
        return builder(context, AsyncLoading<T>());
      },
    );
  }
}
