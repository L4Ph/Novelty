import 'package:flutter/material.dart';

/// 縦書きモード時のホームジェスチャー誤爆を防ぐための透明シールド
///
/// 画面下部のシステムジェスチャー領域に配置し、垂直スワイプを
/// 消費することでホームジェスチャーとの競合を回避します。
class GestureShield extends StatelessWidget {
  /// コンストラクタ
  const GestureShield({super.key});

  /// シールドの追加高さ（システムジェスチャー領域に加える余裕）
  static const double _kExtraHeight = 40;

  @override
  Widget build(BuildContext context) {
    final systemGestureInsets = MediaQuery.of(context).systemGestureInsets;
    final shieldHeight = systemGestureInsets.bottom + _kExtraHeight;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: shieldHeight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (_) {},
        onVerticalDragUpdate: (_) {},
        onVerticalDragEnd: (_) {},
        child: const SizedBox.expand(),
      ),
    );
  }
}
