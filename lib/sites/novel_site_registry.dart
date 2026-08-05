import 'package:novelty/sites/kakuyomu/kakuyomu_site.dart';
import 'package:novelty/sites/narou/narou_site.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'novel_site_registry.g.dart';

/// サイト種別とサイト実装の対応を管理するレジストリ。
///
/// カクヨムはDioを保持するためconstにはできない。
final Map<NovelSource, NovelSite> defaultNovelSiteRegistry =
    <NovelSource, NovelSite>{
      NovelSource.narou: const NarouSite(),
      NovelSource.kakuyomu: KakuyomuSite(),
    };

/// サイト種別とサイト実装の対応を提供するプロバイダ。
///
/// テスト時は [novelSiteRegistryProvider] をオーバーライドして
/// カクヨム等のサイト実装を差し替えられるようにする。
@riverpod
Map<NovelSource, NovelSite> novelSiteRegistry(Ref ref) =>
    defaultNovelSiteRegistry;
