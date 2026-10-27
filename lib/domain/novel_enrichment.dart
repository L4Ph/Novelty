import 'package:novelty/models/novel_info.dart';

/// APIデータとローカルライブラリの状態の両方を含む、充実した新規データ
class EnrichedNovelData {
  /// Constructor
  const EnrichedNovelData({
    required this.novel,
    required this.isInLibrary,
  });

  /// The novel data from API
  final NovelInfo novel;

  /// Whether the novel is in user's library
  final bool isInLibrary;

  /// 小説の画像URLを取得する。
  String get imageUrl {
    // ncodeから数字部分を抽出（なろう専用）
    final ncode = novel.ncode;
    if (ncode == null || ncode.length < 2) return '';
    final ncodeNumber = ncode.substring(1);
    return 'https://img.syosetu.com/image/$ncodeNumber.jpg';
  }
}
