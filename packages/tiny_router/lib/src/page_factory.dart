import 'package:flutter/material.dart';

/// Builds the [Page] that hosts one destination's widget.
///
/// A host supplies its own when the platform's page class differs. Keys are
/// created by the adapter, so implementations must pass [key] through.
typedef PageFactory = Page<void> Function(LocalKey key, Widget child);

/// The default [PageFactory]: platform transitions, back gesture included.
Page<void> materialPageFactory(LocalKey key, Widget child) =>
    MaterialPage<void>(key: key, child: child);

/// The page key for a destination at [index] of its stack.
///
/// The index is part of the key because the same destination can appear at
/// two positions (open a novel, follow its author, open the same novel). Keys
/// must be unique or `Navigator` asserts, and they must be stable or the
/// screens lose their state, so the position — which is a stack entry's
/// identity — is what varies.
LocalKey pageKeyFor(int index, Object destination) =>
    ValueKey<(int, Object)>((index, destination));
