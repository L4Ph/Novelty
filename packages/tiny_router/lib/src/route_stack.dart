/// An ordered stack of destinations, the last entry being the topmost screen.
///
/// The initial entries are the floor: [canPop] is false once only they are
/// left. A tab stack starts with its root destination, so it can never empty
/// out; an overlay stack starts empty, so its last entry can still be popped.
class RouteStack<D extends Object> {
  /// Creates a stack that starts at [initial] and can never pop below it.
  RouteStack([Iterable<D>? initial])
    : _initial = List<D>.unmodifiable(initial ?? <D>[]),
      _entries = List<D>.of(initial ?? <D>[]);

  final List<D> _initial;
  final List<D> _entries;
  final List<void Function()> _listeners = <void Function()>[];

  /// Entries from bottom to top.
  List<D> get entries => List<D>.unmodifiable(_entries);

  /// The topmost destination, or null when the stack is empty.
  D? get top => _entries.isEmpty ? null : _entries.last;

  /// How many destinations are on the stack.
  int get length => _entries.length;

  /// Whether [pop] would remove anything.
  bool get canPop => _entries.length > _initial.length;

  /// Whether the stack is back at its initial entries.
  bool get isAtFloor => _entries.length <= _initial.length;

  /// Puts [destination] on top.
  ///
  /// Pushing the destination that is already on top is a no-op. Callers reach
  /// here from taps, and two equal entries would mean two pages with the same
  /// key, which `Navigator` rejects in debug mode.
  void push(D destination) {
    if (_entries.isNotEmpty && _entries.last == destination) {
      return;
    }
    _entries.add(destination);
    _notify();
  }

  /// Removes the topmost destination. Returns false when nothing was removed.
  bool pop() {
    if (!canPop) {
      return false;
    }
    _entries.removeLast();
    _notify();
    return true;
  }

  /// Pops until only the initial entries are left.
  void popToRoot() {
    if (isAtFloor) {
      return;
    }
    _entries.removeRange(_initial.length, _entries.length);
    _notify();
  }

  /// Swaps the topmost destination for [destination].
  ///
  /// Keeps the rest of the stack, so the screen is replaced in place rather
  /// than pushed.
  void replaceTop(D destination) {
    if (_entries.isEmpty) {
      return;
    }
    if (_entries.last == destination) {
      return;
    }
    _entries[_entries.length - 1] = destination;
    _notify();
  }

  /// Restores the initial entries.
  void clear() {
    if (_entries.length == _initial.length &&
        _entries.indexed.every((pair) => pair.$2 == _initial[pair.$1])) {
      return;
    }
    _entries
      ..clear()
      ..addAll(_initial);
    _notify();
  }

  /// Registers [listener] to be called after every change.
  void addListener(void Function() listener) => _listeners.add(listener);

  /// Unregisters a listener added by [addListener].
  void removeListener(void Function() listener) => _listeners.remove(listener);

  void _notify() {
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }
}
