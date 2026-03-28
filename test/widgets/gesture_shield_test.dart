import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/widgets/gesture_shield.dart';

void main() {
  group('GestureShield', () {
    testWidgets('画面下部に配置される', (tester) async {
      // Arrange
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              systemGestureInsets: EdgeInsets.only(bottom: 20),
            ),
            child: Scaffold(
              body: Stack(
                children: [
                  SizedBox.expand(),
                  GestureShield(),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert: Positionedウィジェットが存在する
      expect(find.byType(Positioned), findsOneWidget);

      // Assert: 下端に配置されている
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.bottom, 0);
      expect(positioned.left, 0);
      expect(positioned.right, 0);
    });

    testWidgets('高さはsystemGestureInsets.bottom + 40で計算される', (tester) async {
      // Arrange
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              systemGestureInsets: EdgeInsets.only(bottom: 25),
            ),
            child: Scaffold(
              body: Stack(
                children: [
                  SizedBox.expand(),
                  GestureShield(),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.height, 65); // 25 + 40
    });

    testWidgets('HitTestBehavior.opaqueでジェスチャーを消費する', (tester) async {
      // Arrange
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);

      var backgroundDragStarted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              systemGestureInsets: EdgeInsets.only(bottom: 20),
            ),
            child: Scaffold(
              body: Stack(
                children: [
                  // 背景のタッチ検出
                  GestureDetector(
                    onVerticalDragStart: (_) {
                      backgroundDragStarted = true;
                    },
                    child: const ColoredBox(color: Colors.white),
                  ),
                  const GestureShield(),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert: GestureDetectorが存在する
      final gestureDetector = find.descendant(
        of: find.byType(GestureShield),
        matching: find.byType(GestureDetector),
      );
      expect(gestureDetector, findsOneWidget);

      // Assert: HitTestBehavior.opaqueである
      final detector = tester.widget<GestureDetector>(gestureDetector);
      expect(detector.behavior, HitTestBehavior.opaque);

      // Act: シールド領域で縦スワイプをシミュレート
      await tester.dragFrom(
        const Offset(200, 760), // シールド内（下端から20px）
        const Offset(0, -100),
      );
      await tester.pump();

      // Assert: 背景のGestureDetectorは反応していない
      expect(backgroundDragStarted, isFalse);
    });

    testWidgets('垂直スワイプのコールバックが設定されている', (tester) async {
      // Arrange
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              systemGestureInsets: EdgeInsets.only(bottom: 20),
            ),
            child: Scaffold(
              body: Stack(
                children: [
                  SizedBox.expand(),
                  GestureShield(),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert
      final gestureDetector = tester.widget<GestureDetector>(
        find.descendant(
          of: find.byType(GestureShield),
          matching: find.byType(GestureDetector),
        ),
      );

      expect(gestureDetector.onVerticalDragStart, isNotNull);
      expect(gestureDetector.onVerticalDragUpdate, isNotNull);
      expect(gestureDetector.onVerticalDragEnd, isNotNull);
    });

    testWidgets('systemGestureInsets.bottomが0でも正しく動作する', (tester) async {
      // Arrange
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(),
            child: Scaffold(
              body: Stack(
                children: [
                  SizedBox.expand(),
                  GestureShield(),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert: 最低限の高さ（40）が確保される
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.height, 40);
    });
  });
}
