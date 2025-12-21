import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_swr/src/swr_client.dart';

part 'swr_providers.g.dart';

/// [SwrClient] インスタンスを提供するプロバイダー。
///
/// このクライアントは実行中のリクエスト、キャッシュ、重複排除を含む
/// SWRの状態を管理します。
@Riverpod(keepAlive: true)
SwrClient swrClient(Ref ref) {
  return SwrClient();
}

/// 指定された [key] のフェッチが現在進行中かどうかを返します。
@riverpod
Stream<bool> swrLoading(Ref ref, String key) {
  final client = ref.watch(swrClientProvider);

  // 以下のストリームを作成します：
  // 1. 現在のローディング状態を即座に発行する。
  // 2. このキーに関する更新をリッスンする。

  // メモ: 初期値とストリームイベントを組み合わせるために generator を使用します。
  return Stream.multi((controller) {
    controller.add(client.isLoading(key));

    final subscription = client.loadingUpdates.listen((event) {
      if (event.$1 == key) {
        controller.add(event.$2);
      }
    });

    controller.onCancel = subscription.cancel;
  });
}
