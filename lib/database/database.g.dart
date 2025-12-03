// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NovelsTable extends Novels with drift.TableInfo<$NovelsTable, Novel> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NovelsTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _ncodeMeta = const drift.VerificationMeta(
    'ncode',
  );
  @override
  late final drift.GeneratedColumn<String> ncode =
      drift.GeneratedColumn<String>(
        'ncode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _titleMeta = const drift.VerificationMeta(
    'title',
  );
  @override
  late final drift.GeneratedColumn<String> title =
      drift.GeneratedColumn<String>(
        'title',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _writerMeta =
      const drift.VerificationMeta('writer');
  @override
  late final drift.GeneratedColumn<String> writer =
      drift.GeneratedColumn<String>(
        'writer',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _storyMeta = const drift.VerificationMeta(
    'story',
  );
  @override
  late final drift.GeneratedColumn<String> story =
      drift.GeneratedColumn<String>(
        'story',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _novelTypeMeta =
      const drift.VerificationMeta('novelType');
  @override
  late final drift.GeneratedColumn<int> novelType = drift.GeneratedColumn<int>(
    'novel_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _endMeta = const drift.VerificationMeta(
    'end',
  );
  @override
  late final drift.GeneratedColumn<int> end = drift.GeneratedColumn<int>(
    'end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _genreMeta = const drift.VerificationMeta(
    'genre',
  );
  @override
  late final drift.GeneratedColumn<int> genre = drift.GeneratedColumn<int>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _isr15Meta = const drift.VerificationMeta(
    'isr15',
  );
  @override
  late final drift.GeneratedColumn<int> isr15 = drift.GeneratedColumn<int>(
    'isr15',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _isblMeta = const drift.VerificationMeta(
    'isbl',
  );
  @override
  late final drift.GeneratedColumn<int> isbl = drift.GeneratedColumn<int>(
    'isbl',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _isglMeta = const drift.VerificationMeta(
    'isgl',
  );
  @override
  late final drift.GeneratedColumn<int> isgl = drift.GeneratedColumn<int>(
    'isgl',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _iszankokuMeta =
      const drift.VerificationMeta('iszankoku');
  @override
  late final drift.GeneratedColumn<int> iszankoku = drift.GeneratedColumn<int>(
    'iszankoku',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _istenseiMeta =
      const drift.VerificationMeta('istensei');
  @override
  late final drift.GeneratedColumn<int> istensei = drift.GeneratedColumn<int>(
    'istensei',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _istenniMeta =
      const drift.VerificationMeta('istenni');
  @override
  late final drift.GeneratedColumn<int> istenni = drift.GeneratedColumn<int>(
    'istenni',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _keywordMeta =
      const drift.VerificationMeta('keyword');
  @override
  late final drift.GeneratedColumn<String> keyword =
      drift.GeneratedColumn<String>(
        'keyword',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _generalFirstupMeta =
      const drift.VerificationMeta('generalFirstup');
  @override
  late final drift.GeneratedColumn<int> generalFirstup =
      drift.GeneratedColumn<int>(
        'general_firstup',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _generalLastupMeta =
      const drift.VerificationMeta('generalLastup');
  @override
  late final drift.GeneratedColumn<int> generalLastup =
      drift.GeneratedColumn<int>(
        'general_lastup',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _globalPointMeta =
      const drift.VerificationMeta('globalPoint');
  @override
  late final drift.GeneratedColumn<int> globalPoint =
      drift.GeneratedColumn<int>(
        'global_point',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _favMeta = const drift.VerificationMeta(
    'fav',
  );
  @override
  late final drift.GeneratedColumn<int> fav = drift.GeneratedColumn<int>(
    'fav',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _reviewCountMeta =
      const drift.VerificationMeta('reviewCount');
  @override
  late final drift.GeneratedColumn<int> reviewCount =
      drift.GeneratedColumn<int>(
        'review_count',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _rateCountMeta =
      const drift.VerificationMeta('rateCount');
  @override
  late final drift.GeneratedColumn<int> rateCount = drift.GeneratedColumn<int>(
    'rate_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _allPointMeta =
      const drift.VerificationMeta('allPoint');
  @override
  late final drift.GeneratedColumn<int> allPoint = drift.GeneratedColumn<int>(
    'all_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _pointCountMeta =
      const drift.VerificationMeta('pointCount');
  @override
  late final drift.GeneratedColumn<int> pointCount = drift.GeneratedColumn<int>(
    'point_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _dailyPointMeta =
      const drift.VerificationMeta('dailyPoint');
  @override
  late final drift.GeneratedColumn<int> dailyPoint = drift.GeneratedColumn<int>(
    'daily_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _weeklyPointMeta =
      const drift.VerificationMeta('weeklyPoint');
  @override
  late final drift.GeneratedColumn<int> weeklyPoint =
      drift.GeneratedColumn<int>(
        'weekly_point',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _monthlyPointMeta =
      const drift.VerificationMeta('monthlyPoint');
  @override
  late final drift.GeneratedColumn<int> monthlyPoint =
      drift.GeneratedColumn<int>(
        'monthly_point',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _quarterPointMeta =
      const drift.VerificationMeta('quarterPoint');
  @override
  late final drift.GeneratedColumn<int> quarterPoint =
      drift.GeneratedColumn<int>(
        'quarter_point',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _yearlyPointMeta =
      const drift.VerificationMeta('yearlyPoint');
  @override
  late final drift.GeneratedColumn<int> yearlyPoint =
      drift.GeneratedColumn<int>(
        'yearly_point',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _generalAllNoMeta =
      const drift.VerificationMeta('generalAllNo');
  @override
  late final drift.GeneratedColumn<int> generalAllNo =
      drift.GeneratedColumn<int>(
        'general_all_no',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _novelUpdatedAtMeta =
      const drift.VerificationMeta('novelUpdatedAt');
  @override
  late final drift.GeneratedColumn<String> novelUpdatedAt =
      drift.GeneratedColumn<String>(
        'novel_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _cachedAtMeta =
      const drift.VerificationMeta('cachedAt');
  @override
  late final drift.GeneratedColumn<int> cachedAt = drift.GeneratedColumn<int>(
    'cached_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<drift.GeneratedColumn> get $columns => [
    ncode,
    title,
    writer,
    story,
    novelType,
    end,
    genre,
    isr15,
    isbl,
    isgl,
    iszankoku,
    istensei,
    istenni,
    keyword,
    generalFirstup,
    generalLastup,
    globalPoint,
    fav,
    reviewCount,
    rateCount,
    allPoint,
    pointCount,
    dailyPoint,
    weeklyPoint,
    monthlyPoint,
    quarterPoint,
    yearlyPoint,
    generalAllNo,
    novelUpdatedAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'novels';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<Novel> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ncode')) {
      context.handle(
        _ncodeMeta,
        ncode.isAcceptableOrUnknown(data['ncode']!, _ncodeMeta),
      );
    } else if (isInserting) {
      context.missing(_ncodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('writer')) {
      context.handle(
        _writerMeta,
        writer.isAcceptableOrUnknown(data['writer']!, _writerMeta),
      );
    }
    if (data.containsKey('story')) {
      context.handle(
        _storyMeta,
        story.isAcceptableOrUnknown(data['story']!, _storyMeta),
      );
    }
    if (data.containsKey('novel_type')) {
      context.handle(
        _novelTypeMeta,
        novelType.isAcceptableOrUnknown(data['novel_type']!, _novelTypeMeta),
      );
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('isr15')) {
      context.handle(
        _isr15Meta,
        isr15.isAcceptableOrUnknown(data['isr15']!, _isr15Meta),
      );
    }
    if (data.containsKey('isbl')) {
      context.handle(
        _isblMeta,
        isbl.isAcceptableOrUnknown(data['isbl']!, _isblMeta),
      );
    }
    if (data.containsKey('isgl')) {
      context.handle(
        _isglMeta,
        isgl.isAcceptableOrUnknown(data['isgl']!, _isglMeta),
      );
    }
    if (data.containsKey('iszankoku')) {
      context.handle(
        _iszankokuMeta,
        iszankoku.isAcceptableOrUnknown(data['iszankoku']!, _iszankokuMeta),
      );
    }
    if (data.containsKey('istensei')) {
      context.handle(
        _istenseiMeta,
        istensei.isAcceptableOrUnknown(data['istensei']!, _istenseiMeta),
      );
    }
    if (data.containsKey('istenni')) {
      context.handle(
        _istenniMeta,
        istenni.isAcceptableOrUnknown(data['istenni']!, _istenniMeta),
      );
    }
    if (data.containsKey('keyword')) {
      context.handle(
        _keywordMeta,
        keyword.isAcceptableOrUnknown(data['keyword']!, _keywordMeta),
      );
    }
    if (data.containsKey('general_firstup')) {
      context.handle(
        _generalFirstupMeta,
        generalFirstup.isAcceptableOrUnknown(
          data['general_firstup']!,
          _generalFirstupMeta,
        ),
      );
    }
    if (data.containsKey('general_lastup')) {
      context.handle(
        _generalLastupMeta,
        generalLastup.isAcceptableOrUnknown(
          data['general_lastup']!,
          _generalLastupMeta,
        ),
      );
    }
    if (data.containsKey('global_point')) {
      context.handle(
        _globalPointMeta,
        globalPoint.isAcceptableOrUnknown(
          data['global_point']!,
          _globalPointMeta,
        ),
      );
    }
    if (data.containsKey('fav')) {
      context.handle(
        _favMeta,
        fav.isAcceptableOrUnknown(data['fav']!, _favMeta),
      );
    }
    if (data.containsKey('review_count')) {
      context.handle(
        _reviewCountMeta,
        reviewCount.isAcceptableOrUnknown(
          data['review_count']!,
          _reviewCountMeta,
        ),
      );
    }
    if (data.containsKey('rate_count')) {
      context.handle(
        _rateCountMeta,
        rateCount.isAcceptableOrUnknown(data['rate_count']!, _rateCountMeta),
      );
    }
    if (data.containsKey('all_point')) {
      context.handle(
        _allPointMeta,
        allPoint.isAcceptableOrUnknown(data['all_point']!, _allPointMeta),
      );
    }
    if (data.containsKey('point_count')) {
      context.handle(
        _pointCountMeta,
        pointCount.isAcceptableOrUnknown(data['point_count']!, _pointCountMeta),
      );
    }
    if (data.containsKey('daily_point')) {
      context.handle(
        _dailyPointMeta,
        dailyPoint.isAcceptableOrUnknown(data['daily_point']!, _dailyPointMeta),
      );
    }
    if (data.containsKey('weekly_point')) {
      context.handle(
        _weeklyPointMeta,
        weeklyPoint.isAcceptableOrUnknown(
          data['weekly_point']!,
          _weeklyPointMeta,
        ),
      );
    }
    if (data.containsKey('monthly_point')) {
      context.handle(
        _monthlyPointMeta,
        monthlyPoint.isAcceptableOrUnknown(
          data['monthly_point']!,
          _monthlyPointMeta,
        ),
      );
    }
    if (data.containsKey('quarter_point')) {
      context.handle(
        _quarterPointMeta,
        quarterPoint.isAcceptableOrUnknown(
          data['quarter_point']!,
          _quarterPointMeta,
        ),
      );
    }
    if (data.containsKey('yearly_point')) {
      context.handle(
        _yearlyPointMeta,
        yearlyPoint.isAcceptableOrUnknown(
          data['yearly_point']!,
          _yearlyPointMeta,
        ),
      );
    }
    if (data.containsKey('general_all_no')) {
      context.handle(
        _generalAllNoMeta,
        generalAllNo.isAcceptableOrUnknown(
          data['general_all_no']!,
          _generalAllNoMeta,
        ),
      );
    }
    if (data.containsKey('novel_updated_at')) {
      context.handle(
        _novelUpdatedAtMeta,
        novelUpdatedAt.isAcceptableOrUnknown(
          data['novel_updated_at']!,
          _novelUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {ncode};
  @override
  Novel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Novel(
      ncode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ncode'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      writer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}writer'],
      ),
      story: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story'],
      ),
      novelType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}novel_type'],
      ),
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}genre'],
      ),
      isr15: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isr15'],
      ),
      isbl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isbl'],
      ),
      isgl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isgl'],
      ),
      iszankoku: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}iszankoku'],
      ),
      istensei: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}istensei'],
      ),
      istenni: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}istenni'],
      ),
      keyword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyword'],
      ),
      generalFirstup: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}general_firstup'],
      ),
      generalLastup: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}general_lastup'],
      ),
      globalPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}global_point'],
      ),
      fav: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fav'],
      ),
      reviewCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_count'],
      ),
      rateCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rate_count'],
      ),
      allPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}all_point'],
      ),
      pointCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}point_count'],
      ),
      dailyPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_point'],
      ),
      weeklyPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_point'],
      ),
      monthlyPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_point'],
      ),
      quarterPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quarter_point'],
      ),
      yearlyPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}yearly_point'],
      ),
      generalAllNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}general_all_no'],
      ),
      novelUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}novel_updated_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cached_at'],
      ),
    );
  }

  @override
  $NovelsTable createAlias(String alias) {
    return $NovelsTable(attachedDatabase, alias);
  }
}

class Novel extends drift.DataClass implements drift.Insertable<Novel> {
  /// 小説のncode
  final String ncode;

  /// 小説のタイトル
  final String? title;

  /// 小説の著者
  final String? writer;

  /// 小説のあらすじ
  final String? story;

  /// 小説の種別
  /// 0: 短編 1: 連載中
  final int? novelType;

  /// 小説の状態
  /// 0: 短編 or 完結済 1: 連載中
  final int? end;

  /// ジャンル
  final int? genre;

  /// 作品に含まれる要素に「R15」が含まれる場合は1、それ以外は0
  final int? isr15;

  /// 作品に含まれる要素に「ボーイズラブ」が含まれる場合は1、それ以外は0
  final int? isbl;

  /// 作品に含まれる要素に「ガールズラブ」が含まれる場合は1、それ以外は0
  final int? isgl;

  /// 作品に含まれる要素に「残酷な描写あり」が含まれる場合は1、それ以外は0
  final int? iszankoku;

  /// 作品に含まれる要素に「異世界転生」が含まれる場合は1、それ以外は0
  final int? istensei;

  /// 作品に含まれる要素に「異世界転移」が含まれる場合は1、それ以外は0
  final int? istenni;

  /// キーワード
  final String? keyword;

  /// 初回掲載日 YYYY-MM-DD HH:MM:SS
  final int? generalFirstup;

  /// 最終掲載日 YYYY-MM-DD HH:MM:SS
  final int? generalLastup;

  /// 総合評価ポイント (ブックマーク数×2)+評価ポイントで算出
  final int? globalPoint;

  /// Noveltyのライブラリに登録されているかどうか
  /// 1: 登録済み、0: 未登録
  /// DEPRECATED: LibraryEntriesテーブルを使用するため、このカラムは使用しない
  final int? fav;

  /// レビュー数
  final int? reviewCount;

  /// レビューの平均評価(?)
  final int? rateCount;

  /// 評価ポイント
  final int? allPoint;

  /// ポイント数(何の用途か不明)
  final int? pointCount;

  /// 日間ポイント
  final int? dailyPoint;

  /// 週間ポイント
  final int? weeklyPoint;

  /// 月間ポイント
  final int? monthlyPoint;

  /// 四半期ポイント
  final int? quarterPoint;

  /// 年間ポイント
  final int? yearlyPoint;

  /// 連載小説のエピソード数 短編は常に1
  final int? generalAllNo;

  /// 作品の更新日時
  final String? novelUpdatedAt;

  /// キャッシュ日時(?)
  final int? cachedAt;
  const Novel({
    required this.ncode,
    this.title,
    this.writer,
    this.story,
    this.novelType,
    this.end,
    this.genre,
    this.isr15,
    this.isbl,
    this.isgl,
    this.iszankoku,
    this.istensei,
    this.istenni,
    this.keyword,
    this.generalFirstup,
    this.generalLastup,
    this.globalPoint,
    this.fav,
    this.reviewCount,
    this.rateCount,
    this.allPoint,
    this.pointCount,
    this.dailyPoint,
    this.weeklyPoint,
    this.monthlyPoint,
    this.quarterPoint,
    this.yearlyPoint,
    this.generalAllNo,
    this.novelUpdatedAt,
    this.cachedAt,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['ncode'] = drift.Variable<String>(ncode);
    if (!nullToAbsent || title != null) {
      map['title'] = drift.Variable<String>(title);
    }
    if (!nullToAbsent || writer != null) {
      map['writer'] = drift.Variable<String>(writer);
    }
    if (!nullToAbsent || story != null) {
      map['story'] = drift.Variable<String>(story);
    }
    if (!nullToAbsent || novelType != null) {
      map['novel_type'] = drift.Variable<int>(novelType);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = drift.Variable<int>(end);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = drift.Variable<int>(genre);
    }
    if (!nullToAbsent || isr15 != null) {
      map['isr15'] = drift.Variable<int>(isr15);
    }
    if (!nullToAbsent || isbl != null) {
      map['isbl'] = drift.Variable<int>(isbl);
    }
    if (!nullToAbsent || isgl != null) {
      map['isgl'] = drift.Variable<int>(isgl);
    }
    if (!nullToAbsent || iszankoku != null) {
      map['iszankoku'] = drift.Variable<int>(iszankoku);
    }
    if (!nullToAbsent || istensei != null) {
      map['istensei'] = drift.Variable<int>(istensei);
    }
    if (!nullToAbsent || istenni != null) {
      map['istenni'] = drift.Variable<int>(istenni);
    }
    if (!nullToAbsent || keyword != null) {
      map['keyword'] = drift.Variable<String>(keyword);
    }
    if (!nullToAbsent || generalFirstup != null) {
      map['general_firstup'] = drift.Variable<int>(generalFirstup);
    }
    if (!nullToAbsent || generalLastup != null) {
      map['general_lastup'] = drift.Variable<int>(generalLastup);
    }
    if (!nullToAbsent || globalPoint != null) {
      map['global_point'] = drift.Variable<int>(globalPoint);
    }
    if (!nullToAbsent || fav != null) {
      map['fav'] = drift.Variable<int>(fav);
    }
    if (!nullToAbsent || reviewCount != null) {
      map['review_count'] = drift.Variable<int>(reviewCount);
    }
    if (!nullToAbsent || rateCount != null) {
      map['rate_count'] = drift.Variable<int>(rateCount);
    }
    if (!nullToAbsent || allPoint != null) {
      map['all_point'] = drift.Variable<int>(allPoint);
    }
    if (!nullToAbsent || pointCount != null) {
      map['point_count'] = drift.Variable<int>(pointCount);
    }
    if (!nullToAbsent || dailyPoint != null) {
      map['daily_point'] = drift.Variable<int>(dailyPoint);
    }
    if (!nullToAbsent || weeklyPoint != null) {
      map['weekly_point'] = drift.Variable<int>(weeklyPoint);
    }
    if (!nullToAbsent || monthlyPoint != null) {
      map['monthly_point'] = drift.Variable<int>(monthlyPoint);
    }
    if (!nullToAbsent || quarterPoint != null) {
      map['quarter_point'] = drift.Variable<int>(quarterPoint);
    }
    if (!nullToAbsent || yearlyPoint != null) {
      map['yearly_point'] = drift.Variable<int>(yearlyPoint);
    }
    if (!nullToAbsent || generalAllNo != null) {
      map['general_all_no'] = drift.Variable<int>(generalAllNo);
    }
    if (!nullToAbsent || novelUpdatedAt != null) {
      map['novel_updated_at'] = drift.Variable<String>(novelUpdatedAt);
    }
    if (!nullToAbsent || cachedAt != null) {
      map['cached_at'] = drift.Variable<int>(cachedAt);
    }
    return map;
  }

  NovelsCompanion toCompanion(bool nullToAbsent) {
    return NovelsCompanion(
      ncode: drift.Value(ncode),
      title: title == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(title),
      writer: writer == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(writer),
      story: story == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(story),
      novelType: novelType == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(novelType),
      end: end == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(end),
      genre: genre == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(genre),
      isr15: isr15 == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(isr15),
      isbl: isbl == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(isbl),
      isgl: isgl == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(isgl),
      iszankoku: iszankoku == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(iszankoku),
      istensei: istensei == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(istensei),
      istenni: istenni == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(istenni),
      keyword: keyword == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(keyword),
      generalFirstup: generalFirstup == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(generalFirstup),
      generalLastup: generalLastup == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(generalLastup),
      globalPoint: globalPoint == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(globalPoint),
      fav: fav == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(fav),
      reviewCount: reviewCount == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(reviewCount),
      rateCount: rateCount == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(rateCount),
      allPoint: allPoint == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(allPoint),
      pointCount: pointCount == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(pointCount),
      dailyPoint: dailyPoint == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(dailyPoint),
      weeklyPoint: weeklyPoint == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(weeklyPoint),
      monthlyPoint: monthlyPoint == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(monthlyPoint),
      quarterPoint: quarterPoint == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(quarterPoint),
      yearlyPoint: yearlyPoint == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(yearlyPoint),
      generalAllNo: generalAllNo == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(generalAllNo),
      novelUpdatedAt: novelUpdatedAt == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(novelUpdatedAt),
      cachedAt: cachedAt == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(cachedAt),
    );
  }

  factory Novel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return Novel(
      ncode: serializer.fromJson<String>(json['ncode']),
      title: serializer.fromJson<String?>(json['title']),
      writer: serializer.fromJson<String?>(json['writer']),
      story: serializer.fromJson<String?>(json['story']),
      novelType: serializer.fromJson<int?>(json['novelType']),
      end: serializer.fromJson<int?>(json['end']),
      genre: serializer.fromJson<int?>(json['genre']),
      isr15: serializer.fromJson<int?>(json['isr15']),
      isbl: serializer.fromJson<int?>(json['isbl']),
      isgl: serializer.fromJson<int?>(json['isgl']),
      iszankoku: serializer.fromJson<int?>(json['iszankoku']),
      istensei: serializer.fromJson<int?>(json['istensei']),
      istenni: serializer.fromJson<int?>(json['istenni']),
      keyword: serializer.fromJson<String?>(json['keyword']),
      generalFirstup: serializer.fromJson<int?>(json['generalFirstup']),
      generalLastup: serializer.fromJson<int?>(json['generalLastup']),
      globalPoint: serializer.fromJson<int?>(json['globalPoint']),
      fav: serializer.fromJson<int?>(json['fav']),
      reviewCount: serializer.fromJson<int?>(json['reviewCount']),
      rateCount: serializer.fromJson<int?>(json['rateCount']),
      allPoint: serializer.fromJson<int?>(json['allPoint']),
      pointCount: serializer.fromJson<int?>(json['pointCount']),
      dailyPoint: serializer.fromJson<int?>(json['dailyPoint']),
      weeklyPoint: serializer.fromJson<int?>(json['weeklyPoint']),
      monthlyPoint: serializer.fromJson<int?>(json['monthlyPoint']),
      quarterPoint: serializer.fromJson<int?>(json['quarterPoint']),
      yearlyPoint: serializer.fromJson<int?>(json['yearlyPoint']),
      generalAllNo: serializer.fromJson<int?>(json['generalAllNo']),
      novelUpdatedAt: serializer.fromJson<String?>(json['novelUpdatedAt']),
      cachedAt: serializer.fromJson<int?>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'title': serializer.toJson<String?>(title),
      'writer': serializer.toJson<String?>(writer),
      'story': serializer.toJson<String?>(story),
      'novelType': serializer.toJson<int?>(novelType),
      'end': serializer.toJson<int?>(end),
      'genre': serializer.toJson<int?>(genre),
      'isr15': serializer.toJson<int?>(isr15),
      'isbl': serializer.toJson<int?>(isbl),
      'isgl': serializer.toJson<int?>(isgl),
      'iszankoku': serializer.toJson<int?>(iszankoku),
      'istensei': serializer.toJson<int?>(istensei),
      'istenni': serializer.toJson<int?>(istenni),
      'keyword': serializer.toJson<String?>(keyword),
      'generalFirstup': serializer.toJson<int?>(generalFirstup),
      'generalLastup': serializer.toJson<int?>(generalLastup),
      'globalPoint': serializer.toJson<int?>(globalPoint),
      'fav': serializer.toJson<int?>(fav),
      'reviewCount': serializer.toJson<int?>(reviewCount),
      'rateCount': serializer.toJson<int?>(rateCount),
      'allPoint': serializer.toJson<int?>(allPoint),
      'pointCount': serializer.toJson<int?>(pointCount),
      'dailyPoint': serializer.toJson<int?>(dailyPoint),
      'weeklyPoint': serializer.toJson<int?>(weeklyPoint),
      'monthlyPoint': serializer.toJson<int?>(monthlyPoint),
      'quarterPoint': serializer.toJson<int?>(quarterPoint),
      'yearlyPoint': serializer.toJson<int?>(yearlyPoint),
      'generalAllNo': serializer.toJson<int?>(generalAllNo),
      'novelUpdatedAt': serializer.toJson<String?>(novelUpdatedAt),
      'cachedAt': serializer.toJson<int?>(cachedAt),
    };
  }

  Novel copyWith({
    String? ncode,
    drift.Value<String?> title = const drift.Value.absent(),
    drift.Value<String?> writer = const drift.Value.absent(),
    drift.Value<String?> story = const drift.Value.absent(),
    drift.Value<int?> novelType = const drift.Value.absent(),
    drift.Value<int?> end = const drift.Value.absent(),
    drift.Value<int?> genre = const drift.Value.absent(),
    drift.Value<int?> isr15 = const drift.Value.absent(),
    drift.Value<int?> isbl = const drift.Value.absent(),
    drift.Value<int?> isgl = const drift.Value.absent(),
    drift.Value<int?> iszankoku = const drift.Value.absent(),
    drift.Value<int?> istensei = const drift.Value.absent(),
    drift.Value<int?> istenni = const drift.Value.absent(),
    drift.Value<String?> keyword = const drift.Value.absent(),
    drift.Value<int?> generalFirstup = const drift.Value.absent(),
    drift.Value<int?> generalLastup = const drift.Value.absent(),
    drift.Value<int?> globalPoint = const drift.Value.absent(),
    drift.Value<int?> fav = const drift.Value.absent(),
    drift.Value<int?> reviewCount = const drift.Value.absent(),
    drift.Value<int?> rateCount = const drift.Value.absent(),
    drift.Value<int?> allPoint = const drift.Value.absent(),
    drift.Value<int?> pointCount = const drift.Value.absent(),
    drift.Value<int?> dailyPoint = const drift.Value.absent(),
    drift.Value<int?> weeklyPoint = const drift.Value.absent(),
    drift.Value<int?> monthlyPoint = const drift.Value.absent(),
    drift.Value<int?> quarterPoint = const drift.Value.absent(),
    drift.Value<int?> yearlyPoint = const drift.Value.absent(),
    drift.Value<int?> generalAllNo = const drift.Value.absent(),
    drift.Value<String?> novelUpdatedAt = const drift.Value.absent(),
    drift.Value<int?> cachedAt = const drift.Value.absent(),
  }) => Novel(
    ncode: ncode ?? this.ncode,
    title: title.present ? title.value : this.title,
    writer: writer.present ? writer.value : this.writer,
    story: story.present ? story.value : this.story,
    novelType: novelType.present ? novelType.value : this.novelType,
    end: end.present ? end.value : this.end,
    genre: genre.present ? genre.value : this.genre,
    isr15: isr15.present ? isr15.value : this.isr15,
    isbl: isbl.present ? isbl.value : this.isbl,
    isgl: isgl.present ? isgl.value : this.isgl,
    iszankoku: iszankoku.present ? iszankoku.value : this.iszankoku,
    istensei: istensei.present ? istensei.value : this.istensei,
    istenni: istenni.present ? istenni.value : this.istenni,
    keyword: keyword.present ? keyword.value : this.keyword,
    generalFirstup: generalFirstup.present
        ? generalFirstup.value
        : this.generalFirstup,
    generalLastup: generalLastup.present
        ? generalLastup.value
        : this.generalLastup,
    globalPoint: globalPoint.present ? globalPoint.value : this.globalPoint,
    fav: fav.present ? fav.value : this.fav,
    reviewCount: reviewCount.present ? reviewCount.value : this.reviewCount,
    rateCount: rateCount.present ? rateCount.value : this.rateCount,
    allPoint: allPoint.present ? allPoint.value : this.allPoint,
    pointCount: pointCount.present ? pointCount.value : this.pointCount,
    dailyPoint: dailyPoint.present ? dailyPoint.value : this.dailyPoint,
    weeklyPoint: weeklyPoint.present ? weeklyPoint.value : this.weeklyPoint,
    monthlyPoint: monthlyPoint.present ? monthlyPoint.value : this.monthlyPoint,
    quarterPoint: quarterPoint.present ? quarterPoint.value : this.quarterPoint,
    yearlyPoint: yearlyPoint.present ? yearlyPoint.value : this.yearlyPoint,
    generalAllNo: generalAllNo.present ? generalAllNo.value : this.generalAllNo,
    novelUpdatedAt: novelUpdatedAt.present
        ? novelUpdatedAt.value
        : this.novelUpdatedAt,
    cachedAt: cachedAt.present ? cachedAt.value : this.cachedAt,
  );
  Novel copyWithCompanion(NovelsCompanion data) {
    return Novel(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      title: data.title.present ? data.title.value : this.title,
      writer: data.writer.present ? data.writer.value : this.writer,
      story: data.story.present ? data.story.value : this.story,
      novelType: data.novelType.present ? data.novelType.value : this.novelType,
      end: data.end.present ? data.end.value : this.end,
      genre: data.genre.present ? data.genre.value : this.genre,
      isr15: data.isr15.present ? data.isr15.value : this.isr15,
      isbl: data.isbl.present ? data.isbl.value : this.isbl,
      isgl: data.isgl.present ? data.isgl.value : this.isgl,
      iszankoku: data.iszankoku.present ? data.iszankoku.value : this.iszankoku,
      istensei: data.istensei.present ? data.istensei.value : this.istensei,
      istenni: data.istenni.present ? data.istenni.value : this.istenni,
      keyword: data.keyword.present ? data.keyword.value : this.keyword,
      generalFirstup: data.generalFirstup.present
          ? data.generalFirstup.value
          : this.generalFirstup,
      generalLastup: data.generalLastup.present
          ? data.generalLastup.value
          : this.generalLastup,
      globalPoint: data.globalPoint.present
          ? data.globalPoint.value
          : this.globalPoint,
      fav: data.fav.present ? data.fav.value : this.fav,
      reviewCount: data.reviewCount.present
          ? data.reviewCount.value
          : this.reviewCount,
      rateCount: data.rateCount.present ? data.rateCount.value : this.rateCount,
      allPoint: data.allPoint.present ? data.allPoint.value : this.allPoint,
      pointCount: data.pointCount.present
          ? data.pointCount.value
          : this.pointCount,
      dailyPoint: data.dailyPoint.present
          ? data.dailyPoint.value
          : this.dailyPoint,
      weeklyPoint: data.weeklyPoint.present
          ? data.weeklyPoint.value
          : this.weeklyPoint,
      monthlyPoint: data.monthlyPoint.present
          ? data.monthlyPoint.value
          : this.monthlyPoint,
      quarterPoint: data.quarterPoint.present
          ? data.quarterPoint.value
          : this.quarterPoint,
      yearlyPoint: data.yearlyPoint.present
          ? data.yearlyPoint.value
          : this.yearlyPoint,
      generalAllNo: data.generalAllNo.present
          ? data.generalAllNo.value
          : this.generalAllNo,
      novelUpdatedAt: data.novelUpdatedAt.present
          ? data.novelUpdatedAt.value
          : this.novelUpdatedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Novel(')
          ..write('ncode: $ncode, ')
          ..write('title: $title, ')
          ..write('writer: $writer, ')
          ..write('story: $story, ')
          ..write('novelType: $novelType, ')
          ..write('end: $end, ')
          ..write('genre: $genre, ')
          ..write('isr15: $isr15, ')
          ..write('isbl: $isbl, ')
          ..write('isgl: $isgl, ')
          ..write('iszankoku: $iszankoku, ')
          ..write('istensei: $istensei, ')
          ..write('istenni: $istenni, ')
          ..write('keyword: $keyword, ')
          ..write('generalFirstup: $generalFirstup, ')
          ..write('generalLastup: $generalLastup, ')
          ..write('globalPoint: $globalPoint, ')
          ..write('fav: $fav, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('rateCount: $rateCount, ')
          ..write('allPoint: $allPoint, ')
          ..write('pointCount: $pointCount, ')
          ..write('dailyPoint: $dailyPoint, ')
          ..write('weeklyPoint: $weeklyPoint, ')
          ..write('monthlyPoint: $monthlyPoint, ')
          ..write('quarterPoint: $quarterPoint, ')
          ..write('yearlyPoint: $yearlyPoint, ')
          ..write('generalAllNo: $generalAllNo, ')
          ..write('novelUpdatedAt: $novelUpdatedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    ncode,
    title,
    writer,
    story,
    novelType,
    end,
    genre,
    isr15,
    isbl,
    isgl,
    iszankoku,
    istensei,
    istenni,
    keyword,
    generalFirstup,
    generalLastup,
    globalPoint,
    fav,
    reviewCount,
    rateCount,
    allPoint,
    pointCount,
    dailyPoint,
    weeklyPoint,
    monthlyPoint,
    quarterPoint,
    yearlyPoint,
    generalAllNo,
    novelUpdatedAt,
    cachedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Novel &&
          other.ncode == this.ncode &&
          other.title == this.title &&
          other.writer == this.writer &&
          other.story == this.story &&
          other.novelType == this.novelType &&
          other.end == this.end &&
          other.genre == this.genre &&
          other.isr15 == this.isr15 &&
          other.isbl == this.isbl &&
          other.isgl == this.isgl &&
          other.iszankoku == this.iszankoku &&
          other.istensei == this.istensei &&
          other.istenni == this.istenni &&
          other.keyword == this.keyword &&
          other.generalFirstup == this.generalFirstup &&
          other.generalLastup == this.generalLastup &&
          other.globalPoint == this.globalPoint &&
          other.fav == this.fav &&
          other.reviewCount == this.reviewCount &&
          other.rateCount == this.rateCount &&
          other.allPoint == this.allPoint &&
          other.pointCount == this.pointCount &&
          other.dailyPoint == this.dailyPoint &&
          other.weeklyPoint == this.weeklyPoint &&
          other.monthlyPoint == this.monthlyPoint &&
          other.quarterPoint == this.quarterPoint &&
          other.yearlyPoint == this.yearlyPoint &&
          other.generalAllNo == this.generalAllNo &&
          other.novelUpdatedAt == this.novelUpdatedAt &&
          other.cachedAt == this.cachedAt);
}

class NovelsCompanion extends drift.UpdateCompanion<Novel> {
  final drift.Value<String> ncode;
  final drift.Value<String?> title;
  final drift.Value<String?> writer;
  final drift.Value<String?> story;
  final drift.Value<int?> novelType;
  final drift.Value<int?> end;
  final drift.Value<int?> genre;
  final drift.Value<int?> isr15;
  final drift.Value<int?> isbl;
  final drift.Value<int?> isgl;
  final drift.Value<int?> iszankoku;
  final drift.Value<int?> istensei;
  final drift.Value<int?> istenni;
  final drift.Value<String?> keyword;
  final drift.Value<int?> generalFirstup;
  final drift.Value<int?> generalLastup;
  final drift.Value<int?> globalPoint;
  final drift.Value<int?> fav;
  final drift.Value<int?> reviewCount;
  final drift.Value<int?> rateCount;
  final drift.Value<int?> allPoint;
  final drift.Value<int?> pointCount;
  final drift.Value<int?> dailyPoint;
  final drift.Value<int?> weeklyPoint;
  final drift.Value<int?> monthlyPoint;
  final drift.Value<int?> quarterPoint;
  final drift.Value<int?> yearlyPoint;
  final drift.Value<int?> generalAllNo;
  final drift.Value<String?> novelUpdatedAt;
  final drift.Value<int?> cachedAt;
  final drift.Value<int> rowid;
  const NovelsCompanion({
    this.ncode = const drift.Value.absent(),
    this.title = const drift.Value.absent(),
    this.writer = const drift.Value.absent(),
    this.story = const drift.Value.absent(),
    this.novelType = const drift.Value.absent(),
    this.end = const drift.Value.absent(),
    this.genre = const drift.Value.absent(),
    this.isr15 = const drift.Value.absent(),
    this.isbl = const drift.Value.absent(),
    this.isgl = const drift.Value.absent(),
    this.iszankoku = const drift.Value.absent(),
    this.istensei = const drift.Value.absent(),
    this.istenni = const drift.Value.absent(),
    this.keyword = const drift.Value.absent(),
    this.generalFirstup = const drift.Value.absent(),
    this.generalLastup = const drift.Value.absent(),
    this.globalPoint = const drift.Value.absent(),
    this.fav = const drift.Value.absent(),
    this.reviewCount = const drift.Value.absent(),
    this.rateCount = const drift.Value.absent(),
    this.allPoint = const drift.Value.absent(),
    this.pointCount = const drift.Value.absent(),
    this.dailyPoint = const drift.Value.absent(),
    this.weeklyPoint = const drift.Value.absent(),
    this.monthlyPoint = const drift.Value.absent(),
    this.quarterPoint = const drift.Value.absent(),
    this.yearlyPoint = const drift.Value.absent(),
    this.generalAllNo = const drift.Value.absent(),
    this.novelUpdatedAt = const drift.Value.absent(),
    this.cachedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  NovelsCompanion.insert({
    required String ncode,
    this.title = const drift.Value.absent(),
    this.writer = const drift.Value.absent(),
    this.story = const drift.Value.absent(),
    this.novelType = const drift.Value.absent(),
    this.end = const drift.Value.absent(),
    this.genre = const drift.Value.absent(),
    this.isr15 = const drift.Value.absent(),
    this.isbl = const drift.Value.absent(),
    this.isgl = const drift.Value.absent(),
    this.iszankoku = const drift.Value.absent(),
    this.istensei = const drift.Value.absent(),
    this.istenni = const drift.Value.absent(),
    this.keyword = const drift.Value.absent(),
    this.generalFirstup = const drift.Value.absent(),
    this.generalLastup = const drift.Value.absent(),
    this.globalPoint = const drift.Value.absent(),
    this.fav = const drift.Value.absent(),
    this.reviewCount = const drift.Value.absent(),
    this.rateCount = const drift.Value.absent(),
    this.allPoint = const drift.Value.absent(),
    this.pointCount = const drift.Value.absent(),
    this.dailyPoint = const drift.Value.absent(),
    this.weeklyPoint = const drift.Value.absent(),
    this.monthlyPoint = const drift.Value.absent(),
    this.quarterPoint = const drift.Value.absent(),
    this.yearlyPoint = const drift.Value.absent(),
    this.generalAllNo = const drift.Value.absent(),
    this.novelUpdatedAt = const drift.Value.absent(),
    this.cachedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode);
  static drift.Insertable<Novel> custom({
    drift.Expression<String>? ncode,
    drift.Expression<String>? title,
    drift.Expression<String>? writer,
    drift.Expression<String>? story,
    drift.Expression<int>? novelType,
    drift.Expression<int>? end,
    drift.Expression<int>? genre,
    drift.Expression<int>? isr15,
    drift.Expression<int>? isbl,
    drift.Expression<int>? isgl,
    drift.Expression<int>? iszankoku,
    drift.Expression<int>? istensei,
    drift.Expression<int>? istenni,
    drift.Expression<String>? keyword,
    drift.Expression<int>? generalFirstup,
    drift.Expression<int>? generalLastup,
    drift.Expression<int>? globalPoint,
    drift.Expression<int>? fav,
    drift.Expression<int>? reviewCount,
    drift.Expression<int>? rateCount,
    drift.Expression<int>? allPoint,
    drift.Expression<int>? pointCount,
    drift.Expression<int>? dailyPoint,
    drift.Expression<int>? weeklyPoint,
    drift.Expression<int>? monthlyPoint,
    drift.Expression<int>? quarterPoint,
    drift.Expression<int>? yearlyPoint,
    drift.Expression<int>? generalAllNo,
    drift.Expression<String>? novelUpdatedAt,
    drift.Expression<int>? cachedAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (title != null) 'title': title,
      if (writer != null) 'writer': writer,
      if (story != null) 'story': story,
      if (novelType != null) 'novel_type': novelType,
      if (end != null) 'end': end,
      if (genre != null) 'genre': genre,
      if (isr15 != null) 'isr15': isr15,
      if (isbl != null) 'isbl': isbl,
      if (isgl != null) 'isgl': isgl,
      if (iszankoku != null) 'iszankoku': iszankoku,
      if (istensei != null) 'istensei': istensei,
      if (istenni != null) 'istenni': istenni,
      if (keyword != null) 'keyword': keyword,
      if (generalFirstup != null) 'general_firstup': generalFirstup,
      if (generalLastup != null) 'general_lastup': generalLastup,
      if (globalPoint != null) 'global_point': globalPoint,
      if (fav != null) 'fav': fav,
      if (reviewCount != null) 'review_count': reviewCount,
      if (rateCount != null) 'rate_count': rateCount,
      if (allPoint != null) 'all_point': allPoint,
      if (pointCount != null) 'point_count': pointCount,
      if (dailyPoint != null) 'daily_point': dailyPoint,
      if (weeklyPoint != null) 'weekly_point': weeklyPoint,
      if (monthlyPoint != null) 'monthly_point': monthlyPoint,
      if (quarterPoint != null) 'quarter_point': quarterPoint,
      if (yearlyPoint != null) 'yearly_point': yearlyPoint,
      if (generalAllNo != null) 'general_all_no': generalAllNo,
      if (novelUpdatedAt != null) 'novel_updated_at': novelUpdatedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NovelsCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<String?>? title,
    drift.Value<String?>? writer,
    drift.Value<String?>? story,
    drift.Value<int?>? novelType,
    drift.Value<int?>? end,
    drift.Value<int?>? genre,
    drift.Value<int?>? isr15,
    drift.Value<int?>? isbl,
    drift.Value<int?>? isgl,
    drift.Value<int?>? iszankoku,
    drift.Value<int?>? istensei,
    drift.Value<int?>? istenni,
    drift.Value<String?>? keyword,
    drift.Value<int?>? generalFirstup,
    drift.Value<int?>? generalLastup,
    drift.Value<int?>? globalPoint,
    drift.Value<int?>? fav,
    drift.Value<int?>? reviewCount,
    drift.Value<int?>? rateCount,
    drift.Value<int?>? allPoint,
    drift.Value<int?>? pointCount,
    drift.Value<int?>? dailyPoint,
    drift.Value<int?>? weeklyPoint,
    drift.Value<int?>? monthlyPoint,
    drift.Value<int?>? quarterPoint,
    drift.Value<int?>? yearlyPoint,
    drift.Value<int?>? generalAllNo,
    drift.Value<String?>? novelUpdatedAt,
    drift.Value<int?>? cachedAt,
    drift.Value<int>? rowid,
  }) {
    return NovelsCompanion(
      ncode: ncode ?? this.ncode,
      title: title ?? this.title,
      writer: writer ?? this.writer,
      story: story ?? this.story,
      novelType: novelType ?? this.novelType,
      end: end ?? this.end,
      genre: genre ?? this.genre,
      isr15: isr15 ?? this.isr15,
      isbl: isbl ?? this.isbl,
      isgl: isgl ?? this.isgl,
      iszankoku: iszankoku ?? this.iszankoku,
      istensei: istensei ?? this.istensei,
      istenni: istenni ?? this.istenni,
      keyword: keyword ?? this.keyword,
      generalFirstup: generalFirstup ?? this.generalFirstup,
      generalLastup: generalLastup ?? this.generalLastup,
      globalPoint: globalPoint ?? this.globalPoint,
      fav: fav ?? this.fav,
      reviewCount: reviewCount ?? this.reviewCount,
      rateCount: rateCount ?? this.rateCount,
      allPoint: allPoint ?? this.allPoint,
      pointCount: pointCount ?? this.pointCount,
      dailyPoint: dailyPoint ?? this.dailyPoint,
      weeklyPoint: weeklyPoint ?? this.weeklyPoint,
      monthlyPoint: monthlyPoint ?? this.monthlyPoint,
      quarterPoint: quarterPoint ?? this.quarterPoint,
      yearlyPoint: yearlyPoint ?? this.yearlyPoint,
      generalAllNo: generalAllNo ?? this.generalAllNo,
      novelUpdatedAt: novelUpdatedAt ?? this.novelUpdatedAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (ncode.present) {
      map['ncode'] = drift.Variable<String>(ncode.value);
    }
    if (title.present) {
      map['title'] = drift.Variable<String>(title.value);
    }
    if (writer.present) {
      map['writer'] = drift.Variable<String>(writer.value);
    }
    if (story.present) {
      map['story'] = drift.Variable<String>(story.value);
    }
    if (novelType.present) {
      map['novel_type'] = drift.Variable<int>(novelType.value);
    }
    if (end.present) {
      map['end'] = drift.Variable<int>(end.value);
    }
    if (genre.present) {
      map['genre'] = drift.Variable<int>(genre.value);
    }
    if (isr15.present) {
      map['isr15'] = drift.Variable<int>(isr15.value);
    }
    if (isbl.present) {
      map['isbl'] = drift.Variable<int>(isbl.value);
    }
    if (isgl.present) {
      map['isgl'] = drift.Variable<int>(isgl.value);
    }
    if (iszankoku.present) {
      map['iszankoku'] = drift.Variable<int>(iszankoku.value);
    }
    if (istensei.present) {
      map['istensei'] = drift.Variable<int>(istensei.value);
    }
    if (istenni.present) {
      map['istenni'] = drift.Variable<int>(istenni.value);
    }
    if (keyword.present) {
      map['keyword'] = drift.Variable<String>(keyword.value);
    }
    if (generalFirstup.present) {
      map['general_firstup'] = drift.Variable<int>(generalFirstup.value);
    }
    if (generalLastup.present) {
      map['general_lastup'] = drift.Variable<int>(generalLastup.value);
    }
    if (globalPoint.present) {
      map['global_point'] = drift.Variable<int>(globalPoint.value);
    }
    if (fav.present) {
      map['fav'] = drift.Variable<int>(fav.value);
    }
    if (reviewCount.present) {
      map['review_count'] = drift.Variable<int>(reviewCount.value);
    }
    if (rateCount.present) {
      map['rate_count'] = drift.Variable<int>(rateCount.value);
    }
    if (allPoint.present) {
      map['all_point'] = drift.Variable<int>(allPoint.value);
    }
    if (pointCount.present) {
      map['point_count'] = drift.Variable<int>(pointCount.value);
    }
    if (dailyPoint.present) {
      map['daily_point'] = drift.Variable<int>(dailyPoint.value);
    }
    if (weeklyPoint.present) {
      map['weekly_point'] = drift.Variable<int>(weeklyPoint.value);
    }
    if (monthlyPoint.present) {
      map['monthly_point'] = drift.Variable<int>(monthlyPoint.value);
    }
    if (quarterPoint.present) {
      map['quarter_point'] = drift.Variable<int>(quarterPoint.value);
    }
    if (yearlyPoint.present) {
      map['yearly_point'] = drift.Variable<int>(yearlyPoint.value);
    }
    if (generalAllNo.present) {
      map['general_all_no'] = drift.Variable<int>(generalAllNo.value);
    }
    if (novelUpdatedAt.present) {
      map['novel_updated_at'] = drift.Variable<String>(novelUpdatedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = drift.Variable<int>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NovelsCompanion(')
          ..write('ncode: $ncode, ')
          ..write('title: $title, ')
          ..write('writer: $writer, ')
          ..write('story: $story, ')
          ..write('novelType: $novelType, ')
          ..write('end: $end, ')
          ..write('genre: $genre, ')
          ..write('isr15: $isr15, ')
          ..write('isbl: $isbl, ')
          ..write('isgl: $isgl, ')
          ..write('iszankoku: $iszankoku, ')
          ..write('istensei: $istensei, ')
          ..write('istenni: $istenni, ')
          ..write('keyword: $keyword, ')
          ..write('generalFirstup: $generalFirstup, ')
          ..write('generalLastup: $generalLastup, ')
          ..write('globalPoint: $globalPoint, ')
          ..write('fav: $fav, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('rateCount: $rateCount, ')
          ..write('allPoint: $allPoint, ')
          ..write('pointCount: $pointCount, ')
          ..write('dailyPoint: $dailyPoint, ')
          ..write('weeklyPoint: $weeklyPoint, ')
          ..write('monthlyPoint: $monthlyPoint, ')
          ..write('quarterPoint: $quarterPoint, ')
          ..write('yearlyPoint: $yearlyPoint, ')
          ..write('generalAllNo: $generalAllNo, ')
          ..write('novelUpdatedAt: $novelUpdatedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryEntriesTable extends LibraryEntries
    with drift.TableInfo<$LibraryEntriesTable, LibraryEntry> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryEntriesTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _ncodeMeta = const drift.VerificationMeta(
    'ncode',
  );
  @override
  late final drift.GeneratedColumn<String> ncode =
      drift.GeneratedColumn<String>(
        'ncode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES novels (ncode)',
        ),
      );
  static const drift.VerificationMeta _addedAtMeta =
      const drift.VerificationMeta('addedAt');
  @override
  late final drift.GeneratedColumn<int> addedAt = drift.GeneratedColumn<int>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<drift.GeneratedColumn> get $columns => [ncode, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_entries';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<LibraryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ncode')) {
      context.handle(
        _ncodeMeta,
        ncode.isAcceptableOrUnknown(data['ncode']!, _ncodeMeta),
      );
    } else if (isInserting) {
      context.missing(_ncodeMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {ncode};
  @override
  LibraryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryEntry(
      ncode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ncode'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $LibraryEntriesTable createAlias(String alias) {
    return $LibraryEntriesTable(attachedDatabase, alias);
  }
}

class LibraryEntry extends drift.DataClass
    implements drift.Insertable<LibraryEntry> {
  /// 小説のncode (外部キー)
  final String ncode;

  /// ライブラリに追加された日時
  /// UNIXタイムスタンプ形式で保存される
  final int addedAt;
  const LibraryEntry({required this.ncode, required this.addedAt});
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['ncode'] = drift.Variable<String>(ncode);
    map['added_at'] = drift.Variable<int>(addedAt);
    return map;
  }

  LibraryEntriesCompanion toCompanion(bool nullToAbsent) {
    return LibraryEntriesCompanion(
      ncode: drift.Value(ncode),
      addedAt: drift.Value(addedAt),
    );
  }

  factory LibraryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return LibraryEntry(
      ncode: serializer.fromJson<String>(json['ncode']),
      addedAt: serializer.fromJson<int>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'addedAt': serializer.toJson<int>(addedAt),
    };
  }

  LibraryEntry copyWith({String? ncode, int? addedAt}) => LibraryEntry(
    ncode: ncode ?? this.ncode,
    addedAt: addedAt ?? this.addedAt,
  );
  LibraryEntry copyWithCompanion(LibraryEntriesCompanion data) {
    return LibraryEntry(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryEntry(')
          ..write('ncode: $ncode, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ncode, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryEntry &&
          other.ncode == this.ncode &&
          other.addedAt == this.addedAt);
}

class LibraryEntriesCompanion extends drift.UpdateCompanion<LibraryEntry> {
  final drift.Value<String> ncode;
  final drift.Value<int> addedAt;
  final drift.Value<int> rowid;
  const LibraryEntriesCompanion({
    this.ncode = const drift.Value.absent(),
    this.addedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  LibraryEntriesCompanion.insert({
    required String ncode,
    required int addedAt,
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode),
       addedAt = drift.Value(addedAt);
  static drift.Insertable<LibraryEntry> custom({
    drift.Expression<String>? ncode,
    drift.Expression<int>? addedAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryEntriesCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<int>? addedAt,
    drift.Value<int>? rowid,
  }) {
    return LibraryEntriesCompanion(
      ncode: ncode ?? this.ncode,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (ncode.present) {
      map['ncode'] = drift.Variable<String>(ncode.value);
    }
    if (addedAt.present) {
      map['added_at'] = drift.Variable<int>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryEntriesCompanion(')
          ..write('ncode: $ncode, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingHistoryTable extends ReadingHistory
    with drift.TableInfo<$ReadingHistoryTable, ReadingHistoryData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingHistoryTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _ncodeMeta = const drift.VerificationMeta(
    'ncode',
  );
  @override
  late final drift.GeneratedColumn<String> ncode =
      drift.GeneratedColumn<String>(
        'ncode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES novels (ncode)',
        ),
      );
  static const drift.VerificationMeta _lastEpisodeIdMeta =
      const drift.VerificationMeta('lastEpisodeId');
  @override
  late final drift.GeneratedColumn<int> lastEpisodeId =
      drift.GeneratedColumn<int>(
        'last_episode_id',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _viewedAtMeta =
      const drift.VerificationMeta('viewedAt');
  @override
  late final drift.GeneratedColumn<int> viewedAt = drift.GeneratedColumn<int>(
    'viewed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _updatedAtMeta =
      const drift.VerificationMeta('updatedAt');
  @override
  late final drift.GeneratedColumn<int> updatedAt = drift.GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const drift.Constant(0),
  );
  @override
  List<drift.GeneratedColumn> get $columns => [
    ncode,
    lastEpisodeId,
    viewedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_history';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<ReadingHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ncode')) {
      context.handle(
        _ncodeMeta,
        ncode.isAcceptableOrUnknown(data['ncode']!, _ncodeMeta),
      );
    } else if (isInserting) {
      context.missing(_ncodeMeta);
    }
    if (data.containsKey('last_episode_id')) {
      context.handle(
        _lastEpisodeIdMeta,
        lastEpisodeId.isAcceptableOrUnknown(
          data['last_episode_id']!,
          _lastEpisodeIdMeta,
        ),
      );
    }
    if (data.containsKey('viewed_at')) {
      context.handle(
        _viewedAtMeta,
        viewedAt.isAcceptableOrUnknown(data['viewed_at']!, _viewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_viewedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {ncode};
  @override
  ReadingHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingHistoryData(
      ncode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ncode'],
      )!,
      lastEpisodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_episode_id'],
      ),
      viewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}viewed_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingHistoryTable createAlias(String alias) {
    return $ReadingHistoryTable(attachedDatabase, alias);
  }
}

class ReadingHistoryData extends drift.DataClass
    implements drift.Insertable<ReadingHistoryData> {
  /// 小説のncode (外部キー)
  final String ncode;

  /// 最後に閲覧したエピソード番号
  final int? lastEpisodeId;

  /// 閲覧日時
  final int viewedAt;

  /// 更新日時
  final int updatedAt;
  const ReadingHistoryData({
    required this.ncode,
    this.lastEpisodeId,
    required this.viewedAt,
    required this.updatedAt,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['ncode'] = drift.Variable<String>(ncode);
    if (!nullToAbsent || lastEpisodeId != null) {
      map['last_episode_id'] = drift.Variable<int>(lastEpisodeId);
    }
    map['viewed_at'] = drift.Variable<int>(viewedAt);
    map['updated_at'] = drift.Variable<int>(updatedAt);
    return map;
  }

  ReadingHistoryCompanion toCompanion(bool nullToAbsent) {
    return ReadingHistoryCompanion(
      ncode: drift.Value(ncode),
      lastEpisodeId: lastEpisodeId == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(lastEpisodeId),
      viewedAt: drift.Value(viewedAt),
      updatedAt: drift.Value(updatedAt),
    );
  }

  factory ReadingHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return ReadingHistoryData(
      ncode: serializer.fromJson<String>(json['ncode']),
      lastEpisodeId: serializer.fromJson<int?>(json['lastEpisodeId']),
      viewedAt: serializer.fromJson<int>(json['viewedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'lastEpisodeId': serializer.toJson<int?>(lastEpisodeId),
      'viewedAt': serializer.toJson<int>(viewedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReadingHistoryData copyWith({
    String? ncode,
    drift.Value<int?> lastEpisodeId = const drift.Value.absent(),
    int? viewedAt,
    int? updatedAt,
  }) => ReadingHistoryData(
    ncode: ncode ?? this.ncode,
    lastEpisodeId: lastEpisodeId.present
        ? lastEpisodeId.value
        : this.lastEpisodeId,
    viewedAt: viewedAt ?? this.viewedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingHistoryData copyWithCompanion(ReadingHistoryCompanion data) {
    return ReadingHistoryData(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      lastEpisodeId: data.lastEpisodeId.present
          ? data.lastEpisodeId.value
          : this.lastEpisodeId,
      viewedAt: data.viewedAt.present ? data.viewedAt.value : this.viewedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingHistoryData(')
          ..write('ncode: $ncode, ')
          ..write('lastEpisodeId: $lastEpisodeId, ')
          ..write('viewedAt: $viewedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ncode, lastEpisodeId, viewedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingHistoryData &&
          other.ncode == this.ncode &&
          other.lastEpisodeId == this.lastEpisodeId &&
          other.viewedAt == this.viewedAt &&
          other.updatedAt == this.updatedAt);
}

class ReadingHistoryCompanion
    extends drift.UpdateCompanion<ReadingHistoryData> {
  final drift.Value<String> ncode;
  final drift.Value<int?> lastEpisodeId;
  final drift.Value<int> viewedAt;
  final drift.Value<int> updatedAt;
  final drift.Value<int> rowid;
  const ReadingHistoryCompanion({
    this.ncode = const drift.Value.absent(),
    this.lastEpisodeId = const drift.Value.absent(),
    this.viewedAt = const drift.Value.absent(),
    this.updatedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  ReadingHistoryCompanion.insert({
    required String ncode,
    this.lastEpisodeId = const drift.Value.absent(),
    required int viewedAt,
    this.updatedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode),
       viewedAt = drift.Value(viewedAt);
  static drift.Insertable<ReadingHistoryData> custom({
    drift.Expression<String>? ncode,
    drift.Expression<int>? lastEpisodeId,
    drift.Expression<int>? viewedAt,
    drift.Expression<int>? updatedAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (lastEpisodeId != null) 'last_episode_id': lastEpisodeId,
      if (viewedAt != null) 'viewed_at': viewedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingHistoryCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<int?>? lastEpisodeId,
    drift.Value<int>? viewedAt,
    drift.Value<int>? updatedAt,
    drift.Value<int>? rowid,
  }) {
    return ReadingHistoryCompanion(
      ncode: ncode ?? this.ncode,
      lastEpisodeId: lastEpisodeId ?? this.lastEpisodeId,
      viewedAt: viewedAt ?? this.viewedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (ncode.present) {
      map['ncode'] = drift.Variable<String>(ncode.value);
    }
    if (lastEpisodeId.present) {
      map['last_episode_id'] = drift.Variable<int>(lastEpisodeId.value);
    }
    if (viewedAt.present) {
      map['viewed_at'] = drift.Variable<int>(viewedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = drift.Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingHistoryCompanion(')
          ..write('ncode: $ncode, ')
          ..write('lastEpisodeId: $lastEpisodeId, ')
          ..write('viewedAt: $viewedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EpisodeEntitiesTable extends EpisodeEntities
    with drift.TableInfo<$EpisodeEntitiesTable, EpisodeRow> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodeEntitiesTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _ncodeMeta = const drift.VerificationMeta(
    'ncode',
  );
  @override
  late final drift.GeneratedColumn<String> ncode =
      drift.GeneratedColumn<String>(
        'ncode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES novels (ncode)',
        ),
      );
  static const drift.VerificationMeta _episodeIdMeta =
      const drift.VerificationMeta('episodeId');
  @override
  late final drift.GeneratedColumn<int> episodeId = drift.GeneratedColumn<int>(
    'episode_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _subtitleMeta =
      const drift.VerificationMeta('subtitle');
  @override
  late final drift.GeneratedColumn<String> subtitle =
      drift.GeneratedColumn<String>(
        'subtitle',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _urlMeta = const drift.VerificationMeta(
    'url',
  );
  @override
  late final drift.GeneratedColumn<String> url = drift.GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _publishedAtMeta =
      const drift.VerificationMeta('publishedAt');
  @override
  late final drift.GeneratedColumn<String> publishedAt =
      drift.GeneratedColumn<String>(
        'published_at',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _revisedAtMeta =
      const drift.VerificationMeta('revisedAt');
  @override
  late final drift.GeneratedColumn<String> revisedAt =
      drift.GeneratedColumn<String>(
        'revised_at',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final drift.GeneratedColumnWithTypeConverter<
    List<NovelContentElement>?,
    String
  >
  content =
      drift.GeneratedColumn<String>(
        'content',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<NovelContentElement>?>(
        $EpisodeEntitiesTable.$convertercontentn,
      );
  static const drift.VerificationMeta _fetchedAtMeta =
      const drift.VerificationMeta('fetchedAt');
  @override
  late final drift.GeneratedColumn<int> fetchedAt = drift.GeneratedColumn<int>(
    'fetched_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<drift.GeneratedColumn> get $columns => [
    ncode,
    episodeId,
    subtitle,
    url,
    publishedAt,
    revisedAt,
    content,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episodes';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<EpisodeRow> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ncode')) {
      context.handle(
        _ncodeMeta,
        ncode.isAcceptableOrUnknown(data['ncode']!, _ncodeMeta),
      );
    } else if (isInserting) {
      context.missing(_ncodeMeta);
    }
    if (data.containsKey('episode_id')) {
      context.handle(
        _episodeIdMeta,
        episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_episodeIdMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('revised_at')) {
      context.handle(
        _revisedAtMeta,
        revisedAt.isAcceptableOrUnknown(data['revised_at']!, _revisedAtMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {ncode, episodeId};
  @override
  EpisodeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EpisodeRow(
      ncode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ncode'],
      )!,
      episodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_id'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}published_at'],
      ),
      revisedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revised_at'],
      ),
      content: $EpisodeEntitiesTable.$convertercontentn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}content'],
        ),
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fetched_at'],
      ),
    );
  }

  @override
  $EpisodeEntitiesTable createAlias(String alias) {
    return $EpisodeEntitiesTable(attachedDatabase, alias);
  }

  static drift.TypeConverter<List<NovelContentElement>, String>
  $convertercontent = const ContentConverter();
  static drift.TypeConverter<List<NovelContentElement>?, String?>
  $convertercontentn = NullAwareTypeConverter.wrap($convertercontent);
}

class EpisodeRow extends drift.DataClass
    implements drift.Insertable<EpisodeRow> {
  /// 小説のncode (外部キー)
  final String ncode;

  /// エピソード番号
  final int episodeId;

  /// サブタイトル（目次用）
  final String? subtitle;

  /// URL
  final String? url;

  /// 掲載日（APIのupdate）
  final String? publishedAt;

  /// 改稿日（APIのrevised）
  final String? revisedAt;

  /// エピソードの内容（キャッシュ）
  /// JSON形式で保存される。空配列=失敗、中身あり=成功、NULL=未取得
  final List<NovelContentElement>? content;

  /// コンテンツ取得日時
  final int? fetchedAt;
  const EpisodeRow({
    required this.ncode,
    required this.episodeId,
    this.subtitle,
    this.url,
    this.publishedAt,
    this.revisedAt,
    this.content,
    this.fetchedAt,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['ncode'] = drift.Variable<String>(ncode);
    map['episode_id'] = drift.Variable<int>(episodeId);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = drift.Variable<String>(subtitle);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = drift.Variable<String>(url);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = drift.Variable<String>(publishedAt);
    }
    if (!nullToAbsent || revisedAt != null) {
      map['revised_at'] = drift.Variable<String>(revisedAt);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = drift.Variable<String>(
        $EpisodeEntitiesTable.$convertercontentn.toSql(content),
      );
    }
    if (!nullToAbsent || fetchedAt != null) {
      map['fetched_at'] = drift.Variable<int>(fetchedAt);
    }
    return map;
  }

  EpisodeEntitiesCompanion toCompanion(bool nullToAbsent) {
    return EpisodeEntitiesCompanion(
      ncode: drift.Value(ncode),
      episodeId: drift.Value(episodeId),
      subtitle: subtitle == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(subtitle),
      url: url == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(url),
      publishedAt: publishedAt == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(publishedAt),
      revisedAt: revisedAt == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(revisedAt),
      content: content == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(content),
      fetchedAt: fetchedAt == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(fetchedAt),
    );
  }

  factory EpisodeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return EpisodeRow(
      ncode: serializer.fromJson<String>(json['ncode']),
      episodeId: serializer.fromJson<int>(json['episodeId']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      url: serializer.fromJson<String?>(json['url']),
      publishedAt: serializer.fromJson<String?>(json['publishedAt']),
      revisedAt: serializer.fromJson<String?>(json['revisedAt']),
      content: serializer.fromJson<List<NovelContentElement>?>(json['content']),
      fetchedAt: serializer.fromJson<int?>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'episodeId': serializer.toJson<int>(episodeId),
      'subtitle': serializer.toJson<String?>(subtitle),
      'url': serializer.toJson<String?>(url),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'revisedAt': serializer.toJson<String?>(revisedAt),
      'content': serializer.toJson<List<NovelContentElement>?>(content),
      'fetchedAt': serializer.toJson<int?>(fetchedAt),
    };
  }

  EpisodeRow copyWith({
    String? ncode,
    int? episodeId,
    drift.Value<String?> subtitle = const drift.Value.absent(),
    drift.Value<String?> url = const drift.Value.absent(),
    drift.Value<String?> publishedAt = const drift.Value.absent(),
    drift.Value<String?> revisedAt = const drift.Value.absent(),
    drift.Value<List<NovelContentElement>?> content =
        const drift.Value.absent(),
    drift.Value<int?> fetchedAt = const drift.Value.absent(),
  }) => EpisodeRow(
    ncode: ncode ?? this.ncode,
    episodeId: episodeId ?? this.episodeId,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    url: url.present ? url.value : this.url,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    revisedAt: revisedAt.present ? revisedAt.value : this.revisedAt,
    content: content.present ? content.value : this.content,
    fetchedAt: fetchedAt.present ? fetchedAt.value : this.fetchedAt,
  );
  EpisodeRow copyWithCompanion(EpisodeEntitiesCompanion data) {
    return EpisodeRow(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      url: data.url.present ? data.url.value : this.url,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      revisedAt: data.revisedAt.present ? data.revisedAt.value : this.revisedAt,
      content: data.content.present ? data.content.value : this.content,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeRow(')
          ..write('ncode: $ncode, ')
          ..write('episodeId: $episodeId, ')
          ..write('subtitle: $subtitle, ')
          ..write('url: $url, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('revisedAt: $revisedAt, ')
          ..write('content: $content, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ncode,
    episodeId,
    subtitle,
    url,
    publishedAt,
    revisedAt,
    content,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EpisodeRow &&
          other.ncode == this.ncode &&
          other.episodeId == this.episodeId &&
          other.subtitle == this.subtitle &&
          other.url == this.url &&
          other.publishedAt == this.publishedAt &&
          other.revisedAt == this.revisedAt &&
          other.content == this.content &&
          other.fetchedAt == this.fetchedAt);
}

class EpisodeEntitiesCompanion extends drift.UpdateCompanion<EpisodeRow> {
  final drift.Value<String> ncode;
  final drift.Value<int> episodeId;
  final drift.Value<String?> subtitle;
  final drift.Value<String?> url;
  final drift.Value<String?> publishedAt;
  final drift.Value<String?> revisedAt;
  final drift.Value<List<NovelContentElement>?> content;
  final drift.Value<int?> fetchedAt;
  final drift.Value<int> rowid;
  const EpisodeEntitiesCompanion({
    this.ncode = const drift.Value.absent(),
    this.episodeId = const drift.Value.absent(),
    this.subtitle = const drift.Value.absent(),
    this.url = const drift.Value.absent(),
    this.publishedAt = const drift.Value.absent(),
    this.revisedAt = const drift.Value.absent(),
    this.content = const drift.Value.absent(),
    this.fetchedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  EpisodeEntitiesCompanion.insert({
    required String ncode,
    required int episodeId,
    this.subtitle = const drift.Value.absent(),
    this.url = const drift.Value.absent(),
    this.publishedAt = const drift.Value.absent(),
    this.revisedAt = const drift.Value.absent(),
    this.content = const drift.Value.absent(),
    this.fetchedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode),
       episodeId = drift.Value(episodeId);
  static drift.Insertable<EpisodeRow> custom({
    drift.Expression<String>? ncode,
    drift.Expression<int>? episodeId,
    drift.Expression<String>? subtitle,
    drift.Expression<String>? url,
    drift.Expression<String>? publishedAt,
    drift.Expression<String>? revisedAt,
    drift.Expression<String>? content,
    drift.Expression<int>? fetchedAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (episodeId != null) 'episode_id': episodeId,
      if (subtitle != null) 'subtitle': subtitle,
      if (url != null) 'url': url,
      if (publishedAt != null) 'published_at': publishedAt,
      if (revisedAt != null) 'revised_at': revisedAt,
      if (content != null) 'content': content,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EpisodeEntitiesCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<int>? episodeId,
    drift.Value<String?>? subtitle,
    drift.Value<String?>? url,
    drift.Value<String?>? publishedAt,
    drift.Value<String?>? revisedAt,
    drift.Value<List<NovelContentElement>?>? content,
    drift.Value<int?>? fetchedAt,
    drift.Value<int>? rowid,
  }) {
    return EpisodeEntitiesCompanion(
      ncode: ncode ?? this.ncode,
      episodeId: episodeId ?? this.episodeId,
      subtitle: subtitle ?? this.subtitle,
      url: url ?? this.url,
      publishedAt: publishedAt ?? this.publishedAt,
      revisedAt: revisedAt ?? this.revisedAt,
      content: content ?? this.content,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (ncode.present) {
      map['ncode'] = drift.Variable<String>(ncode.value);
    }
    if (episodeId.present) {
      map['episode_id'] = drift.Variable<int>(episodeId.value);
    }
    if (subtitle.present) {
      map['subtitle'] = drift.Variable<String>(subtitle.value);
    }
    if (url.present) {
      map['url'] = drift.Variable<String>(url.value);
    }
    if (publishedAt.present) {
      map['published_at'] = drift.Variable<String>(publishedAt.value);
    }
    if (revisedAt.present) {
      map['revised_at'] = drift.Variable<String>(revisedAt.value);
    }
    if (content.present) {
      map['content'] = drift.Variable<String>(
        $EpisodeEntitiesTable.$convertercontentn.toSql(content.value),
      );
    }
    if (fetchedAt.present) {
      map['fetched_at'] = drift.Variable<int>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeEntitiesCompanion(')
          ..write('ncode: $ncode, ')
          ..write('episodeId: $episodeId, ')
          ..write('subtitle: $subtitle, ')
          ..write('url: $url, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('revisedAt: $revisedAt, ')
          ..write('content: $content, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends drift.GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NovelsTable novels = $NovelsTable(this);
  late final $LibraryEntriesTable libraryEntries = $LibraryEntriesTable(this);
  late final $ReadingHistoryTable readingHistory = $ReadingHistoryTable(this);
  late final $EpisodeEntitiesTable episodeEntities = $EpisodeEntitiesTable(
    this,
  );
  @override
  Iterable<drift.TableInfo<drift.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<drift.TableInfo<drift.Table, Object?>>();
  @override
  List<drift.DatabaseSchemaEntity> get allSchemaEntities => [
    novels,
    libraryEntries,
    readingHistory,
    episodeEntities,
  ];
}

typedef $$NovelsTableCreateCompanionBuilder =
    NovelsCompanion Function({
      required String ncode,
      drift.Value<String?> title,
      drift.Value<String?> writer,
      drift.Value<String?> story,
      drift.Value<int?> novelType,
      drift.Value<int?> end,
      drift.Value<int?> genre,
      drift.Value<int?> isr15,
      drift.Value<int?> isbl,
      drift.Value<int?> isgl,
      drift.Value<int?> iszankoku,
      drift.Value<int?> istensei,
      drift.Value<int?> istenni,
      drift.Value<String?> keyword,
      drift.Value<int?> generalFirstup,
      drift.Value<int?> generalLastup,
      drift.Value<int?> globalPoint,
      drift.Value<int?> fav,
      drift.Value<int?> reviewCount,
      drift.Value<int?> rateCount,
      drift.Value<int?> allPoint,
      drift.Value<int?> pointCount,
      drift.Value<int?> dailyPoint,
      drift.Value<int?> weeklyPoint,
      drift.Value<int?> monthlyPoint,
      drift.Value<int?> quarterPoint,
      drift.Value<int?> yearlyPoint,
      drift.Value<int?> generalAllNo,
      drift.Value<String?> novelUpdatedAt,
      drift.Value<int?> cachedAt,
      drift.Value<int> rowid,
    });
typedef $$NovelsTableUpdateCompanionBuilder =
    NovelsCompanion Function({
      drift.Value<String> ncode,
      drift.Value<String?> title,
      drift.Value<String?> writer,
      drift.Value<String?> story,
      drift.Value<int?> novelType,
      drift.Value<int?> end,
      drift.Value<int?> genre,
      drift.Value<int?> isr15,
      drift.Value<int?> isbl,
      drift.Value<int?> isgl,
      drift.Value<int?> iszankoku,
      drift.Value<int?> istensei,
      drift.Value<int?> istenni,
      drift.Value<String?> keyword,
      drift.Value<int?> generalFirstup,
      drift.Value<int?> generalLastup,
      drift.Value<int?> globalPoint,
      drift.Value<int?> fav,
      drift.Value<int?> reviewCount,
      drift.Value<int?> rateCount,
      drift.Value<int?> allPoint,
      drift.Value<int?> pointCount,
      drift.Value<int?> dailyPoint,
      drift.Value<int?> weeklyPoint,
      drift.Value<int?> monthlyPoint,
      drift.Value<int?> quarterPoint,
      drift.Value<int?> yearlyPoint,
      drift.Value<int?> generalAllNo,
      drift.Value<String?> novelUpdatedAt,
      drift.Value<int?> cachedAt,
      drift.Value<int> rowid,
    });

final class $$NovelsTableReferences
    extends drift.BaseReferences<_$AppDatabase, $NovelsTable, Novel> {
  $$NovelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static drift.MultiTypedResultKey<$LibraryEntriesTable, List<LibraryEntry>>
  _libraryEntriesRefsTable(_$AppDatabase db) =>
      drift.MultiTypedResultKey.fromTable(
        db.libraryEntries,
        aliasName: drift.$_aliasNameGenerator(
          db.novels.ncode,
          db.libraryEntries.ncode,
        ),
      );

  $$LibraryEntriesTableProcessedTableManager get libraryEntriesRefs {
    final manager = $$LibraryEntriesTableTableManager(
      $_db,
      $_db.libraryEntries,
    ).filter((f) => f.ncode.ncode.sqlEquals($_itemColumn<String>('ncode')!));

    final cache = $_typedResult.readTableOrNull(_libraryEntriesRefsTable($_db));
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static drift.MultiTypedResultKey<
    $ReadingHistoryTable,
    List<ReadingHistoryData>
  >
  _readingHistoryRefsTable(_$AppDatabase db) =>
      drift.MultiTypedResultKey.fromTable(
        db.readingHistory,
        aliasName: drift.$_aliasNameGenerator(
          db.novels.ncode,
          db.readingHistory.ncode,
        ),
      );

  $$ReadingHistoryTableProcessedTableManager get readingHistoryRefs {
    final manager = $$ReadingHistoryTableTableManager(
      $_db,
      $_db.readingHistory,
    ).filter((f) => f.ncode.ncode.sqlEquals($_itemColumn<String>('ncode')!));

    final cache = $_typedResult.readTableOrNull(_readingHistoryRefsTable($_db));
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static drift.MultiTypedResultKey<$EpisodeEntitiesTable, List<EpisodeRow>>
  _episodeEntitiesRefsTable(_$AppDatabase db) =>
      drift.MultiTypedResultKey.fromTable(
        db.episodeEntities,
        aliasName: drift.$_aliasNameGenerator(
          db.novels.ncode,
          db.episodeEntities.ncode,
        ),
      );

  $$EpisodeEntitiesTableProcessedTableManager get episodeEntitiesRefs {
    final manager = $$EpisodeEntitiesTableTableManager(
      $_db,
      $_db.episodeEntities,
    ).filter((f) => f.ncode.ncode.sqlEquals($_itemColumn<String>('ncode')!));

    final cache = $_typedResult.readTableOrNull(
      _episodeEntitiesRefsTable($_db),
    );
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NovelsTableFilterComposer
    extends drift.Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get writer => $composableBuilder(
    column: $table.writer,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get novelType => $composableBuilder(
    column: $table.novelType,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get isr15 => $composableBuilder(
    column: $table.isr15,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get isbl => $composableBuilder(
    column: $table.isbl,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get isgl => $composableBuilder(
    column: $table.isgl,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get iszankoku => $composableBuilder(
    column: $table.iszankoku,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get istensei => $composableBuilder(
    column: $table.istensei,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get istenni => $composableBuilder(
    column: $table.istenni,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get keyword => $composableBuilder(
    column: $table.keyword,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get generalFirstup => $composableBuilder(
    column: $table.generalFirstup,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get generalLastup => $composableBuilder(
    column: $table.generalLastup,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get globalPoint => $composableBuilder(
    column: $table.globalPoint,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get fav => $composableBuilder(
    column: $table.fav,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get rateCount => $composableBuilder(
    column: $table.rateCount,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get allPoint => $composableBuilder(
    column: $table.allPoint,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get dailyPoint => $composableBuilder(
    column: $table.dailyPoint,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get weeklyPoint => $composableBuilder(
    column: $table.weeklyPoint,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get monthlyPoint => $composableBuilder(
    column: $table.monthlyPoint,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get quarterPoint => $composableBuilder(
    column: $table.quarterPoint,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get yearlyPoint => $composableBuilder(
    column: $table.yearlyPoint,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get generalAllNo => $composableBuilder(
    column: $table.generalAllNo,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get novelUpdatedAt => $composableBuilder(
    column: $table.novelUpdatedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.Expression<bool> libraryEntriesRefs(
    drift.Expression<bool> Function($$LibraryEntriesTableFilterComposer f) f,
  ) {
    final $$LibraryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.libraryEntries,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.libraryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  drift.Expression<bool> readingHistoryRefs(
    drift.Expression<bool> Function($$ReadingHistoryTableFilterComposer f) f,
  ) {
    final $$ReadingHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.readingHistory,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingHistoryTableFilterComposer(
            $db: $db,
            $table: $db.readingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  drift.Expression<bool> episodeEntitiesRefs(
    drift.Expression<bool> Function($$EpisodeEntitiesTableFilterComposer f) f,
  ) {
    final $$EpisodeEntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.episodeEntities,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpisodeEntitiesTableFilterComposer(
            $db: $db,
            $table: $db.episodeEntities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NovelsTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get writer => $composableBuilder(
    column: $table.writer,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get novelType => $composableBuilder(
    column: $table.novelType,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get isr15 => $composableBuilder(
    column: $table.isr15,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get isbl => $composableBuilder(
    column: $table.isbl,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get isgl => $composableBuilder(
    column: $table.isgl,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get iszankoku => $composableBuilder(
    column: $table.iszankoku,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get istensei => $composableBuilder(
    column: $table.istensei,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get istenni => $composableBuilder(
    column: $table.istenni,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get keyword => $composableBuilder(
    column: $table.keyword,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get generalFirstup => $composableBuilder(
    column: $table.generalFirstup,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get generalLastup => $composableBuilder(
    column: $table.generalLastup,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get globalPoint => $composableBuilder(
    column: $table.globalPoint,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get fav => $composableBuilder(
    column: $table.fav,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get rateCount => $composableBuilder(
    column: $table.rateCount,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get allPoint => $composableBuilder(
    column: $table.allPoint,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get dailyPoint => $composableBuilder(
    column: $table.dailyPoint,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get weeklyPoint => $composableBuilder(
    column: $table.weeklyPoint,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get monthlyPoint => $composableBuilder(
    column: $table.monthlyPoint,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get quarterPoint => $composableBuilder(
    column: $table.quarterPoint,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get yearlyPoint => $composableBuilder(
    column: $table.yearlyPoint,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get generalAllNo => $composableBuilder(
    column: $table.generalAllNo,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get novelUpdatedAt => $composableBuilder(
    column: $table.novelUpdatedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$NovelsTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  drift.GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  drift.GeneratedColumn<String> get writer =>
      $composableBuilder(column: $table.writer, builder: (column) => column);

  drift.GeneratedColumn<String> get story =>
      $composableBuilder(column: $table.story, builder: (column) => column);

  drift.GeneratedColumn<int> get novelType =>
      $composableBuilder(column: $table.novelType, builder: (column) => column);

  drift.GeneratedColumn<int> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  drift.GeneratedColumn<int> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  drift.GeneratedColumn<int> get isr15 =>
      $composableBuilder(column: $table.isr15, builder: (column) => column);

  drift.GeneratedColumn<int> get isbl =>
      $composableBuilder(column: $table.isbl, builder: (column) => column);

  drift.GeneratedColumn<int> get isgl =>
      $composableBuilder(column: $table.isgl, builder: (column) => column);

  drift.GeneratedColumn<int> get iszankoku =>
      $composableBuilder(column: $table.iszankoku, builder: (column) => column);

  drift.GeneratedColumn<int> get istensei =>
      $composableBuilder(column: $table.istensei, builder: (column) => column);

  drift.GeneratedColumn<int> get istenni =>
      $composableBuilder(column: $table.istenni, builder: (column) => column);

  drift.GeneratedColumn<String> get keyword =>
      $composableBuilder(column: $table.keyword, builder: (column) => column);

  drift.GeneratedColumn<int> get generalFirstup => $composableBuilder(
    column: $table.generalFirstup,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get generalLastup => $composableBuilder(
    column: $table.generalLastup,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get globalPoint => $composableBuilder(
    column: $table.globalPoint,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get fav =>
      $composableBuilder(column: $table.fav, builder: (column) => column);

  drift.GeneratedColumn<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get rateCount =>
      $composableBuilder(column: $table.rateCount, builder: (column) => column);

  drift.GeneratedColumn<int> get allPoint =>
      $composableBuilder(column: $table.allPoint, builder: (column) => column);

  drift.GeneratedColumn<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get dailyPoint => $composableBuilder(
    column: $table.dailyPoint,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get weeklyPoint => $composableBuilder(
    column: $table.weeklyPoint,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get monthlyPoint => $composableBuilder(
    column: $table.monthlyPoint,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get quarterPoint => $composableBuilder(
    column: $table.quarterPoint,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get yearlyPoint => $composableBuilder(
    column: $table.yearlyPoint,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get generalAllNo => $composableBuilder(
    column: $table.generalAllNo,
    builder: (column) => column,
  );

  drift.GeneratedColumn<String> get novelUpdatedAt => $composableBuilder(
    column: $table.novelUpdatedAt,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  drift.Expression<T> libraryEntriesRefs<T extends Object>(
    drift.Expression<T> Function($$LibraryEntriesTableAnnotationComposer a) f,
  ) {
    final $$LibraryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.libraryEntries,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.libraryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  drift.Expression<T> readingHistoryRefs<T extends Object>(
    drift.Expression<T> Function($$ReadingHistoryTableAnnotationComposer a) f,
  ) {
    final $$ReadingHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.readingHistory,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.readingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  drift.Expression<T> episodeEntitiesRefs<T extends Object>(
    drift.Expression<T> Function($$EpisodeEntitiesTableAnnotationComposer a) f,
  ) {
    final $$EpisodeEntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.episodeEntities,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpisodeEntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.episodeEntities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NovelsTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $NovelsTable,
          Novel,
          $$NovelsTableFilterComposer,
          $$NovelsTableOrderingComposer,
          $$NovelsTableAnnotationComposer,
          $$NovelsTableCreateCompanionBuilder,
          $$NovelsTableUpdateCompanionBuilder,
          (Novel, $$NovelsTableReferences),
          Novel,
          drift.PrefetchHooks Function({
            bool libraryEntriesRefs,
            bool readingHistoryRefs,
            bool episodeEntitiesRefs,
          })
        > {
  $$NovelsTableTableManager(_$AppDatabase db, $NovelsTable table)
    : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NovelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NovelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NovelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<String?> title = const drift.Value.absent(),
                drift.Value<String?> writer = const drift.Value.absent(),
                drift.Value<String?> story = const drift.Value.absent(),
                drift.Value<int?> novelType = const drift.Value.absent(),
                drift.Value<int?> end = const drift.Value.absent(),
                drift.Value<int?> genre = const drift.Value.absent(),
                drift.Value<int?> isr15 = const drift.Value.absent(),
                drift.Value<int?> isbl = const drift.Value.absent(),
                drift.Value<int?> isgl = const drift.Value.absent(),
                drift.Value<int?> iszankoku = const drift.Value.absent(),
                drift.Value<int?> istensei = const drift.Value.absent(),
                drift.Value<int?> istenni = const drift.Value.absent(),
                drift.Value<String?> keyword = const drift.Value.absent(),
                drift.Value<int?> generalFirstup = const drift.Value.absent(),
                drift.Value<int?> generalLastup = const drift.Value.absent(),
                drift.Value<int?> globalPoint = const drift.Value.absent(),
                drift.Value<int?> fav = const drift.Value.absent(),
                drift.Value<int?> reviewCount = const drift.Value.absent(),
                drift.Value<int?> rateCount = const drift.Value.absent(),
                drift.Value<int?> allPoint = const drift.Value.absent(),
                drift.Value<int?> pointCount = const drift.Value.absent(),
                drift.Value<int?> dailyPoint = const drift.Value.absent(),
                drift.Value<int?> weeklyPoint = const drift.Value.absent(),
                drift.Value<int?> monthlyPoint = const drift.Value.absent(),
                drift.Value<int?> quarterPoint = const drift.Value.absent(),
                drift.Value<int?> yearlyPoint = const drift.Value.absent(),
                drift.Value<int?> generalAllNo = const drift.Value.absent(),
                drift.Value<String?> novelUpdatedAt =
                    const drift.Value.absent(),
                drift.Value<int?> cachedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => NovelsCompanion(
                ncode: ncode,
                title: title,
                writer: writer,
                story: story,
                novelType: novelType,
                end: end,
                genre: genre,
                isr15: isr15,
                isbl: isbl,
                isgl: isgl,
                iszankoku: iszankoku,
                istensei: istensei,
                istenni: istenni,
                keyword: keyword,
                generalFirstup: generalFirstup,
                generalLastup: generalLastup,
                globalPoint: globalPoint,
                fav: fav,
                reviewCount: reviewCount,
                rateCount: rateCount,
                allPoint: allPoint,
                pointCount: pointCount,
                dailyPoint: dailyPoint,
                weeklyPoint: weeklyPoint,
                monthlyPoint: monthlyPoint,
                quarterPoint: quarterPoint,
                yearlyPoint: yearlyPoint,
                generalAllNo: generalAllNo,
                novelUpdatedAt: novelUpdatedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                drift.Value<String?> title = const drift.Value.absent(),
                drift.Value<String?> writer = const drift.Value.absent(),
                drift.Value<String?> story = const drift.Value.absent(),
                drift.Value<int?> novelType = const drift.Value.absent(),
                drift.Value<int?> end = const drift.Value.absent(),
                drift.Value<int?> genre = const drift.Value.absent(),
                drift.Value<int?> isr15 = const drift.Value.absent(),
                drift.Value<int?> isbl = const drift.Value.absent(),
                drift.Value<int?> isgl = const drift.Value.absent(),
                drift.Value<int?> iszankoku = const drift.Value.absent(),
                drift.Value<int?> istensei = const drift.Value.absent(),
                drift.Value<int?> istenni = const drift.Value.absent(),
                drift.Value<String?> keyword = const drift.Value.absent(),
                drift.Value<int?> generalFirstup = const drift.Value.absent(),
                drift.Value<int?> generalLastup = const drift.Value.absent(),
                drift.Value<int?> globalPoint = const drift.Value.absent(),
                drift.Value<int?> fav = const drift.Value.absent(),
                drift.Value<int?> reviewCount = const drift.Value.absent(),
                drift.Value<int?> rateCount = const drift.Value.absent(),
                drift.Value<int?> allPoint = const drift.Value.absent(),
                drift.Value<int?> pointCount = const drift.Value.absent(),
                drift.Value<int?> dailyPoint = const drift.Value.absent(),
                drift.Value<int?> weeklyPoint = const drift.Value.absent(),
                drift.Value<int?> monthlyPoint = const drift.Value.absent(),
                drift.Value<int?> quarterPoint = const drift.Value.absent(),
                drift.Value<int?> yearlyPoint = const drift.Value.absent(),
                drift.Value<int?> generalAllNo = const drift.Value.absent(),
                drift.Value<String?> novelUpdatedAt =
                    const drift.Value.absent(),
                drift.Value<int?> cachedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => NovelsCompanion.insert(
                ncode: ncode,
                title: title,
                writer: writer,
                story: story,
                novelType: novelType,
                end: end,
                genre: genre,
                isr15: isr15,
                isbl: isbl,
                isgl: isgl,
                iszankoku: iszankoku,
                istensei: istensei,
                istenni: istenni,
                keyword: keyword,
                generalFirstup: generalFirstup,
                generalLastup: generalLastup,
                globalPoint: globalPoint,
                fav: fav,
                reviewCount: reviewCount,
                rateCount: rateCount,
                allPoint: allPoint,
                pointCount: pointCount,
                dailyPoint: dailyPoint,
                weeklyPoint: weeklyPoint,
                monthlyPoint: monthlyPoint,
                quarterPoint: quarterPoint,
                yearlyPoint: yearlyPoint,
                generalAllNo: generalAllNo,
                novelUpdatedAt: novelUpdatedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NovelsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                libraryEntriesRefs = false,
                readingHistoryRefs = false,
                episodeEntitiesRefs = false,
              }) {
                return drift.PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (libraryEntriesRefs) db.libraryEntries,
                    if (readingHistoryRefs) db.readingHistory,
                    if (episodeEntitiesRefs) db.episodeEntities,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (libraryEntriesRefs)
                        await drift.$_getPrefetchedData<
                          Novel,
                          $NovelsTable,
                          LibraryEntry
                        >(
                          currentTable: table,
                          referencedTable: $$NovelsTableReferences
                              ._libraryEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NovelsTableReferences(
                                db,
                                table,
                                p0,
                              ).libraryEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ncode == item.ncode,
                              ),
                          typedResults: items,
                        ),
                      if (readingHistoryRefs)
                        await drift.$_getPrefetchedData<
                          Novel,
                          $NovelsTable,
                          ReadingHistoryData
                        >(
                          currentTable: table,
                          referencedTable: $$NovelsTableReferences
                              ._readingHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NovelsTableReferences(
                                db,
                                table,
                                p0,
                              ).readingHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ncode == item.ncode,
                              ),
                          typedResults: items,
                        ),
                      if (episodeEntitiesRefs)
                        await drift.$_getPrefetchedData<
                          Novel,
                          $NovelsTable,
                          EpisodeRow
                        >(
                          currentTable: table,
                          referencedTable: $$NovelsTableReferences
                              ._episodeEntitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NovelsTableReferences(
                                db,
                                table,
                                p0,
                              ).episodeEntitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ncode == item.ncode,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$NovelsTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $NovelsTable,
      Novel,
      $$NovelsTableFilterComposer,
      $$NovelsTableOrderingComposer,
      $$NovelsTableAnnotationComposer,
      $$NovelsTableCreateCompanionBuilder,
      $$NovelsTableUpdateCompanionBuilder,
      (Novel, $$NovelsTableReferences),
      Novel,
      drift.PrefetchHooks Function({
        bool libraryEntriesRefs,
        bool readingHistoryRefs,
        bool episodeEntitiesRefs,
      })
    >;
typedef $$LibraryEntriesTableCreateCompanionBuilder =
    LibraryEntriesCompanion Function({
      required String ncode,
      required int addedAt,
      drift.Value<int> rowid,
    });
typedef $$LibraryEntriesTableUpdateCompanionBuilder =
    LibraryEntriesCompanion Function({
      drift.Value<String> ncode,
      drift.Value<int> addedAt,
      drift.Value<int> rowid,
    });

final class $$LibraryEntriesTableReferences
    extends
        drift.BaseReferences<
          _$AppDatabase,
          $LibraryEntriesTable,
          LibraryEntry
        > {
  $$LibraryEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $NovelsTable _ncodeTable(_$AppDatabase db) => db.novels.createAlias(
    drift.$_aliasNameGenerator(db.libraryEntries.ncode, db.novels.ncode),
  );

  $$NovelsTableProcessedTableManager get ncode {
    final $_column = $_itemColumn<String>('ncode')!;

    final manager = $$NovelsTableTableManager(
      $_db,
      $_db.novels,
    ).filter((f) => f.ncode.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ncodeTable($_db));
    if (item == null) return manager;
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LibraryEntriesTableFilterComposer
    extends drift.Composer<_$AppDatabase, $LibraryEntriesTable> {
  $$LibraryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  $$NovelsTableFilterComposer get ncode {
    final $$NovelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableFilterComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryEntriesTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $LibraryEntriesTable> {
  $$LibraryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  $$NovelsTableOrderingComposer get ncode {
    final $$NovelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableOrderingComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryEntriesTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $LibraryEntriesTable> {
  $$LibraryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<int> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$NovelsTableAnnotationComposer get ncode {
    final $$NovelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableAnnotationComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryEntriesTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $LibraryEntriesTable,
          LibraryEntry,
          $$LibraryEntriesTableFilterComposer,
          $$LibraryEntriesTableOrderingComposer,
          $$LibraryEntriesTableAnnotationComposer,
          $$LibraryEntriesTableCreateCompanionBuilder,
          $$LibraryEntriesTableUpdateCompanionBuilder,
          (LibraryEntry, $$LibraryEntriesTableReferences),
          LibraryEntry,
          drift.PrefetchHooks Function({bool ncode})
        > {
  $$LibraryEntriesTableTableManager(
    _$AppDatabase db,
    $LibraryEntriesTable table,
  ) : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<int> addedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => LibraryEntriesCompanion(
                ncode: ncode,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                required int addedAt,
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => LibraryEntriesCompanion.insert(
                ncode: ncode,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LibraryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ncode = false}) {
            return drift.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends drift.TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ncode) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ncode,
                                referencedTable: $$LibraryEntriesTableReferences
                                    ._ncodeTable(db),
                                referencedColumn:
                                    $$LibraryEntriesTableReferences
                                        ._ncodeTable(db)
                                        .ncode,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LibraryEntriesTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $LibraryEntriesTable,
      LibraryEntry,
      $$LibraryEntriesTableFilterComposer,
      $$LibraryEntriesTableOrderingComposer,
      $$LibraryEntriesTableAnnotationComposer,
      $$LibraryEntriesTableCreateCompanionBuilder,
      $$LibraryEntriesTableUpdateCompanionBuilder,
      (LibraryEntry, $$LibraryEntriesTableReferences),
      LibraryEntry,
      drift.PrefetchHooks Function({bool ncode})
    >;
typedef $$ReadingHistoryTableCreateCompanionBuilder =
    ReadingHistoryCompanion Function({
      required String ncode,
      drift.Value<int?> lastEpisodeId,
      required int viewedAt,
      drift.Value<int> updatedAt,
      drift.Value<int> rowid,
    });
typedef $$ReadingHistoryTableUpdateCompanionBuilder =
    ReadingHistoryCompanion Function({
      drift.Value<String> ncode,
      drift.Value<int?> lastEpisodeId,
      drift.Value<int> viewedAt,
      drift.Value<int> updatedAt,
      drift.Value<int> rowid,
    });

final class $$ReadingHistoryTableReferences
    extends
        drift.BaseReferences<
          _$AppDatabase,
          $ReadingHistoryTable,
          ReadingHistoryData
        > {
  $$ReadingHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $NovelsTable _ncodeTable(_$AppDatabase db) => db.novels.createAlias(
    drift.$_aliasNameGenerator(db.readingHistory.ncode, db.novels.ncode),
  );

  $$NovelsTableProcessedTableManager get ncode {
    final $_column = $_itemColumn<String>('ncode')!;

    final manager = $$NovelsTableTableManager(
      $_db,
      $_db.novels,
    ).filter((f) => f.ncode.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ncodeTable($_db));
    if (item == null) return manager;
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingHistoryTableFilterComposer
    extends drift.Composer<_$AppDatabase, $ReadingHistoryTable> {
  $$ReadingHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<int> get lastEpisodeId => $composableBuilder(
    column: $table.lastEpisodeId,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  $$NovelsTableFilterComposer get ncode {
    final $$NovelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableFilterComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingHistoryTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $ReadingHistoryTable> {
  $$ReadingHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<int> get lastEpisodeId => $composableBuilder(
    column: $table.lastEpisodeId,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  $$NovelsTableOrderingComposer get ncode {
    final $$NovelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableOrderingComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingHistoryTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $ReadingHistoryTable> {
  $$ReadingHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<int> get lastEpisodeId => $composableBuilder(
    column: $table.lastEpisodeId,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get viewedAt =>
      $composableBuilder(column: $table.viewedAt, builder: (column) => column);

  drift.GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$NovelsTableAnnotationComposer get ncode {
    final $$NovelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableAnnotationComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingHistoryTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $ReadingHistoryTable,
          ReadingHistoryData,
          $$ReadingHistoryTableFilterComposer,
          $$ReadingHistoryTableOrderingComposer,
          $$ReadingHistoryTableAnnotationComposer,
          $$ReadingHistoryTableCreateCompanionBuilder,
          $$ReadingHistoryTableUpdateCompanionBuilder,
          (ReadingHistoryData, $$ReadingHistoryTableReferences),
          ReadingHistoryData,
          drift.PrefetchHooks Function({bool ncode})
        > {
  $$ReadingHistoryTableTableManager(
    _$AppDatabase db,
    $ReadingHistoryTable table,
  ) : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<int?> lastEpisodeId = const drift.Value.absent(),
                drift.Value<int> viewedAt = const drift.Value.absent(),
                drift.Value<int> updatedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => ReadingHistoryCompanion(
                ncode: ncode,
                lastEpisodeId: lastEpisodeId,
                viewedAt: viewedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                drift.Value<int?> lastEpisodeId = const drift.Value.absent(),
                required int viewedAt,
                drift.Value<int> updatedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => ReadingHistoryCompanion.insert(
                ncode: ncode,
                lastEpisodeId: lastEpisodeId,
                viewedAt: viewedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ncode = false}) {
            return drift.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends drift.TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ncode) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ncode,
                                referencedTable: $$ReadingHistoryTableReferences
                                    ._ncodeTable(db),
                                referencedColumn:
                                    $$ReadingHistoryTableReferences
                                        ._ncodeTable(db)
                                        .ncode,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingHistoryTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $ReadingHistoryTable,
      ReadingHistoryData,
      $$ReadingHistoryTableFilterComposer,
      $$ReadingHistoryTableOrderingComposer,
      $$ReadingHistoryTableAnnotationComposer,
      $$ReadingHistoryTableCreateCompanionBuilder,
      $$ReadingHistoryTableUpdateCompanionBuilder,
      (ReadingHistoryData, $$ReadingHistoryTableReferences),
      ReadingHistoryData,
      drift.PrefetchHooks Function({bool ncode})
    >;
typedef $$EpisodeEntitiesTableCreateCompanionBuilder =
    EpisodeEntitiesCompanion Function({
      required String ncode,
      required int episodeId,
      drift.Value<String?> subtitle,
      drift.Value<String?> url,
      drift.Value<String?> publishedAt,
      drift.Value<String?> revisedAt,
      drift.Value<List<NovelContentElement>?> content,
      drift.Value<int?> fetchedAt,
      drift.Value<int> rowid,
    });
typedef $$EpisodeEntitiesTableUpdateCompanionBuilder =
    EpisodeEntitiesCompanion Function({
      drift.Value<String> ncode,
      drift.Value<int> episodeId,
      drift.Value<String?> subtitle,
      drift.Value<String?> url,
      drift.Value<String?> publishedAt,
      drift.Value<String?> revisedAt,
      drift.Value<List<NovelContentElement>?> content,
      drift.Value<int?> fetchedAt,
      drift.Value<int> rowid,
    });

final class $$EpisodeEntitiesTableReferences
    extends
        drift.BaseReferences<_$AppDatabase, $EpisodeEntitiesTable, EpisodeRow> {
  $$EpisodeEntitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $NovelsTable _ncodeTable(_$AppDatabase db) => db.novels.createAlias(
    drift.$_aliasNameGenerator(db.episodeEntities.ncode, db.novels.ncode),
  );

  $$NovelsTableProcessedTableManager get ncode {
    final $_column = $_itemColumn<String>('ncode')!;

    final manager = $$NovelsTableTableManager(
      $_db,
      $_db.novels,
    ).filter((f) => f.ncode.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ncodeTable($_db));
    if (item == null) return manager;
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EpisodeEntitiesTableFilterComposer
    extends drift.Composer<_$AppDatabase, $EpisodeEntitiesTable> {
  $$EpisodeEntitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get revisedAt => $composableBuilder(
    column: $table.revisedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnWithTypeConverterFilters<
    List<NovelContentElement>?,
    List<NovelContentElement>,
    String
  >
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => drift.ColumnWithTypeConverterFilters(column),
  );

  drift.ColumnFilters<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  $$NovelsTableFilterComposer get ncode {
    final $$NovelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableFilterComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpisodeEntitiesTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $EpisodeEntitiesTable> {
  $$EpisodeEntitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get revisedAt => $composableBuilder(
    column: $table.revisedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  $$NovelsTableOrderingComposer get ncode {
    final $$NovelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableOrderingComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpisodeEntitiesTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $EpisodeEntitiesTable> {
  $$EpisodeEntitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<int> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => column);

  drift.GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  drift.GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  drift.GeneratedColumn<String> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  drift.GeneratedColumn<String> get revisedAt =>
      $composableBuilder(column: $table.revisedAt, builder: (column) => column);

  drift.GeneratedColumnWithTypeConverter<List<NovelContentElement>?, String>
  get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  drift.GeneratedColumn<int> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  $$NovelsTableAnnotationComposer get ncode {
    final $$NovelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ncode,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.ncode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableAnnotationComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpisodeEntitiesTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $EpisodeEntitiesTable,
          EpisodeRow,
          $$EpisodeEntitiesTableFilterComposer,
          $$EpisodeEntitiesTableOrderingComposer,
          $$EpisodeEntitiesTableAnnotationComposer,
          $$EpisodeEntitiesTableCreateCompanionBuilder,
          $$EpisodeEntitiesTableUpdateCompanionBuilder,
          (EpisodeRow, $$EpisodeEntitiesTableReferences),
          EpisodeRow,
          drift.PrefetchHooks Function({bool ncode})
        > {
  $$EpisodeEntitiesTableTableManager(
    _$AppDatabase db,
    $EpisodeEntitiesTable table,
  ) : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodeEntitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodeEntitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodeEntitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<int> episodeId = const drift.Value.absent(),
                drift.Value<String?> subtitle = const drift.Value.absent(),
                drift.Value<String?> url = const drift.Value.absent(),
                drift.Value<String?> publishedAt = const drift.Value.absent(),
                drift.Value<String?> revisedAt = const drift.Value.absent(),
                drift.Value<List<NovelContentElement>?> content =
                    const drift.Value.absent(),
                drift.Value<int?> fetchedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => EpisodeEntitiesCompanion(
                ncode: ncode,
                episodeId: episodeId,
                subtitle: subtitle,
                url: url,
                publishedAt: publishedAt,
                revisedAt: revisedAt,
                content: content,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                required int episodeId,
                drift.Value<String?> subtitle = const drift.Value.absent(),
                drift.Value<String?> url = const drift.Value.absent(),
                drift.Value<String?> publishedAt = const drift.Value.absent(),
                drift.Value<String?> revisedAt = const drift.Value.absent(),
                drift.Value<List<NovelContentElement>?> content =
                    const drift.Value.absent(),
                drift.Value<int?> fetchedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => EpisodeEntitiesCompanion.insert(
                ncode: ncode,
                episodeId: episodeId,
                subtitle: subtitle,
                url: url,
                publishedAt: publishedAt,
                revisedAt: revisedAt,
                content: content,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EpisodeEntitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ncode = false}) {
            return drift.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends drift.TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ncode) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ncode,
                                referencedTable:
                                    $$EpisodeEntitiesTableReferences
                                        ._ncodeTable(db),
                                referencedColumn:
                                    $$EpisodeEntitiesTableReferences
                                        ._ncodeTable(db)
                                        .ncode,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EpisodeEntitiesTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $EpisodeEntitiesTable,
      EpisodeRow,
      $$EpisodeEntitiesTableFilterComposer,
      $$EpisodeEntitiesTableOrderingComposer,
      $$EpisodeEntitiesTableAnnotationComposer,
      $$EpisodeEntitiesTableCreateCompanionBuilder,
      $$EpisodeEntitiesTableUpdateCompanionBuilder,
      (EpisodeRow, $$EpisodeEntitiesTableReferences),
      EpisodeRow,
      drift.PrefetchHooks Function({bool ncode})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NovelsTableTableManager get novels =>
      $$NovelsTableTableManager(_db, _db.novels);
  $$LibraryEntriesTableTableManager get libraryEntries =>
      $$LibraryEntriesTableTableManager(_db, _db.libraryEntries);
  $$ReadingHistoryTableTableManager get readingHistory =>
      $$ReadingHistoryTableTableManager(_db, _db.readingHistory);
  $$EpisodeEntitiesTableTableManager get episodeEntities =>
      $$EpisodeEntitiesTableTableManager(_db, _db.episodeEntities);
}
