import 'dart:io';

import 'package:flutter/services.dart';

/// Saving a file or picking one to restore, on Android and iOS only.
///
/// Desktop is deliberately unsupported: the database is a plain file there, so
/// the user can copy it without the app getting involved. [isSupported] lets
/// the UI say so instead of showing buttons that cannot work.
class FilePicker {
  /// Creates a picker. Tests inject a [MethodChannel] and a platform flag.
  FilePicker({MethodChannel? channel, bool? supported})
    : _channel = channel ?? const MethodChannel('novelty/file_picker'),
      _supported = supported ?? platformSupports;

  final MethodChannel _channel;
  final bool _supported;

  /// Whether the running platform implements the picker.
  static bool get platformSupports => Platform.isAndroid || Platform.isIOS;

  /// Whether this instance can pick files.
  bool get isSupported => _supported;

  /// Saves [sourcePath] to a location the user chooses.
  ///
  /// The file is streamed, never loaded into memory, so a large backup is fine.
  /// Returns the name of the saved file, or null when the user cancels.
  Future<String?> saveFile({
    required String sourcePath,
    required String suggestedName,
    String? dialogTitle,
  }) async {
    _requireSupport();
    return _channel.invokeMethod<String>('saveFile', <String, Object?>{
      'sourcePath': sourcePath,
      'suggestedName': suggestedName,
      'dialogTitle': dialogTitle,
    });
  }

  /// Lets the user pick a file and copies it into [cacheDirectory].
  ///
  /// Returns the path of the copy, or null when the user cancels. The caller
  /// owns the copy and should delete it.
  Future<String?> pickFile({
    required String cacheDirectory,
    List<String> extensions = const <String>[],
    String? dialogTitle,
  }) async {
    _requireSupport();
    return _channel.invokeMethod<String>('pickFile', <String, Object?>{
      'cacheDirectory': cacheDirectory,
      'extensions': extensions,
      'dialogTitle': dialogTitle,
    });
  }

  void _requireSupport() {
    if (!_supported) {
      throw UnsupportedError(
        'novelty_file_picker only supports Android and iOS; '
        'handle this platform in the UI instead.',
      );
    }
  }
}
