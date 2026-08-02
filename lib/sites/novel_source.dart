/// 小説提供サイトを識別する列挙型。
///
/// 各サイトの固有ID（ncode等）やAPI仕様に依存しない、
/// プロバイダ非依存のサイト識別子として利用する。
enum NovelSource {
  /// 小説家になろう。
  narou('narou', '小説家になろう', 'https://ncode.syosetu.com'),

  /// カクヨム。
  kakuyomu('kakuyomu', 'カクヨム', 'https://kakuyomu.jp');

  /// コンストラクタ。
  const NovelSource(this.dbId, this.label, this.baseUrl);

  /// データベース保存用の識別子。enum名と同一。
  final String dbId;

  /// UI表示用のサイト名。
  final String label;

  /// ディープリンク解析用のベースURL。
  final String baseUrl;
}
