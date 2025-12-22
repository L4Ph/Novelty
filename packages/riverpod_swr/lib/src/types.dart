import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show AsyncValue;

/// SWRデータ取得の設定オプション。
class SwrOptions {
  /// [SwrOptions] インスタンスを作成します。
  const SwrOptions({
    this.staleTime = Duration.zero,
    this.gcTime = const Duration(minutes: 5),
    this.retryCount = 3,
    this.retryDelay = const Duration(milliseconds: 500),
    this.revalidateOnFocus = true,
    this.revalidateOnReconnect = true,
    this.dedupInterval = const Duration(seconds: 2),
  });

  /// キャッシュが古い（stale）とみなされるまでの期間。
  /// キャッシュがこれより新しい場合、フェッチはトリガーされません。
  final Duration staleTime;

  /// 使用されていないキャッシュがメモリに保持され、GC（ガベージコレクション）されるまでの期間。
  final Duration gcTime;

  /// フェッチが失敗した際の最大リトライ回数。
  final int retryCount;

  /// リトライ間の遅延時間。
  final Duration retryDelay;

  /// アプリにフォーカスが戻った際に再検証（revalidate）するかどうか。
  final bool revalidateOnFocus;

  /// ネットワークが再接続された際に再検証（revalidate）するかどうか。
  final bool revalidateOnReconnect;

  /// 同じキーに対する重複したリクエストを無視する間隔。
  final Duration dedupInterval;
}

/// 必要に応じてSWR固有のメタデータを保持できる [AsyncValue] のラッパー。
/// 現時点では `hasValue`、`hasError`、`isLoading` をサポートする [AsyncValue] を直接使用しています。
typedef SwrState<T> = AsyncValue<T>;
