import 'dart:async';

import 'package:riverpod_swr/src/swr_client.dart';
import 'package:riverpod_swr/src/types.dart';

/// 無限スクロール（ページネーション）クエリをサポートするための [SwrClient] 拡張。
extension InfiniteSwrExtension on SwrClient {
  /// 無限スクロール形式のリソースを監視します。
  /// [key] はコレクションのベースとなるキーを指定してください。
  Stream<List<T>> watchInfinite<T>({
    required String key,
    required Future<List<T>> Function(int page) fetcher,
    int initialPage = 0,
    SwrOptions options = const SwrOptions(),
  }) {
    // これは無限クエリの簡易的な実装です。
    // 実用的なシナリオでは、各ページを個別にキャッシュに保持することが望ましい場合があります。
    // 現時点では、リスト全体を単一のリソースとして扱っています。

    // 'infinite:$key' のような複合キーを使用します。
    final compositeKey = 'infinite:$key';

    return watch<List<T>>(
      key: compositeKey,
      fetcher: () => fetcher(initialPage),
      options: options,
    );
  }
}
