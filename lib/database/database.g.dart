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

  /// 作品に��まれる要素に「ガールズラブ」が含まれる場合は1、それ以外は0
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

class $HistoryTable extends History
    with drift.TableInfo<$HistoryTable, HistoryData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryTable(this.attachedDatabase, [this._alias]);
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
  static const drift.VerificationMeta _lastEpisodeMeta =
      const drift.VerificationMeta('lastEpisode');
  @override
  late final drift.GeneratedColumn<int> lastEpisode =
      drift.GeneratedColumn<int>(
        'last_episode',
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
    title,
    writer,
    lastEpisode,
    viewedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<HistoryData> instance, {
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
    if (data.containsKey('last_episode')) {
      context.handle(
        _lastEpisodeMeta,
        lastEpisode.isAcceptableOrUnknown(
          data['last_episode']!,
          _lastEpisodeMeta,
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
  HistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryData(
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
      lastEpisode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_episode'],
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
  $HistoryTable createAlias(String alias) {
    return $HistoryTable(attachedDatabase, alias);
  }
}

class HistoryData extends drift.DataClass
    implements drift.Insertable<HistoryData> {
  /// 小説のncode
  final String ncode;

  /// 小説のタイトル
  final String? title;

  /// 小説の著者
  final String? writer;

  /// 最後に閲覧したエピソード
  final int? lastEpisode;

  /// 閲覧日時
  final int viewedAt;

  /// 更新日時
  final int updatedAt;
  const HistoryData({
    required this.ncode,
    this.title,
    this.writer,
    this.lastEpisode,
    required this.viewedAt,
    required this.updatedAt,
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
    if (!nullToAbsent || lastEpisode != null) {
      map['last_episode'] = drift.Variable<int>(lastEpisode);
    }
    map['viewed_at'] = drift.Variable<int>(viewedAt);
    map['updated_at'] = drift.Variable<int>(updatedAt);
    return map;
  }

  HistoryCompanion toCompanion(bool nullToAbsent) {
    return HistoryCompanion(
      ncode: drift.Value(ncode),
      title: title == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(title),
      writer: writer == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(writer),
      lastEpisode: lastEpisode == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(lastEpisode),
      viewedAt: drift.Value(viewedAt),
      updatedAt: drift.Value(updatedAt),
    );
  }

  factory HistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return HistoryData(
      ncode: serializer.fromJson<String>(json['ncode']),
      title: serializer.fromJson<String?>(json['title']),
      writer: serializer.fromJson<String?>(json['writer']),
      lastEpisode: serializer.fromJson<int?>(json['lastEpisode']),
      viewedAt: serializer.fromJson<int>(json['viewedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'title': serializer.toJson<String?>(title),
      'writer': serializer.toJson<String?>(writer),
      'lastEpisode': serializer.toJson<int?>(lastEpisode),
      'viewedAt': serializer.toJson<int>(viewedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  HistoryData copyWith({
    String? ncode,
    drift.Value<String?> title = const drift.Value.absent(),
    drift.Value<String?> writer = const drift.Value.absent(),
    drift.Value<int?> lastEpisode = const drift.Value.absent(),
    int? viewedAt,
    int? updatedAt,
  }) => HistoryData(
    ncode: ncode ?? this.ncode,
    title: title.present ? title.value : this.title,
    writer: writer.present ? writer.value : this.writer,
    lastEpisode: lastEpisode.present ? lastEpisode.value : this.lastEpisode,
    viewedAt: viewedAt ?? this.viewedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HistoryData copyWithCompanion(HistoryCompanion data) {
    return HistoryData(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      title: data.title.present ? data.title.value : this.title,
      writer: data.writer.present ? data.writer.value : this.writer,
      lastEpisode: data.lastEpisode.present
          ? data.lastEpisode.value
          : this.lastEpisode,
      viewedAt: data.viewedAt.present ? data.viewedAt.value : this.viewedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryData(')
          ..write('ncode: $ncode, ')
          ..write('title: $title, ')
          ..write('writer: $writer, ')
          ..write('lastEpisode: $lastEpisode, ')
          ..write('viewedAt: $viewedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(ncode, title, writer, lastEpisode, viewedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryData &&
          other.ncode == this.ncode &&
          other.title == this.title &&
          other.writer == this.writer &&
          other.lastEpisode == this.lastEpisode &&
          other.viewedAt == this.viewedAt &&
          other.updatedAt == this.updatedAt);
}

class HistoryCompanion extends drift.UpdateCompanion<HistoryData> {
  final drift.Value<String> ncode;
  final drift.Value<String?> title;
  final drift.Value<String?> writer;
  final drift.Value<int?> lastEpisode;
  final drift.Value<int> viewedAt;
  final drift.Value<int> updatedAt;
  final drift.Value<int> rowid;
  const HistoryCompanion({
    this.ncode = const drift.Value.absent(),
    this.title = const drift.Value.absent(),
    this.writer = const drift.Value.absent(),
    this.lastEpisode = const drift.Value.absent(),
    this.viewedAt = const drift.Value.absent(),
    this.updatedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  HistoryCompanion.insert({
    required String ncode,
    this.title = const drift.Value.absent(),
    this.writer = const drift.Value.absent(),
    this.lastEpisode = const drift.Value.absent(),
    required int viewedAt,
    this.updatedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode),
       viewedAt = drift.Value(viewedAt);
  static drift.Insertable<HistoryData> custom({
    drift.Expression<String>? ncode,
    drift.Expression<String>? title,
    drift.Expression<String>? writer,
    drift.Expression<int>? lastEpisode,
    drift.Expression<int>? viewedAt,
    drift.Expression<int>? updatedAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (title != null) 'title': title,
      if (writer != null) 'writer': writer,
      if (lastEpisode != null) 'last_episode': lastEpisode,
      if (viewedAt != null) 'viewed_at': viewedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoryCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<String?>? title,
    drift.Value<String?>? writer,
    drift.Value<int?>? lastEpisode,
    drift.Value<int>? viewedAt,
    drift.Value<int>? updatedAt,
    drift.Value<int>? rowid,
  }) {
    return HistoryCompanion(
      ncode: ncode ?? this.ncode,
      title: title ?? this.title,
      writer: writer ?? this.writer,
      lastEpisode: lastEpisode ?? this.lastEpisode,
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
    if (title.present) {
      map['title'] = drift.Variable<String>(title.value);
    }
    if (writer.present) {
      map['writer'] = drift.Variable<String>(writer.value);
    }
    if (lastEpisode.present) {
      map['last_episode'] = drift.Variable<int>(lastEpisode.value);
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
    return (StringBuffer('HistoryCompanion(')
          ..write('ncode: $ncode, ')
          ..write('title: $title, ')
          ..write('writer: $writer, ')
          ..write('lastEpisode: $lastEpisode, ')
          ..write('viewedAt: $viewedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EpisodesTable extends Episodes
    with drift.TableInfo<$EpisodesTable, Episode> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodesTable(this.attachedDatabase, [this._alias]);
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
  static const drift.VerificationMeta _episodeMeta =
      const drift.VerificationMeta('episode');
  @override
  late final drift.GeneratedColumn<int> episode = drift.GeneratedColumn<int>(
    'episode',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const drift.VerificationMeta _contentMeta =
      const drift.VerificationMeta('content');
  @override
  late final drift.GeneratedColumn<String> content =
      drift.GeneratedColumn<String>(
        'content',
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
    episode,
    title,
    content,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episodes';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<Episode> instance, {
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
    if (data.containsKey('episode')) {
      context.handle(
        _episodeMeta,
        episode.isAcceptableOrUnknown(data['episode']!, _episodeMeta),
      );
    } else if (isInserting) {
      context.missing(_episodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
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
  Set<drift.GeneratedColumn> get $primaryKey => {ncode, episode};
  @override
  Episode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Episode(
      ncode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ncode'],
      )!,
      episode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cached_at'],
      ),
    );
  }

  @override
  $EpisodesTable createAlias(String alias) {
    return $EpisodesTable(attachedDatabase, alias);
  }
}

class Episode extends drift.DataClass implements drift.Insertable<Episode> {
  /// 小説のncode
  final String ncode;

  /// エピソード番号
  final int episode;

  /// エピソードのタイトル
  final String? title;

  /// エピソードの内容
  final String? content;

  /// キャッシュした日時
  final int? cachedAt;
  const Episode({
    required this.ncode,
    required this.episode,
    this.title,
    this.content,
    this.cachedAt,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['ncode'] = drift.Variable<String>(ncode);
    map['episode'] = drift.Variable<int>(episode);
    if (!nullToAbsent || title != null) {
      map['title'] = drift.Variable<String>(title);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = drift.Variable<String>(content);
    }
    if (!nullToAbsent || cachedAt != null) {
      map['cached_at'] = drift.Variable<int>(cachedAt);
    }
    return map;
  }

  EpisodesCompanion toCompanion(bool nullToAbsent) {
    return EpisodesCompanion(
      ncode: drift.Value(ncode),
      episode: drift.Value(episode),
      title: title == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(title),
      content: content == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(content),
      cachedAt: cachedAt == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(cachedAt),
    );
  }

  factory Episode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return Episode(
      ncode: serializer.fromJson<String>(json['ncode']),
      episode: serializer.fromJson<int>(json['episode']),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<String?>(json['content']),
      cachedAt: serializer.fromJson<int?>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'episode': serializer.toJson<int>(episode),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<String?>(content),
      'cachedAt': serializer.toJson<int?>(cachedAt),
    };
  }

  Episode copyWith({
    String? ncode,
    int? episode,
    drift.Value<String?> title = const drift.Value.absent(),
    drift.Value<String?> content = const drift.Value.absent(),
    drift.Value<int?> cachedAt = const drift.Value.absent(),
  }) => Episode(
    ncode: ncode ?? this.ncode,
    episode: episode ?? this.episode,
    title: title.present ? title.value : this.title,
    content: content.present ? content.value : this.content,
    cachedAt: cachedAt.present ? cachedAt.value : this.cachedAt,
  );
  Episode copyWithCompanion(EpisodesCompanion data) {
    return Episode(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      episode: data.episode.present ? data.episode.value : this.episode,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Episode(')
          ..write('ncode: $ncode, ')
          ..write('episode: $episode, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ncode, episode, title, content, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Episode &&
          other.ncode == this.ncode &&
          other.episode == this.episode &&
          other.title == this.title &&
          other.content == this.content &&
          other.cachedAt == this.cachedAt);
}

class EpisodesCompanion extends drift.UpdateCompanion<Episode> {
  final drift.Value<String> ncode;
  final drift.Value<int> episode;
  final drift.Value<String?> title;
  final drift.Value<String?> content;
  final drift.Value<int?> cachedAt;
  final drift.Value<int> rowid;
  const EpisodesCompanion({
    this.ncode = const drift.Value.absent(),
    this.episode = const drift.Value.absent(),
    this.title = const drift.Value.absent(),
    this.content = const drift.Value.absent(),
    this.cachedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  EpisodesCompanion.insert({
    required String ncode,
    required int episode,
    this.title = const drift.Value.absent(),
    this.content = const drift.Value.absent(),
    this.cachedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode),
       episode = drift.Value(episode);
  static drift.Insertable<Episode> custom({
    drift.Expression<String>? ncode,
    drift.Expression<int>? episode,
    drift.Expression<String>? title,
    drift.Expression<String>? content,
    drift.Expression<int>? cachedAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (episode != null) 'episode': episode,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EpisodesCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<int>? episode,
    drift.Value<String?>? title,
    drift.Value<String?>? content,
    drift.Value<int?>? cachedAt,
    drift.Value<int>? rowid,
  }) {
    return EpisodesCompanion(
      ncode: ncode ?? this.ncode,
      episode: episode ?? this.episode,
      title: title ?? this.title,
      content: content ?? this.content,
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
    if (episode.present) {
      map['episode'] = drift.Variable<int>(episode.value);
    }
    if (title.present) {
      map['title'] = drift.Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = drift.Variable<String>(content.value);
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
    return (StringBuffer('EpisodesCompanion(')
          ..write('ncode: $ncode, ')
          ..write('episode: $episode, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadedNovelsTable extends DownloadedNovels
    with drift.TableInfo<$DownloadedNovelsTable, DownloadedNovel> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedNovelsTable(this.attachedDatabase, [this._alias]);
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
  static const drift.VerificationMeta _downloadStatusMeta =
      const drift.VerificationMeta('downloadStatus');
  @override
  late final drift.GeneratedColumn<int> downloadStatus =
      drift.GeneratedColumn<int>(
        'download_status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _downloadedAtMeta =
      const drift.VerificationMeta('downloadedAt');
  @override
  late final drift.GeneratedColumn<int> downloadedAt =
      drift.GeneratedColumn<int>(
        'downloaded_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _totalEpisodesMeta =
      const drift.VerificationMeta('totalEpisodes');
  @override
  late final drift.GeneratedColumn<int> totalEpisodes =
      drift.GeneratedColumn<int>(
        'total_episodes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _downloadedEpisodesMeta =
      const drift.VerificationMeta('downloadedEpisodes');
  @override
  late final drift.GeneratedColumn<int> downloadedEpisodes =
      drift.GeneratedColumn<int>(
        'downloaded_episodes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  @override
  List<drift.GeneratedColumn> get $columns => [
    ncode,
    downloadStatus,
    downloadedAt,
    totalEpisodes,
    downloadedEpisodes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_novels';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<DownloadedNovel> instance, {
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
    if (data.containsKey('download_status')) {
      context.handle(
        _downloadStatusMeta,
        downloadStatus.isAcceptableOrUnknown(
          data['download_status']!,
          _downloadStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadStatusMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    if (data.containsKey('total_episodes')) {
      context.handle(
        _totalEpisodesMeta,
        totalEpisodes.isAcceptableOrUnknown(
          data['total_episodes']!,
          _totalEpisodesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalEpisodesMeta);
    }
    if (data.containsKey('downloaded_episodes')) {
      context.handle(
        _downloadedEpisodesMeta,
        downloadedEpisodes.isAcceptableOrUnknown(
          data['downloaded_episodes']!,
          _downloadedEpisodesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedEpisodesMeta);
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {ncode};
  @override
  DownloadedNovel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedNovel(
      ncode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ncode'],
      )!,
      downloadStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}download_status'],
      )!,
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downloaded_at'],
      )!,
      totalEpisodes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_episodes'],
      )!,
      downloadedEpisodes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downloaded_episodes'],
      )!,
    );
  }

  @override
  $DownloadedNovelsTable createAlias(String alias) {
    return $DownloadedNovelsTable(attachedDatabase, alias);
  }
}

class DownloadedNovel extends drift.DataClass
    implements drift.Insertable<DownloadedNovel> {
  /// 小説のncode
  final String ncode;

  /// ダウンロード状態
  /// 0: 未ダウンロード, 1: ダウンロード中, 2: 完了, 3: 失敗
  final int downloadStatus;

  /// ダウンロード完了日時
  final int downloadedAt;

  /// ダウンロード対象の総話数
  final int totalEpisodes;

  /// ダウンロード済みの話数
  final int downloadedEpisodes;
  const DownloadedNovel({
    required this.ncode,
    required this.downloadStatus,
    required this.downloadedAt,
    required this.totalEpisodes,
    required this.downloadedEpisodes,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['ncode'] = drift.Variable<String>(ncode);
    map['download_status'] = drift.Variable<int>(downloadStatus);
    map['downloaded_at'] = drift.Variable<int>(downloadedAt);
    map['total_episodes'] = drift.Variable<int>(totalEpisodes);
    map['downloaded_episodes'] = drift.Variable<int>(downloadedEpisodes);
    return map;
  }

  DownloadedNovelsCompanion toCompanion(bool nullToAbsent) {
    return DownloadedNovelsCompanion(
      ncode: drift.Value(ncode),
      downloadStatus: drift.Value(downloadStatus),
      downloadedAt: drift.Value(downloadedAt),
      totalEpisodes: drift.Value(totalEpisodes),
      downloadedEpisodes: drift.Value(downloadedEpisodes),
    );
  }

  factory DownloadedNovel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return DownloadedNovel(
      ncode: serializer.fromJson<String>(json['ncode']),
      downloadStatus: serializer.fromJson<int>(json['downloadStatus']),
      downloadedAt: serializer.fromJson<int>(json['downloadedAt']),
      totalEpisodes: serializer.fromJson<int>(json['totalEpisodes']),
      downloadedEpisodes: serializer.fromJson<int>(json['downloadedEpisodes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'downloadStatus': serializer.toJson<int>(downloadStatus),
      'downloadedAt': serializer.toJson<int>(downloadedAt),
      'totalEpisodes': serializer.toJson<int>(totalEpisodes),
      'downloadedEpisodes': serializer.toJson<int>(downloadedEpisodes),
    };
  }

  DownloadedNovel copyWith({
    String? ncode,
    int? downloadStatus,
    int? downloadedAt,
    int? totalEpisodes,
    int? downloadedEpisodes,
  }) => DownloadedNovel(
    ncode: ncode ?? this.ncode,
    downloadStatus: downloadStatus ?? this.downloadStatus,
    downloadedAt: downloadedAt ?? this.downloadedAt,
    totalEpisodes: totalEpisodes ?? this.totalEpisodes,
    downloadedEpisodes: downloadedEpisodes ?? this.downloadedEpisodes,
  );
  DownloadedNovel copyWithCompanion(DownloadedNovelsCompanion data) {
    return DownloadedNovel(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      downloadStatus: data.downloadStatus.present
          ? data.downloadStatus.value
          : this.downloadStatus,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
      totalEpisodes: data.totalEpisodes.present
          ? data.totalEpisodes.value
          : this.totalEpisodes,
      downloadedEpisodes: data.downloadedEpisodes.present
          ? data.downloadedEpisodes.value
          : this.downloadedEpisodes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedNovel(')
          ..write('ncode: $ncode, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('totalEpisodes: $totalEpisodes, ')
          ..write('downloadedEpisodes: $downloadedEpisodes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ncode,
    downloadStatus,
    downloadedAt,
    totalEpisodes,
    downloadedEpisodes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedNovel &&
          other.ncode == this.ncode &&
          other.downloadStatus == this.downloadStatus &&
          other.downloadedAt == this.downloadedAt &&
          other.totalEpisodes == this.totalEpisodes &&
          other.downloadedEpisodes == this.downloadedEpisodes);
}

class DownloadedNovelsCompanion extends drift.UpdateCompanion<DownloadedNovel> {
  final drift.Value<String> ncode;
  final drift.Value<int> downloadStatus;
  final drift.Value<int> downloadedAt;
  final drift.Value<int> totalEpisodes;
  final drift.Value<int> downloadedEpisodes;
  final drift.Value<int> rowid;
  const DownloadedNovelsCompanion({
    this.ncode = const drift.Value.absent(),
    this.downloadStatus = const drift.Value.absent(),
    this.downloadedAt = const drift.Value.absent(),
    this.totalEpisodes = const drift.Value.absent(),
    this.downloadedEpisodes = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  DownloadedNovelsCompanion.insert({
    required String ncode,
    required int downloadStatus,
    required int downloadedAt,
    required int totalEpisodes,
    required int downloadedEpisodes,
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode),
       downloadStatus = drift.Value(downloadStatus),
       downloadedAt = drift.Value(downloadedAt),
       totalEpisodes = drift.Value(totalEpisodes),
       downloadedEpisodes = drift.Value(downloadedEpisodes);
  static drift.Insertable<DownloadedNovel> custom({
    drift.Expression<String>? ncode,
    drift.Expression<int>? downloadStatus,
    drift.Expression<int>? downloadedAt,
    drift.Expression<int>? totalEpisodes,
    drift.Expression<int>? downloadedEpisodes,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (downloadStatus != null) 'download_status': downloadStatus,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (totalEpisodes != null) 'total_episodes': totalEpisodes,
      if (downloadedEpisodes != null) 'downloaded_episodes': downloadedEpisodes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadedNovelsCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<int>? downloadStatus,
    drift.Value<int>? downloadedAt,
    drift.Value<int>? totalEpisodes,
    drift.Value<int>? downloadedEpisodes,
    drift.Value<int>? rowid,
  }) {
    return DownloadedNovelsCompanion(
      ncode: ncode ?? this.ncode,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      downloadedEpisodes: downloadedEpisodes ?? this.downloadedEpisodes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (ncode.present) {
      map['ncode'] = drift.Variable<String>(ncode.value);
    }
    if (downloadStatus.present) {
      map['download_status'] = drift.Variable<int>(downloadStatus.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = drift.Variable<int>(downloadedAt.value);
    }
    if (totalEpisodes.present) {
      map['total_episodes'] = drift.Variable<int>(totalEpisodes.value);
    }
    if (downloadedEpisodes.present) {
      map['downloaded_episodes'] = drift.Variable<int>(
        downloadedEpisodes.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedNovelsCompanion(')
          ..write('ncode: $ncode, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('totalEpisodes: $totalEpisodes, ')
          ..write('downloadedEpisodes: $downloadedEpisodes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadedEpisodesTable extends DownloadedEpisodes
    with drift.TableInfo<$DownloadedEpisodesTable, DownloadedEpisode> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedEpisodesTable(this.attachedDatabase, [this._alias]);
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
  static const drift.VerificationMeta _episodeMeta =
      const drift.VerificationMeta('episode');
  @override
  late final drift.GeneratedColumn<int> episode = drift.GeneratedColumn<int>(
    'episode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final drift.GeneratedColumnWithTypeConverter<
    List<NovelContentElement>,
    String
  >
  content =
      drift.GeneratedColumn<String>(
        'content',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<NovelContentElement>>(
        $DownloadedEpisodesTable.$convertercontent,
      );
  static const drift.VerificationMeta _downloadedAtMeta =
      const drift.VerificationMeta('downloadedAt');
  @override
  late final drift.GeneratedColumn<int> downloadedAt =
      drift.GeneratedColumn<int>(
        'downloaded_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _statusMeta =
      const drift.VerificationMeta('status');
  @override
  late final drift.GeneratedColumn<int> status = drift.GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const drift.Constant(2),
  );
  static const drift.VerificationMeta _errorMessageMeta =
      const drift.VerificationMeta('errorMessage');
  @override
  late final drift.GeneratedColumn<String> errorMessage =
      drift.GeneratedColumn<String>(
        'error_message',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _lastAttemptAtMeta =
      const drift.VerificationMeta('lastAttemptAt');
  @override
  late final drift.GeneratedColumn<int> lastAttemptAt =
      drift.GeneratedColumn<int>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  @override
  List<drift.GeneratedColumn> get $columns => [
    ncode,
    episode,
    content,
    downloadedAt,
    status,
    errorMessage,
    lastAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_episodes';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<DownloadedEpisode> instance, {
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
    if (data.containsKey('episode')) {
      context.handle(
        _episodeMeta,
        episode.isAcceptableOrUnknown(data['episode']!, _episodeMeta),
      );
    } else if (isInserting) {
      context.missing(_episodeMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {ncode, episode};
  @override
  DownloadedEpisode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedEpisode(
      ncode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ncode'],
      )!,
      episode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode'],
      )!,
      content: $DownloadedEpisodesTable.$convertercontent.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}content'],
        )!,
      ),
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downloaded_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_attempt_at'],
      ),
    );
  }

  @override
  $DownloadedEpisodesTable createAlias(String alias) {
    return $DownloadedEpisodesTable(attachedDatabase, alias);
  }

  static drift.TypeConverter<List<NovelContentElement>, String>
  $convertercontent = const ContentConverter();
}

class DownloadedEpisode extends drift.DataClass
    implements drift.Insertable<DownloadedEpisode> {
  /// 小説のncode
  final String ncode;

  /// エピソード番号
  final int episode;

  /// エピソードの内容
  /// JSON形式で保存される
  final List<NovelContentElement> content;

  /// ダウンロード日時
  final int downloadedAt;

  /// ダウンロード状態
  /// 2: 成功, 3: 失敗
  final int status;

  /// 失敗時のエラーメッセージ
  final String? errorMessage;

  /// 最終試行日時
  final int? lastAttemptAt;
  const DownloadedEpisode({
    required this.ncode,
    required this.episode,
    required this.content,
    required this.downloadedAt,
    required this.status,
    this.errorMessage,
    this.lastAttemptAt,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['ncode'] = drift.Variable<String>(ncode);
    map['episode'] = drift.Variable<int>(episode);
    {
      map['content'] = drift.Variable<String>(
        $DownloadedEpisodesTable.$convertercontent.toSql(content),
      );
    }
    map['downloaded_at'] = drift.Variable<int>(downloadedAt);
    map['status'] = drift.Variable<int>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = drift.Variable<String>(errorMessage);
    }
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = drift.Variable<int>(lastAttemptAt);
    }
    return map;
  }

  DownloadedEpisodesCompanion toCompanion(bool nullToAbsent) {
    return DownloadedEpisodesCompanion(
      ncode: drift.Value(ncode),
      episode: drift.Value(episode),
      content: drift.Value(content),
      downloadedAt: drift.Value(downloadedAt),
      status: drift.Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(errorMessage),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(lastAttemptAt),
    );
  }

  factory DownloadedEpisode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return DownloadedEpisode(
      ncode: serializer.fromJson<String>(json['ncode']),
      episode: serializer.fromJson<int>(json['episode']),
      content: serializer.fromJson<List<NovelContentElement>>(json['content']),
      downloadedAt: serializer.fromJson<int>(json['downloadedAt']),
      status: serializer.fromJson<int>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      lastAttemptAt: serializer.fromJson<int?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'episode': serializer.toJson<int>(episode),
      'content': serializer.toJson<List<NovelContentElement>>(content),
      'downloadedAt': serializer.toJson<int>(downloadedAt),
      'status': serializer.toJson<int>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'lastAttemptAt': serializer.toJson<int?>(lastAttemptAt),
    };
  }

  DownloadedEpisode copyWith({
    String? ncode,
    int? episode,
    List<NovelContentElement>? content,
    int? downloadedAt,
    int? status,
    drift.Value<String?> errorMessage = const drift.Value.absent(),
    drift.Value<int?> lastAttemptAt = const drift.Value.absent(),
  }) => DownloadedEpisode(
    ncode: ncode ?? this.ncode,
    episode: episode ?? this.episode,
    content: content ?? this.content,
    downloadedAt: downloadedAt ?? this.downloadedAt,
    status: status ?? this.status,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
  );
  DownloadedEpisode copyWithCompanion(DownloadedEpisodesCompanion data) {
    return DownloadedEpisode(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      episode: data.episode.present ? data.episode.value : this.episode,
      content: data.content.present ? data.content.value : this.content,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedEpisode(')
          ..write('ncode: $ncode, ')
          ..write('episode: $episode, ')
          ..write('content: $content, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ncode,
    episode,
    content,
    downloadedAt,
    status,
    errorMessage,
    lastAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedEpisode &&
          other.ncode == this.ncode &&
          other.episode == this.episode &&
          other.content == this.content &&
          other.downloadedAt == this.downloadedAt &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class DownloadedEpisodesCompanion
    extends drift.UpdateCompanion<DownloadedEpisode> {
  final drift.Value<String> ncode;
  final drift.Value<int> episode;
  final drift.Value<List<NovelContentElement>> content;
  final drift.Value<int> downloadedAt;
  final drift.Value<int> status;
  final drift.Value<String?> errorMessage;
  final drift.Value<int?> lastAttemptAt;
  final drift.Value<int> rowid;
  const DownloadedEpisodesCompanion({
    this.ncode = const drift.Value.absent(),
    this.episode = const drift.Value.absent(),
    this.content = const drift.Value.absent(),
    this.downloadedAt = const drift.Value.absent(),
    this.status = const drift.Value.absent(),
    this.errorMessage = const drift.Value.absent(),
    this.lastAttemptAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  DownloadedEpisodesCompanion.insert({
    required String ncode,
    required int episode,
    required List<NovelContentElement> content,
    required int downloadedAt,
    this.status = const drift.Value.absent(),
    this.errorMessage = const drift.Value.absent(),
    this.lastAttemptAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode),
       episode = drift.Value(episode),
       content = drift.Value(content),
       downloadedAt = drift.Value(downloadedAt);
  static drift.Insertable<DownloadedEpisode> custom({
    drift.Expression<String>? ncode,
    drift.Expression<int>? episode,
    drift.Expression<String>? content,
    drift.Expression<int>? downloadedAt,
    drift.Expression<int>? status,
    drift.Expression<String>? errorMessage,
    drift.Expression<int>? lastAttemptAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (episode != null) 'episode': episode,
      if (content != null) 'content': content,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadedEpisodesCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<int>? episode,
    drift.Value<List<NovelContentElement>>? content,
    drift.Value<int>? downloadedAt,
    drift.Value<int>? status,
    drift.Value<String?>? errorMessage,
    drift.Value<int?>? lastAttemptAt,
    drift.Value<int>? rowid,
  }) {
    return DownloadedEpisodesCompanion(
      ncode: ncode ?? this.ncode,
      episode: episode ?? this.episode,
      content: content ?? this.content,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (ncode.present) {
      map['ncode'] = drift.Variable<String>(ncode.value);
    }
    if (episode.present) {
      map['episode'] = drift.Variable<int>(episode.value);
    }
    if (content.present) {
      map['content'] = drift.Variable<String>(
        $DownloadedEpisodesTable.$convertercontent.toSql(content.value),
      );
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = drift.Variable<int>(downloadedAt.value);
    }
    if (status.present) {
      map['status'] = drift.Variable<int>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = drift.Variable<String>(errorMessage.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = drift.Variable<int>(lastAttemptAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedEpisodesCompanion(')
          ..write('ncode: $ncode, ')
          ..write('episode: $episode, ')
          ..write('content: $content, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryNovelsTable extends LibraryNovels
    with drift.TableInfo<$LibraryNovelsTable, LibraryNovel> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryNovelsTable(this.attachedDatabase, [this._alias]);
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
  List<drift.GeneratedColumn> get $columns => [
    ncode,
    title,
    writer,
    story,
    novelType,
    end,
    generalAllNo,
    novelUpdatedAt,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_novels';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<LibraryNovel> instance, {
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
  LibraryNovel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryNovel(
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
      generalAllNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}general_all_no'],
      ),
      novelUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}novel_updated_at'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $LibraryNovelsTable createAlias(String alias) {
    return $LibraryNovelsTable(attachedDatabase, alias);
  }
}

class LibraryNovel extends drift.DataClass
    implements drift.Insertable<LibraryNovel> {
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

  /// 連載小説のエピソード数 短編は常に1
  final int? generalAllNo;

  /// 作品の更新日時
  final String? novelUpdatedAt;

  /// ライブラリに追加された日時
  /// UNIXタイムスタンプ形式で保存される
  final int addedAt;
  const LibraryNovel({
    required this.ncode,
    this.title,
    this.writer,
    this.story,
    this.novelType,
    this.end,
    this.generalAllNo,
    this.novelUpdatedAt,
    required this.addedAt,
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
    if (!nullToAbsent || generalAllNo != null) {
      map['general_all_no'] = drift.Variable<int>(generalAllNo);
    }
    if (!nullToAbsent || novelUpdatedAt != null) {
      map['novel_updated_at'] = drift.Variable<String>(novelUpdatedAt);
    }
    map['added_at'] = drift.Variable<int>(addedAt);
    return map;
  }

  LibraryNovelsCompanion toCompanion(bool nullToAbsent) {
    return LibraryNovelsCompanion(
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
      generalAllNo: generalAllNo == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(generalAllNo),
      novelUpdatedAt: novelUpdatedAt == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(novelUpdatedAt),
      addedAt: drift.Value(addedAt),
    );
  }

  factory LibraryNovel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return LibraryNovel(
      ncode: serializer.fromJson<String>(json['ncode']),
      title: serializer.fromJson<String?>(json['title']),
      writer: serializer.fromJson<String?>(json['writer']),
      story: serializer.fromJson<String?>(json['story']),
      novelType: serializer.fromJson<int?>(json['novelType']),
      end: serializer.fromJson<int?>(json['end']),
      generalAllNo: serializer.fromJson<int?>(json['generalAllNo']),
      novelUpdatedAt: serializer.fromJson<String?>(json['novelUpdatedAt']),
      addedAt: serializer.fromJson<int>(json['addedAt']),
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
      'generalAllNo': serializer.toJson<int?>(generalAllNo),
      'novelUpdatedAt': serializer.toJson<String?>(novelUpdatedAt),
      'addedAt': serializer.toJson<int>(addedAt),
    };
  }

  LibraryNovel copyWith({
    String? ncode,
    drift.Value<String?> title = const drift.Value.absent(),
    drift.Value<String?> writer = const drift.Value.absent(),
    drift.Value<String?> story = const drift.Value.absent(),
    drift.Value<int?> novelType = const drift.Value.absent(),
    drift.Value<int?> end = const drift.Value.absent(),
    drift.Value<int?> generalAllNo = const drift.Value.absent(),
    drift.Value<String?> novelUpdatedAt = const drift.Value.absent(),
    int? addedAt,
  }) => LibraryNovel(
    ncode: ncode ?? this.ncode,
    title: title.present ? title.value : this.title,
    writer: writer.present ? writer.value : this.writer,
    story: story.present ? story.value : this.story,
    novelType: novelType.present ? novelType.value : this.novelType,
    end: end.present ? end.value : this.end,
    generalAllNo: generalAllNo.present ? generalAllNo.value : this.generalAllNo,
    novelUpdatedAt: novelUpdatedAt.present
        ? novelUpdatedAt.value
        : this.novelUpdatedAt,
    addedAt: addedAt ?? this.addedAt,
  );
  LibraryNovel copyWithCompanion(LibraryNovelsCompanion data) {
    return LibraryNovel(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      title: data.title.present ? data.title.value : this.title,
      writer: data.writer.present ? data.writer.value : this.writer,
      story: data.story.present ? data.story.value : this.story,
      novelType: data.novelType.present ? data.novelType.value : this.novelType,
      end: data.end.present ? data.end.value : this.end,
      generalAllNo: data.generalAllNo.present
          ? data.generalAllNo.value
          : this.generalAllNo,
      novelUpdatedAt: data.novelUpdatedAt.present
          ? data.novelUpdatedAt.value
          : this.novelUpdatedAt,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryNovel(')
          ..write('ncode: $ncode, ')
          ..write('title: $title, ')
          ..write('writer: $writer, ')
          ..write('story: $story, ')
          ..write('novelType: $novelType, ')
          ..write('end: $end, ')
          ..write('generalAllNo: $generalAllNo, ')
          ..write('novelUpdatedAt: $novelUpdatedAt, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ncode,
    title,
    writer,
    story,
    novelType,
    end,
    generalAllNo,
    novelUpdatedAt,
    addedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryNovel &&
          other.ncode == this.ncode &&
          other.title == this.title &&
          other.writer == this.writer &&
          other.story == this.story &&
          other.novelType == this.novelType &&
          other.end == this.end &&
          other.generalAllNo == this.generalAllNo &&
          other.novelUpdatedAt == this.novelUpdatedAt &&
          other.addedAt == this.addedAt);
}

class LibraryNovelsCompanion extends drift.UpdateCompanion<LibraryNovel> {
  final drift.Value<String> ncode;
  final drift.Value<String?> title;
  final drift.Value<String?> writer;
  final drift.Value<String?> story;
  final drift.Value<int?> novelType;
  final drift.Value<int?> end;
  final drift.Value<int?> generalAllNo;
  final drift.Value<String?> novelUpdatedAt;
  final drift.Value<int> addedAt;
  final drift.Value<int> rowid;
  const LibraryNovelsCompanion({
    this.ncode = const drift.Value.absent(),
    this.title = const drift.Value.absent(),
    this.writer = const drift.Value.absent(),
    this.story = const drift.Value.absent(),
    this.novelType = const drift.Value.absent(),
    this.end = const drift.Value.absent(),
    this.generalAllNo = const drift.Value.absent(),
    this.novelUpdatedAt = const drift.Value.absent(),
    this.addedAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  LibraryNovelsCompanion.insert({
    required String ncode,
    this.title = const drift.Value.absent(),
    this.writer = const drift.Value.absent(),
    this.story = const drift.Value.absent(),
    this.novelType = const drift.Value.absent(),
    this.end = const drift.Value.absent(),
    this.generalAllNo = const drift.Value.absent(),
    this.novelUpdatedAt = const drift.Value.absent(),
    required int addedAt,
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode),
       addedAt = drift.Value(addedAt);
  static drift.Insertable<LibraryNovel> custom({
    drift.Expression<String>? ncode,
    drift.Expression<String>? title,
    drift.Expression<String>? writer,
    drift.Expression<String>? story,
    drift.Expression<int>? novelType,
    drift.Expression<int>? end,
    drift.Expression<int>? generalAllNo,
    drift.Expression<String>? novelUpdatedAt,
    drift.Expression<int>? addedAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (title != null) 'title': title,
      if (writer != null) 'writer': writer,
      if (story != null) 'story': story,
      if (novelType != null) 'novel_type': novelType,
      if (end != null) 'end': end,
      if (generalAllNo != null) 'general_all_no': generalAllNo,
      if (novelUpdatedAt != null) 'novel_updated_at': novelUpdatedAt,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryNovelsCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<String?>? title,
    drift.Value<String?>? writer,
    drift.Value<String?>? story,
    drift.Value<int?>? novelType,
    drift.Value<int?>? end,
    drift.Value<int?>? generalAllNo,
    drift.Value<String?>? novelUpdatedAt,
    drift.Value<int>? addedAt,
    drift.Value<int>? rowid,
  }) {
    return LibraryNovelsCompanion(
      ncode: ncode ?? this.ncode,
      title: title ?? this.title,
      writer: writer ?? this.writer,
      story: story ?? this.story,
      novelType: novelType ?? this.novelType,
      end: end ?? this.end,
      generalAllNo: generalAllNo ?? this.generalAllNo,
      novelUpdatedAt: novelUpdatedAt ?? this.novelUpdatedAt,
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
    if (generalAllNo.present) {
      map['general_all_no'] = drift.Variable<int>(generalAllNo.value);
    }
    if (novelUpdatedAt.present) {
      map['novel_updated_at'] = drift.Variable<String>(novelUpdatedAt.value);
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
    return (StringBuffer('LibraryNovelsCompanion(')
          ..write('ncode: $ncode, ')
          ..write('title: $title, ')
          ..write('writer: $writer, ')
          ..write('story: $story, ')
          ..write('novelType: $novelType, ')
          ..write('end: $end, ')
          ..write('generalAllNo: $generalAllNo, ')
          ..write('novelUpdatedAt: $novelUpdatedAt, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with drift.TableInfo<$BookmarksTable, Bookmark> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
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
  static const drift.VerificationMeta _episodeMeta =
      const drift.VerificationMeta('episode');
  @override
  late final drift.GeneratedColumn<int> episode = drift.GeneratedColumn<int>(
    'episode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _positionMeta =
      const drift.VerificationMeta('position');
  @override
  late final drift.GeneratedColumn<int> position = drift.GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _contentMeta =
      const drift.VerificationMeta('content');
  @override
  late final drift.GeneratedColumn<String> content =
      drift.GeneratedColumn<String>(
        'content',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _createdAtMeta =
      const drift.VerificationMeta('createdAt');
  @override
  late final drift.GeneratedColumn<int> createdAt = drift.GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<drift.GeneratedColumn> get $columns => [
    ncode,
    episode,
    position,
    content,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<Bookmark> instance, {
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
    if (data.containsKey('episode')) {
      context.handle(
        _episodeMeta,
        episode.isAcceptableOrUnknown(data['episode']!, _episodeMeta),
      );
    } else if (isInserting) {
      context.missing(_episodeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {ncode, episode, position};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      ncode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ncode'],
      )!,
      episode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends drift.DataClass implements drift.Insertable<Bookmark> {
  /// 小説のncode
  final String ncode;

  /// エピソード番号
  final int episode;

  /// ブックマークの位置
  final int position;

  /// ブックマークの内容
  final String? content;

  /// ブックマークの作成日時
  /// UNIXタイムスタンプ形式で���存される
  final int createdAt;
  const Bookmark({
    required this.ncode,
    required this.episode,
    required this.position,
    this.content,
    required this.createdAt,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['ncode'] = drift.Variable<String>(ncode);
    map['episode'] = drift.Variable<int>(episode);
    map['position'] = drift.Variable<int>(position);
    if (!nullToAbsent || content != null) {
      map['content'] = drift.Variable<String>(content);
    }
    map['created_at'] = drift.Variable<int>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      ncode: drift.Value(ncode),
      episode: drift.Value(episode),
      position: drift.Value(position),
      content: content == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(content),
      createdAt: drift.Value(createdAt),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      ncode: serializer.fromJson<String>(json['ncode']),
      episode: serializer.fromJson<int>(json['episode']),
      position: serializer.fromJson<int>(json['position']),
      content: serializer.fromJson<String?>(json['content']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'episode': serializer.toJson<int>(episode),
      'position': serializer.toJson<int>(position),
      'content': serializer.toJson<String?>(content),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Bookmark copyWith({
    String? ncode,
    int? episode,
    int? position,
    drift.Value<String?> content = const drift.Value.absent(),
    int? createdAt,
  }) => Bookmark(
    ncode: ncode ?? this.ncode,
    episode: episode ?? this.episode,
    position: position ?? this.position,
    content: content.present ? content.value : this.content,
    createdAt: createdAt ?? this.createdAt,
  );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      episode: data.episode.present ? data.episode.value : this.episode,
      position: data.position.present ? data.position.value : this.position,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('ncode: $ncode, ')
          ..write('episode: $episode, ')
          ..write('position: $position, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ncode, episode, position, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.ncode == this.ncode &&
          other.episode == this.episode &&
          other.position == this.position &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends drift.UpdateCompanion<Bookmark> {
  final drift.Value<String> ncode;
  final drift.Value<int> episode;
  final drift.Value<int> position;
  final drift.Value<String?> content;
  final drift.Value<int> createdAt;
  final drift.Value<int> rowid;
  const BookmarksCompanion({
    this.ncode = const drift.Value.absent(),
    this.episode = const drift.Value.absent(),
    this.position = const drift.Value.absent(),
    this.content = const drift.Value.absent(),
    this.createdAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  BookmarksCompanion.insert({
    required String ncode,
    required int episode,
    required int position,
    this.content = const drift.Value.absent(),
    required int createdAt,
    this.rowid = const drift.Value.absent(),
  }) : ncode = drift.Value(ncode),
       episode = drift.Value(episode),
       position = drift.Value(position),
       createdAt = drift.Value(createdAt);
  static drift.Insertable<Bookmark> custom({
    drift.Expression<String>? ncode,
    drift.Expression<int>? episode,
    drift.Expression<int>? position,
    drift.Expression<String>? content,
    drift.Expression<int>? createdAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (episode != null) 'episode': episode,
      if (position != null) 'position': position,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith({
    drift.Value<String>? ncode,
    drift.Value<int>? episode,
    drift.Value<int>? position,
    drift.Value<String?>? content,
    drift.Value<int>? createdAt,
    drift.Value<int>? rowid,
  }) {
    return BookmarksCompanion(
      ncode: ncode ?? this.ncode,
      episode: episode ?? this.episode,
      position: position ?? this.position,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (ncode.present) {
      map['ncode'] = drift.Variable<String>(ncode.value);
    }
    if (episode.present) {
      map['episode'] = drift.Variable<int>(episode.value);
    }
    if (position.present) {
      map['position'] = drift.Variable<int>(position.value);
    }
    if (content.present) {
      map['content'] = drift.Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = drift.Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('ncode: $ncode, ')
          ..write('episode: $episode, ')
          ..write('position: $position, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends drift.GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NovelsTable novels = $NovelsTable(this);
  late final $HistoryTable history = $HistoryTable(this);
  late final $EpisodesTable episodes = $EpisodesTable(this);
  late final $DownloadedNovelsTable downloadedNovels = $DownloadedNovelsTable(
    this,
  );
  late final $DownloadedEpisodesTable downloadedEpisodes =
      $DownloadedEpisodesTable(this);
  late final $LibraryNovelsTable libraryNovels = $LibraryNovelsTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  @override
  Iterable<drift.TableInfo<drift.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<drift.TableInfo<drift.Table, Object?>>();
  @override
  List<drift.DatabaseSchemaEntity> get allSchemaEntities => [
    novels,
    history,
    episodes,
    downloadedNovels,
    downloadedEpisodes,
    libraryNovels,
    bookmarks,
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
          (Novel, drift.BaseReferences<_$AppDatabase, $NovelsTable, Novel>),
          Novel,
          drift.PrefetchHooks Function()
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
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
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
      (Novel, drift.BaseReferences<_$AppDatabase, $NovelsTable, Novel>),
      Novel,
      drift.PrefetchHooks Function()
    >;
typedef $$HistoryTableCreateCompanionBuilder =
    HistoryCompanion Function({
      required String ncode,
      drift.Value<String?> title,
      drift.Value<String?> writer,
      drift.Value<int?> lastEpisode,
      required int viewedAt,
      drift.Value<int> updatedAt,
      drift.Value<int> rowid,
    });
typedef $$HistoryTableUpdateCompanionBuilder =
    HistoryCompanion Function({
      drift.Value<String> ncode,
      drift.Value<String?> title,
      drift.Value<String?> writer,
      drift.Value<int?> lastEpisode,
      drift.Value<int> viewedAt,
      drift.Value<int> updatedAt,
      drift.Value<int> rowid,
    });

class $$HistoryTableFilterComposer
    extends drift.Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableFilterComposer({
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

  drift.ColumnFilters<int> get lastEpisode => $composableBuilder(
    column: $table.lastEpisode,
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
}

class $$HistoryTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableOrderingComposer({
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

  drift.ColumnOrderings<int> get lastEpisode => $composableBuilder(
    column: $table.lastEpisode,
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
}

class $$HistoryTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableAnnotationComposer({
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

  drift.GeneratedColumn<int> get lastEpisode => $composableBuilder(
    column: $table.lastEpisode,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get viewedAt =>
      $composableBuilder(column: $table.viewedAt, builder: (column) => column);

  drift.GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HistoryTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $HistoryTable,
          HistoryData,
          $$HistoryTableFilterComposer,
          $$HistoryTableOrderingComposer,
          $$HistoryTableAnnotationComposer,
          $$HistoryTableCreateCompanionBuilder,
          $$HistoryTableUpdateCompanionBuilder,
          (
            HistoryData,
            drift.BaseReferences<_$AppDatabase, $HistoryTable, HistoryData>,
          ),
          HistoryData,
          drift.PrefetchHooks Function()
        > {
  $$HistoryTableTableManager(_$AppDatabase db, $HistoryTable table)
    : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<String?> title = const drift.Value.absent(),
                drift.Value<String?> writer = const drift.Value.absent(),
                drift.Value<int?> lastEpisode = const drift.Value.absent(),
                drift.Value<int> viewedAt = const drift.Value.absent(),
                drift.Value<int> updatedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => HistoryCompanion(
                ncode: ncode,
                title: title,
                writer: writer,
                lastEpisode: lastEpisode,
                viewedAt: viewedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                drift.Value<String?> title = const drift.Value.absent(),
                drift.Value<String?> writer = const drift.Value.absent(),
                drift.Value<int?> lastEpisode = const drift.Value.absent(),
                required int viewedAt,
                drift.Value<int> updatedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => HistoryCompanion.insert(
                ncode: ncode,
                title: title,
                writer: writer,
                lastEpisode: lastEpisode,
                viewedAt: viewedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoryTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $HistoryTable,
      HistoryData,
      $$HistoryTableFilterComposer,
      $$HistoryTableOrderingComposer,
      $$HistoryTableAnnotationComposer,
      $$HistoryTableCreateCompanionBuilder,
      $$HistoryTableUpdateCompanionBuilder,
      (
        HistoryData,
        drift.BaseReferences<_$AppDatabase, $HistoryTable, HistoryData>,
      ),
      HistoryData,
      drift.PrefetchHooks Function()
    >;
typedef $$EpisodesTableCreateCompanionBuilder =
    EpisodesCompanion Function({
      required String ncode,
      required int episode,
      drift.Value<String?> title,
      drift.Value<String?> content,
      drift.Value<int?> cachedAt,
      drift.Value<int> rowid,
    });
typedef $$EpisodesTableUpdateCompanionBuilder =
    EpisodesCompanion Function({
      drift.Value<String> ncode,
      drift.Value<int> episode,
      drift.Value<String?> title,
      drift.Value<String?> content,
      drift.Value<int?> cachedAt,
      drift.Value<int> rowid,
    });

class $$EpisodesTableFilterComposer
    extends drift.Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableFilterComposer({
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

  drift.ColumnFilters<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => drift.ColumnFilters(column),
  );
}

class $$EpisodesTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableOrderingComposer({
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

  drift.ColumnOrderings<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$EpisodesTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  drift.GeneratedColumn<int> get episode =>
      $composableBuilder(column: $table.episode, builder: (column) => column);

  drift.GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  drift.GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  drift.GeneratedColumn<int> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$EpisodesTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $EpisodesTable,
          Episode,
          $$EpisodesTableFilterComposer,
          $$EpisodesTableOrderingComposer,
          $$EpisodesTableAnnotationComposer,
          $$EpisodesTableCreateCompanionBuilder,
          $$EpisodesTableUpdateCompanionBuilder,
          (
            Episode,
            drift.BaseReferences<_$AppDatabase, $EpisodesTable, Episode>,
          ),
          Episode,
          drift.PrefetchHooks Function()
        > {
  $$EpisodesTableTableManager(_$AppDatabase db, $EpisodesTable table)
    : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<int> episode = const drift.Value.absent(),
                drift.Value<String?> title = const drift.Value.absent(),
                drift.Value<String?> content = const drift.Value.absent(),
                drift.Value<int?> cachedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => EpisodesCompanion(
                ncode: ncode,
                episode: episode,
                title: title,
                content: content,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                required int episode,
                drift.Value<String?> title = const drift.Value.absent(),
                drift.Value<String?> content = const drift.Value.absent(),
                drift.Value<int?> cachedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => EpisodesCompanion.insert(
                ncode: ncode,
                episode: episode,
                title: title,
                content: content,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EpisodesTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $EpisodesTable,
      Episode,
      $$EpisodesTableFilterComposer,
      $$EpisodesTableOrderingComposer,
      $$EpisodesTableAnnotationComposer,
      $$EpisodesTableCreateCompanionBuilder,
      $$EpisodesTableUpdateCompanionBuilder,
      (Episode, drift.BaseReferences<_$AppDatabase, $EpisodesTable, Episode>),
      Episode,
      drift.PrefetchHooks Function()
    >;
typedef $$DownloadedNovelsTableCreateCompanionBuilder =
    DownloadedNovelsCompanion Function({
      required String ncode,
      required int downloadStatus,
      required int downloadedAt,
      required int totalEpisodes,
      required int downloadedEpisodes,
      drift.Value<int> rowid,
    });
typedef $$DownloadedNovelsTableUpdateCompanionBuilder =
    DownloadedNovelsCompanion Function({
      drift.Value<String> ncode,
      drift.Value<int> downloadStatus,
      drift.Value<int> downloadedAt,
      drift.Value<int> totalEpisodes,
      drift.Value<int> downloadedEpisodes,
      drift.Value<int> rowid,
    });

class $$DownloadedNovelsTableFilterComposer
    extends drift.Composer<_$AppDatabase, $DownloadedNovelsTable> {
  $$DownloadedNovelsTableFilterComposer({
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

  drift.ColumnFilters<int> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get totalEpisodes => $composableBuilder(
    column: $table.totalEpisodes,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get downloadedEpisodes => $composableBuilder(
    column: $table.downloadedEpisodes,
    builder: (column) => drift.ColumnFilters(column),
  );
}

class $$DownloadedNovelsTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $DownloadedNovelsTable> {
  $$DownloadedNovelsTableOrderingComposer({
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

  drift.ColumnOrderings<int> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get totalEpisodes => $composableBuilder(
    column: $table.totalEpisodes,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get downloadedEpisodes => $composableBuilder(
    column: $table.downloadedEpisodes,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$DownloadedNovelsTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $DownloadedNovelsTable> {
  $$DownloadedNovelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  drift.GeneratedColumn<int> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get totalEpisodes => $composableBuilder(
    column: $table.totalEpisodes,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get downloadedEpisodes => $composableBuilder(
    column: $table.downloadedEpisodes,
    builder: (column) => column,
  );
}

class $$DownloadedNovelsTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $DownloadedNovelsTable,
          DownloadedNovel,
          $$DownloadedNovelsTableFilterComposer,
          $$DownloadedNovelsTableOrderingComposer,
          $$DownloadedNovelsTableAnnotationComposer,
          $$DownloadedNovelsTableCreateCompanionBuilder,
          $$DownloadedNovelsTableUpdateCompanionBuilder,
          (
            DownloadedNovel,
            drift.BaseReferences<
              _$AppDatabase,
              $DownloadedNovelsTable,
              DownloadedNovel
            >,
          ),
          DownloadedNovel,
          drift.PrefetchHooks Function()
        > {
  $$DownloadedNovelsTableTableManager(
    _$AppDatabase db,
    $DownloadedNovelsTable table,
  ) : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedNovelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedNovelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadedNovelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<int> downloadStatus = const drift.Value.absent(),
                drift.Value<int> downloadedAt = const drift.Value.absent(),
                drift.Value<int> totalEpisodes = const drift.Value.absent(),
                drift.Value<int> downloadedEpisodes =
                    const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => DownloadedNovelsCompanion(
                ncode: ncode,
                downloadStatus: downloadStatus,
                downloadedAt: downloadedAt,
                totalEpisodes: totalEpisodes,
                downloadedEpisodes: downloadedEpisodes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                required int downloadStatus,
                required int downloadedAt,
                required int totalEpisodes,
                required int downloadedEpisodes,
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => DownloadedNovelsCompanion.insert(
                ncode: ncode,
                downloadStatus: downloadStatus,
                downloadedAt: downloadedAt,
                totalEpisodes: totalEpisodes,
                downloadedEpisodes: downloadedEpisodes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadedNovelsTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $DownloadedNovelsTable,
      DownloadedNovel,
      $$DownloadedNovelsTableFilterComposer,
      $$DownloadedNovelsTableOrderingComposer,
      $$DownloadedNovelsTableAnnotationComposer,
      $$DownloadedNovelsTableCreateCompanionBuilder,
      $$DownloadedNovelsTableUpdateCompanionBuilder,
      (
        DownloadedNovel,
        drift.BaseReferences<
          _$AppDatabase,
          $DownloadedNovelsTable,
          DownloadedNovel
        >,
      ),
      DownloadedNovel,
      drift.PrefetchHooks Function()
    >;
typedef $$DownloadedEpisodesTableCreateCompanionBuilder =
    DownloadedEpisodesCompanion Function({
      required String ncode,
      required int episode,
      required List<NovelContentElement> content,
      required int downloadedAt,
      drift.Value<int> status,
      drift.Value<String?> errorMessage,
      drift.Value<int?> lastAttemptAt,
      drift.Value<int> rowid,
    });
typedef $$DownloadedEpisodesTableUpdateCompanionBuilder =
    DownloadedEpisodesCompanion Function({
      drift.Value<String> ncode,
      drift.Value<int> episode,
      drift.Value<List<NovelContentElement>> content,
      drift.Value<int> downloadedAt,
      drift.Value<int> status,
      drift.Value<String?> errorMessage,
      drift.Value<int?> lastAttemptAt,
      drift.Value<int> rowid,
    });

class $$DownloadedEpisodesTableFilterComposer
    extends drift.Composer<_$AppDatabase, $DownloadedEpisodesTable> {
  $$DownloadedEpisodesTableFilterComposer({
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

  drift.ColumnFilters<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnWithTypeConverterFilters<
    List<NovelContentElement>,
    List<NovelContentElement>,
    String
  >
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => drift.ColumnWithTypeConverterFilters(column),
  );

  drift.ColumnFilters<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => drift.ColumnFilters(column),
  );
}

class $$DownloadedEpisodesTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $DownloadedEpisodesTable> {
  $$DownloadedEpisodesTableOrderingComposer({
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

  drift.ColumnOrderings<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$DownloadedEpisodesTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $DownloadedEpisodesTable> {
  $$DownloadedEpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  drift.GeneratedColumn<int> get episode =>
      $composableBuilder(column: $table.episode, builder: (column) => column);

  drift.GeneratedColumnWithTypeConverter<List<NovelContentElement>, String>
  get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  drift.GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  drift.GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );
}

class $$DownloadedEpisodesTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $DownloadedEpisodesTable,
          DownloadedEpisode,
          $$DownloadedEpisodesTableFilterComposer,
          $$DownloadedEpisodesTableOrderingComposer,
          $$DownloadedEpisodesTableAnnotationComposer,
          $$DownloadedEpisodesTableCreateCompanionBuilder,
          $$DownloadedEpisodesTableUpdateCompanionBuilder,
          (
            DownloadedEpisode,
            drift.BaseReferences<
              _$AppDatabase,
              $DownloadedEpisodesTable,
              DownloadedEpisode
            >,
          ),
          DownloadedEpisode,
          drift.PrefetchHooks Function()
        > {
  $$DownloadedEpisodesTableTableManager(
    _$AppDatabase db,
    $DownloadedEpisodesTable table,
  ) : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedEpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedEpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadedEpisodesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<int> episode = const drift.Value.absent(),
                drift.Value<List<NovelContentElement>> content =
                    const drift.Value.absent(),
                drift.Value<int> downloadedAt = const drift.Value.absent(),
                drift.Value<int> status = const drift.Value.absent(),
                drift.Value<String?> errorMessage = const drift.Value.absent(),
                drift.Value<int?> lastAttemptAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => DownloadedEpisodesCompanion(
                ncode: ncode,
                episode: episode,
                content: content,
                downloadedAt: downloadedAt,
                status: status,
                errorMessage: errorMessage,
                lastAttemptAt: lastAttemptAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                required int episode,
                required List<NovelContentElement> content,
                required int downloadedAt,
                drift.Value<int> status = const drift.Value.absent(),
                drift.Value<String?> errorMessage = const drift.Value.absent(),
                drift.Value<int?> lastAttemptAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => DownloadedEpisodesCompanion.insert(
                ncode: ncode,
                episode: episode,
                content: content,
                downloadedAt: downloadedAt,
                status: status,
                errorMessage: errorMessage,
                lastAttemptAt: lastAttemptAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadedEpisodesTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $DownloadedEpisodesTable,
      DownloadedEpisode,
      $$DownloadedEpisodesTableFilterComposer,
      $$DownloadedEpisodesTableOrderingComposer,
      $$DownloadedEpisodesTableAnnotationComposer,
      $$DownloadedEpisodesTableCreateCompanionBuilder,
      $$DownloadedEpisodesTableUpdateCompanionBuilder,
      (
        DownloadedEpisode,
        drift.BaseReferences<
          _$AppDatabase,
          $DownloadedEpisodesTable,
          DownloadedEpisode
        >,
      ),
      DownloadedEpisode,
      drift.PrefetchHooks Function()
    >;
typedef $$LibraryNovelsTableCreateCompanionBuilder =
    LibraryNovelsCompanion Function({
      required String ncode,
      drift.Value<String?> title,
      drift.Value<String?> writer,
      drift.Value<String?> story,
      drift.Value<int?> novelType,
      drift.Value<int?> end,
      drift.Value<int?> generalAllNo,
      drift.Value<String?> novelUpdatedAt,
      required int addedAt,
      drift.Value<int> rowid,
    });
typedef $$LibraryNovelsTableUpdateCompanionBuilder =
    LibraryNovelsCompanion Function({
      drift.Value<String> ncode,
      drift.Value<String?> title,
      drift.Value<String?> writer,
      drift.Value<String?> story,
      drift.Value<int?> novelType,
      drift.Value<int?> end,
      drift.Value<int?> generalAllNo,
      drift.Value<String?> novelUpdatedAt,
      drift.Value<int> addedAt,
      drift.Value<int> rowid,
    });

class $$LibraryNovelsTableFilterComposer
    extends drift.Composer<_$AppDatabase, $LibraryNovelsTable> {
  $$LibraryNovelsTableFilterComposer({
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

  drift.ColumnFilters<int> get generalAllNo => $composableBuilder(
    column: $table.generalAllNo,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get novelUpdatedAt => $composableBuilder(
    column: $table.novelUpdatedAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => drift.ColumnFilters(column),
  );
}

class $$LibraryNovelsTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $LibraryNovelsTable> {
  $$LibraryNovelsTableOrderingComposer({
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

  drift.ColumnOrderings<int> get generalAllNo => $composableBuilder(
    column: $table.generalAllNo,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get novelUpdatedAt => $composableBuilder(
    column: $table.novelUpdatedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$LibraryNovelsTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $LibraryNovelsTable> {
  $$LibraryNovelsTableAnnotationComposer({
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

  drift.GeneratedColumn<int> get generalAllNo => $composableBuilder(
    column: $table.generalAllNo,
    builder: (column) => column,
  );

  drift.GeneratedColumn<String> get novelUpdatedAt => $composableBuilder(
    column: $table.novelUpdatedAt,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$LibraryNovelsTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $LibraryNovelsTable,
          LibraryNovel,
          $$LibraryNovelsTableFilterComposer,
          $$LibraryNovelsTableOrderingComposer,
          $$LibraryNovelsTableAnnotationComposer,
          $$LibraryNovelsTableCreateCompanionBuilder,
          $$LibraryNovelsTableUpdateCompanionBuilder,
          (
            LibraryNovel,
            drift.BaseReferences<
              _$AppDatabase,
              $LibraryNovelsTable,
              LibraryNovel
            >,
          ),
          LibraryNovel,
          drift.PrefetchHooks Function()
        > {
  $$LibraryNovelsTableTableManager(_$AppDatabase db, $LibraryNovelsTable table)
    : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryNovelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryNovelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryNovelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<String?> title = const drift.Value.absent(),
                drift.Value<String?> writer = const drift.Value.absent(),
                drift.Value<String?> story = const drift.Value.absent(),
                drift.Value<int?> novelType = const drift.Value.absent(),
                drift.Value<int?> end = const drift.Value.absent(),
                drift.Value<int?> generalAllNo = const drift.Value.absent(),
                drift.Value<String?> novelUpdatedAt =
                    const drift.Value.absent(),
                drift.Value<int> addedAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => LibraryNovelsCompanion(
                ncode: ncode,
                title: title,
                writer: writer,
                story: story,
                novelType: novelType,
                end: end,
                generalAllNo: generalAllNo,
                novelUpdatedAt: novelUpdatedAt,
                addedAt: addedAt,
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
                drift.Value<int?> generalAllNo = const drift.Value.absent(),
                drift.Value<String?> novelUpdatedAt =
                    const drift.Value.absent(),
                required int addedAt,
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => LibraryNovelsCompanion.insert(
                ncode: ncode,
                title: title,
                writer: writer,
                story: story,
                novelType: novelType,
                end: end,
                generalAllNo: generalAllNo,
                novelUpdatedAt: novelUpdatedAt,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibraryNovelsTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $LibraryNovelsTable,
      LibraryNovel,
      $$LibraryNovelsTableFilterComposer,
      $$LibraryNovelsTableOrderingComposer,
      $$LibraryNovelsTableAnnotationComposer,
      $$LibraryNovelsTableCreateCompanionBuilder,
      $$LibraryNovelsTableUpdateCompanionBuilder,
      (
        LibraryNovel,
        drift.BaseReferences<_$AppDatabase, $LibraryNovelsTable, LibraryNovel>,
      ),
      LibraryNovel,
      drift.PrefetchHooks Function()
    >;
typedef $$BookmarksTableCreateCompanionBuilder =
    BookmarksCompanion Function({
      required String ncode,
      required int episode,
      required int position,
      drift.Value<String?> content,
      required int createdAt,
      drift.Value<int> rowid,
    });
typedef $$BookmarksTableUpdateCompanionBuilder =
    BookmarksCompanion Function({
      drift.Value<String> ncode,
      drift.Value<int> episode,
      drift.Value<int> position,
      drift.Value<String?> content,
      drift.Value<int> createdAt,
      drift.Value<int> rowid,
    });

class $$BookmarksTableFilterComposer
    extends drift.Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
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

  drift.ColumnFilters<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => drift.ColumnFilters(column),
  );
}

class $$BookmarksTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
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

  drift.ColumnOrderings<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$BookmarksTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  drift.GeneratedColumn<int> get episode =>
      $composableBuilder(column: $table.episode, builder: (column) => column);

  drift.GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  drift.GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  drift.GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BookmarksTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (
            Bookmark,
            drift.BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>,
          ),
          Bookmark,
          drift.PrefetchHooks Function()
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> ncode = const drift.Value.absent(),
                drift.Value<int> episode = const drift.Value.absent(),
                drift.Value<int> position = const drift.Value.absent(),
                drift.Value<String?> content = const drift.Value.absent(),
                drift.Value<int> createdAt = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => BookmarksCompanion(
                ncode: ncode,
                episode: episode,
                position: position,
                content: content,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                required int episode,
                required int position,
                drift.Value<String?> content = const drift.Value.absent(),
                required int createdAt,
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => BookmarksCompanion.insert(
                ncode: ncode,
                episode: episode,
                position: position,
                content: content,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (
        Bookmark,
        drift.BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>,
      ),
      Bookmark,
      drift.PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NovelsTableTableManager get novels =>
      $$NovelsTableTableManager(_db, _db.novels);
  $$HistoryTableTableManager get history =>
      $$HistoryTableTableManager(_db, _db.history);
  $$EpisodesTableTableManager get episodes =>
      $$EpisodesTableTableManager(_db, _db.episodes);
  $$DownloadedNovelsTableTableManager get downloadedNovels =>
      $$DownloadedNovelsTableTableManager(_db, _db.downloadedNovels);
  $$DownloadedEpisodesTableTableManager get downloadedEpisodes =>
      $$DownloadedEpisodesTableTableManager(_db, _db.downloadedEpisodes);
  $$LibraryNovelsTableTableManager get libraryNovels =>
      $$LibraryNovelsTableTableManager(_db, _db.libraryNovels);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
}
