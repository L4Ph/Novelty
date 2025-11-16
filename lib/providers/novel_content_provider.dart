import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/repositories/novel_repository.dart';

/// 小説のコンテンツを取得するプロバイダー。
// ignore: specify_nonobvious_property_types
final novelContentProvider = FutureProvider.autoDispose
    .family<List<NovelContentElement>, ({String ncode, int episode})>((
      ref,
      params,
    ) async {
      final repository = ref.read(novelRepositoryProvider);
      return repository.getEpisode(params.ncode, params.episode);
    });
