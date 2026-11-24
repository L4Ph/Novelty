import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/services/file_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('novelty/file_picker');

  void mock(List<MethodCall> calls, {String? savedPath, String? pickedPath}) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return call.method == 'saveFile' ? savedPath : pickedPath;
        });
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('FilePicker', () {
    test('refuses to run on an unsupported platform', () async {
      final picker = FilePicker(supported: false);

      await expectLater(
        picker.saveFile(sourcePath: '/tmp/a.db', suggestedName: 'a.db'),
        throwsA(isA<UnsupportedError>()),
      );
      await expectLater(
        picker.pickFile(cacheDirectory: '/tmp'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('reports the platform it runs on', () {
      final expected = Platform.isAndroid || Platform.isIOS;
      expect(FilePicker.platformSupports, equals(expected));
    });

    test('passes the source path and suggested name to the platform', () async {
      final calls = <MethodCall>[];
      mock(calls, savedPath: 'novelty_backup.db');
      final picker = FilePicker(supported: true);

      final saved = await picker.saveFile(
        sourcePath: '/cache/novelty_backup.db',
        suggestedName: 'novelty_backup_v19.db',
        dialogTitle: '保存先',
      );

      expect(saved, equals('novelty_backup.db'));
      expect(calls.single.method, equals('saveFile'));
      expect(
        calls.single.arguments,
        equals(<String, Object?>{
          'sourcePath': '/cache/novelty_backup.db',
          'suggestedName': 'novelty_backup_v19.db',
          'dialogTitle': '保存先',
        }),
      );
    });

    test('asks the platform to copy a picked file into the cache', () async {
      final calls = <MethodCall>[];
      mock(calls, pickedPath: '/cache/novelty_backup.db');
      final picker = FilePicker(supported: true);

      final path = await picker.pickFile(
        cacheDirectory: '/cache',
        extensions: <String>['db'],
      );

      expect(path, equals('/cache/novelty_backup.db'));
      expect(calls.single.method, equals('pickFile'));
      expect(
        calls.single.arguments,
        equals(<String, Object?>{
          'cacheDirectory': '/cache',
          'extensions': <String>['db'],
          'dialogTitle': null,
        }),
      );
    });

    test('passes a cancellation through as null', () async {
      final calls = <MethodCall>[];
      mock(calls);
      final picker = FilePicker(supported: true);

      expect(
        await picker.saveFile(sourcePath: '/tmp/a.db', suggestedName: 'a.db'),
        isNull,
      );
      expect(await picker.pickFile(cacheDirectory: '/tmp'), isNull);
    });
  });
}
