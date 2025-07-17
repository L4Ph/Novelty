// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NovelsTable extends Novels with TableInfo<$NovelsTable, Novel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NovelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ncodeMeta = const VerificationMeta('ncode');
  @override
  late final GeneratedColumn<String> ncode = GeneratedColumn<String>(
    'ncode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _writerMeta = const VerificationMeta('writer');
  @override
  late final GeneratedColumn<String> writer = GeneratedColumn<String>(
    'writer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storyMeta = const VerificationMeta('story');
  @override
  late final GeneratedColumn<String> story = GeneratedColumn<String>(
    'story',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _novelTypeMeta = const VerificationMeta(
    'novelType',
  );
  @override
  late final GeneratedColumn<int> novelType = GeneratedColumn<int>(
    'novel_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<int> end = GeneratedColumn<int>(
    'end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isr15Meta = const VerificationMeta('isr15');
  @override
  late final GeneratedColumn<int> isr15 = GeneratedColumn<int>(
    'isr15',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isblMeta = const VerificationMeta('isbl');
  @override
  late final GeneratedColumn<int> isbl = GeneratedColumn<int>(
    'isbl',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isglMeta = const VerificationMeta('isgl');
  @override
  late final GeneratedColumn<int> isgl = GeneratedColumn<int>(
    'isgl',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iszankokuMeta = const VerificationMeta(
    'iszankoku',
  );
  @override
  late final GeneratedColumn<int> iszankoku = GeneratedColumn<int>(
    'iszankoku',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _istenseiMeta = const VerificationMeta(
    'istensei',
  );
  @override
  late final GeneratedColumn<int> istensei = GeneratedColumn<int>(
    'istensei',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _istenniMeta = const VerificationMeta(
    'istenni',
  );
  @override
  late final GeneratedColumn<int> istenni = GeneratedColumn<int>(
    'istenni',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keywordMeta = const VerificationMeta(
    'keyword',
  );
  @override
  late final GeneratedColumn<String> keyword = GeneratedColumn<String>(
    'keyword',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generalFirstupMeta = const VerificationMeta(
    'generalFirstup',
  );
  @override
  late final GeneratedColumn<int> generalFirstup = GeneratedColumn<int>(
    'general_firstup',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generalLastupMeta = const VerificationMeta(
    'generalLastup',
  );
  @override
  late final GeneratedColumn<int> generalLastup = GeneratedColumn<int>(
    'general_lastup',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _globalPointMeta = const VerificationMeta(
    'globalPoint',
  );
  @override
  late final GeneratedColumn<int> globalPoint = GeneratedColumn<int>(
    'global_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favMeta = const VerificationMeta('fav');
  @override
  late final GeneratedColumn<int> fav = GeneratedColumn<int>(
    'fav',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewCountMeta = const VerificationMeta(
    'reviewCount',
  );
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
    'review_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rateCountMeta = const VerificationMeta(
    'rateCount',
  );
  @override
  late final GeneratedColumn<int> rateCount = GeneratedColumn<int>(
    'rate_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allPointMeta = const VerificationMeta(
    'allPoint',
  );
  @override
  late final GeneratedColumn<int> allPoint = GeneratedColumn<int>(
    'all_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointCountMeta = const VerificationMeta(
    'pointCount',
  );
  @override
  late final GeneratedColumn<int> pointCount = GeneratedColumn<int>(
    'point_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyPointMeta = const VerificationMeta(
    'dailyPoint',
  );
  @override
  late final GeneratedColumn<int> dailyPoint = GeneratedColumn<int>(
    'daily_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyPointMeta = const VerificationMeta(
    'weeklyPoint',
  );
  @override
  late final GeneratedColumn<int> weeklyPoint = GeneratedColumn<int>(
    'weekly_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyPointMeta = const VerificationMeta(
    'monthlyPoint',
  );
  @override
  late final GeneratedColumn<int> monthlyPoint = GeneratedColumn<int>(
    'monthly_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quarterPointMeta = const VerificationMeta(
    'quarterPoint',
  );
  @override
  late final GeneratedColumn<int> quarterPoint = GeneratedColumn<int>(
    'quarter_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearlyPointMeta = const VerificationMeta(
    'yearlyPoint',
  );
  @override
  late final GeneratedColumn<int> yearlyPoint = GeneratedColumn<int>(
    'yearly_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generalAllNoMeta = const VerificationMeta(
    'generalAllNo',
  );
  @override
  late final GeneratedColumn<int> generalAllNo = GeneratedColumn<int>(
    'general_all_no',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _novelUpdatedAtMeta = const VerificationMeta(
    'novelUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> novelUpdatedAt = GeneratedColumn<String>(
    'novel_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<int> cachedAt = GeneratedColumn<int>(
    'cached_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ncode,
    title,
    writer,
    story,
    novelType,
    end,
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
  VerificationContext validateIntegrity(
    Insertable<Novel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
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
  Set<GeneratedColumn> get $primaryKey => {ncode};
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

class Novel extends DataClass implements Insertable<Novel> {
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
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ncode'] = Variable<String>(ncode);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || writer != null) {
      map['writer'] = Variable<String>(writer);
    }
    if (!nullToAbsent || story != null) {
      map['story'] = Variable<String>(story);
    }
    if (!nullToAbsent || novelType != null) {
      map['novel_type'] = Variable<int>(novelType);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<int>(end);
    }
    if (!nullToAbsent || isr15 != null) {
      map['isr15'] = Variable<int>(isr15);
    }
    if (!nullToAbsent || isbl != null) {
      map['isbl'] = Variable<int>(isbl);
    }
    if (!nullToAbsent || isgl != null) {
      map['isgl'] = Variable<int>(isgl);
    }
    if (!nullToAbsent || iszankoku != null) {
      map['iszankoku'] = Variable<int>(iszankoku);
    }
    if (!nullToAbsent || istensei != null) {
      map['istensei'] = Variable<int>(istensei);
    }
    if (!nullToAbsent || istenni != null) {
      map['istenni'] = Variable<int>(istenni);
    }
    if (!nullToAbsent || keyword != null) {
      map['keyword'] = Variable<String>(keyword);
    }
    if (!nullToAbsent || generalFirstup != null) {
      map['general_firstup'] = Variable<int>(generalFirstup);
    }
    if (!nullToAbsent || generalLastup != null) {
      map['general_lastup'] = Variable<int>(generalLastup);
    }
    if (!nullToAbsent || globalPoint != null) {
      map['global_point'] = Variable<int>(globalPoint);
    }
    if (!nullToAbsent || fav != null) {
      map['fav'] = Variable<int>(fav);
    }
    if (!nullToAbsent || reviewCount != null) {
      map['review_count'] = Variable<int>(reviewCount);
    }
    if (!nullToAbsent || rateCount != null) {
      map['rate_count'] = Variable<int>(rateCount);
    }
    if (!nullToAbsent || allPoint != null) {
      map['all_point'] = Variable<int>(allPoint);
    }
    if (!nullToAbsent || pointCount != null) {
      map['point_count'] = Variable<int>(pointCount);
    }
    if (!nullToAbsent || dailyPoint != null) {
      map['daily_point'] = Variable<int>(dailyPoint);
    }
    if (!nullToAbsent || weeklyPoint != null) {
      map['weekly_point'] = Variable<int>(weeklyPoint);
    }
    if (!nullToAbsent || monthlyPoint != null) {
      map['monthly_point'] = Variable<int>(monthlyPoint);
    }
    if (!nullToAbsent || quarterPoint != null) {
      map['quarter_point'] = Variable<int>(quarterPoint);
    }
    if (!nullToAbsent || yearlyPoint != null) {
      map['yearly_point'] = Variable<int>(yearlyPoint);
    }
    if (!nullToAbsent || generalAllNo != null) {
      map['general_all_no'] = Variable<int>(generalAllNo);
    }
    if (!nullToAbsent || novelUpdatedAt != null) {
      map['novel_updated_at'] = Variable<String>(novelUpdatedAt);
    }
    if (!nullToAbsent || cachedAt != null) {
      map['cached_at'] = Variable<int>(cachedAt);
    }
    return map;
  }

  NovelsCompanion toCompanion(bool nullToAbsent) {
    return NovelsCompanion(
      ncode: Value(ncode),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      writer: writer == null && nullToAbsent
          ? const Value.absent()
          : Value(writer),
      story: story == null && nullToAbsent
          ? const Value.absent()
          : Value(story),
      novelType: novelType == null && nullToAbsent
          ? const Value.absent()
          : Value(novelType),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      isr15: isr15 == null && nullToAbsent
          ? const Value.absent()
          : Value(isr15),
      isbl: isbl == null && nullToAbsent ? const Value.absent() : Value(isbl),
      isgl: isgl == null && nullToAbsent ? const Value.absent() : Value(isgl),
      iszankoku: iszankoku == null && nullToAbsent
          ? const Value.absent()
          : Value(iszankoku),
      istensei: istensei == null && nullToAbsent
          ? const Value.absent()
          : Value(istensei),
      istenni: istenni == null && nullToAbsent
          ? const Value.absent()
          : Value(istenni),
      keyword: keyword == null && nullToAbsent
          ? const Value.absent()
          : Value(keyword),
      generalFirstup: generalFirstup == null && nullToAbsent
          ? const Value.absent()
          : Value(generalFirstup),
      generalLastup: generalLastup == null && nullToAbsent
          ? const Value.absent()
          : Value(generalLastup),
      globalPoint: globalPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(globalPoint),
      fav: fav == null && nullToAbsent ? const Value.absent() : Value(fav),
      reviewCount: reviewCount == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewCount),
      rateCount: rateCount == null && nullToAbsent
          ? const Value.absent()
          : Value(rateCount),
      allPoint: allPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(allPoint),
      pointCount: pointCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pointCount),
      dailyPoint: dailyPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyPoint),
      weeklyPoint: weeklyPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyPoint),
      monthlyPoint: monthlyPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyPoint),
      quarterPoint: quarterPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(quarterPoint),
      yearlyPoint: yearlyPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(yearlyPoint),
      generalAllNo: generalAllNo == null && nullToAbsent
          ? const Value.absent()
          : Value(generalAllNo),
      novelUpdatedAt: novelUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(novelUpdatedAt),
      cachedAt: cachedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedAt),
    );
  }

  factory Novel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Novel(
      ncode: serializer.fromJson<String>(json['ncode']),
      title: serializer.fromJson<String?>(json['title']),
      writer: serializer.fromJson<String?>(json['writer']),
      story: serializer.fromJson<String?>(json['story']),
      novelType: serializer.fromJson<int?>(json['novelType']),
      end: serializer.fromJson<int?>(json['end']),
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'title': serializer.toJson<String?>(title),
      'writer': serializer.toJson<String?>(writer),
      'story': serializer.toJson<String?>(story),
      'novelType': serializer.toJson<int?>(novelType),
      'end': serializer.toJson<int?>(end),
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
    Value<String?> title = const Value.absent(),
    Value<String?> writer = const Value.absent(),
    Value<String?> story = const Value.absent(),
    Value<int?> novelType = const Value.absent(),
    Value<int?> end = const Value.absent(),
    Value<int?> isr15 = const Value.absent(),
    Value<int?> isbl = const Value.absent(),
    Value<int?> isgl = const Value.absent(),
    Value<int?> iszankoku = const Value.absent(),
    Value<int?> istensei = const Value.absent(),
    Value<int?> istenni = const Value.absent(),
    Value<String?> keyword = const Value.absent(),
    Value<int?> generalFirstup = const Value.absent(),
    Value<int?> generalLastup = const Value.absent(),
    Value<int?> globalPoint = const Value.absent(),
    Value<int?> fav = const Value.absent(),
    Value<int?> reviewCount = const Value.absent(),
    Value<int?> rateCount = const Value.absent(),
    Value<int?> allPoint = const Value.absent(),
    Value<int?> pointCount = const Value.absent(),
    Value<int?> dailyPoint = const Value.absent(),
    Value<int?> weeklyPoint = const Value.absent(),
    Value<int?> monthlyPoint = const Value.absent(),
    Value<int?> quarterPoint = const Value.absent(),
    Value<int?> yearlyPoint = const Value.absent(),
    Value<int?> generalAllNo = const Value.absent(),
    Value<String?> novelUpdatedAt = const Value.absent(),
    Value<int?> cachedAt = const Value.absent(),
  }) => Novel(
    ncode: ncode ?? this.ncode,
    title: title.present ? title.value : this.title,
    writer: writer.present ? writer.value : this.writer,
    story: story.present ? story.value : this.story,
    novelType: novelType.present ? novelType.value : this.novelType,
    end: end.present ? end.value : this.end,
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

class NovelsCompanion extends UpdateCompanion<Novel> {
  final Value<String> ncode;
  final Value<String?> title;
  final Value<String?> writer;
  final Value<String?> story;
  final Value<int?> novelType;
  final Value<int?> end;
  final Value<int?> isr15;
  final Value<int?> isbl;
  final Value<int?> isgl;
  final Value<int?> iszankoku;
  final Value<int?> istensei;
  final Value<int?> istenni;
  final Value<String?> keyword;
  final Value<int?> generalFirstup;
  final Value<int?> generalLastup;
  final Value<int?> globalPoint;
  final Value<int?> fav;
  final Value<int?> reviewCount;
  final Value<int?> rateCount;
  final Value<int?> allPoint;
  final Value<int?> pointCount;
  final Value<int?> dailyPoint;
  final Value<int?> weeklyPoint;
  final Value<int?> monthlyPoint;
  final Value<int?> quarterPoint;
  final Value<int?> yearlyPoint;
  final Value<int?> generalAllNo;
  final Value<String?> novelUpdatedAt;
  final Value<int?> cachedAt;
  final Value<int> rowid;
  const NovelsCompanion({
    this.ncode = const Value.absent(),
    this.title = const Value.absent(),
    this.writer = const Value.absent(),
    this.story = const Value.absent(),
    this.novelType = const Value.absent(),
    this.end = const Value.absent(),
    this.isr15 = const Value.absent(),
    this.isbl = const Value.absent(),
    this.isgl = const Value.absent(),
    this.iszankoku = const Value.absent(),
    this.istensei = const Value.absent(),
    this.istenni = const Value.absent(),
    this.keyword = const Value.absent(),
    this.generalFirstup = const Value.absent(),
    this.generalLastup = const Value.absent(),
    this.globalPoint = const Value.absent(),
    this.fav = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.rateCount = const Value.absent(),
    this.allPoint = const Value.absent(),
    this.pointCount = const Value.absent(),
    this.dailyPoint = const Value.absent(),
    this.weeklyPoint = const Value.absent(),
    this.monthlyPoint = const Value.absent(),
    this.quarterPoint = const Value.absent(),
    this.yearlyPoint = const Value.absent(),
    this.generalAllNo = const Value.absent(),
    this.novelUpdatedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NovelsCompanion.insert({
    required String ncode,
    this.title = const Value.absent(),
    this.writer = const Value.absent(),
    this.story = const Value.absent(),
    this.novelType = const Value.absent(),
    this.end = const Value.absent(),
    this.isr15 = const Value.absent(),
    this.isbl = const Value.absent(),
    this.isgl = const Value.absent(),
    this.iszankoku = const Value.absent(),
    this.istensei = const Value.absent(),
    this.istenni = const Value.absent(),
    this.keyword = const Value.absent(),
    this.generalFirstup = const Value.absent(),
    this.generalLastup = const Value.absent(),
    this.globalPoint = const Value.absent(),
    this.fav = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.rateCount = const Value.absent(),
    this.allPoint = const Value.absent(),
    this.pointCount = const Value.absent(),
    this.dailyPoint = const Value.absent(),
    this.weeklyPoint = const Value.absent(),
    this.monthlyPoint = const Value.absent(),
    this.quarterPoint = const Value.absent(),
    this.yearlyPoint = const Value.absent(),
    this.generalAllNo = const Value.absent(),
    this.novelUpdatedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ncode = Value(ncode);
  static Insertable<Novel> custom({
    Expression<String>? ncode,
    Expression<String>? title,
    Expression<String>? writer,
    Expression<String>? story,
    Expression<int>? novelType,
    Expression<int>? end,
    Expression<int>? isr15,
    Expression<int>? isbl,
    Expression<int>? isgl,
    Expression<int>? iszankoku,
    Expression<int>? istensei,
    Expression<int>? istenni,
    Expression<String>? keyword,
    Expression<int>? generalFirstup,
    Expression<int>? generalLastup,
    Expression<int>? globalPoint,
    Expression<int>? fav,
    Expression<int>? reviewCount,
    Expression<int>? rateCount,
    Expression<int>? allPoint,
    Expression<int>? pointCount,
    Expression<int>? dailyPoint,
    Expression<int>? weeklyPoint,
    Expression<int>? monthlyPoint,
    Expression<int>? quarterPoint,
    Expression<int>? yearlyPoint,
    Expression<int>? generalAllNo,
    Expression<String>? novelUpdatedAt,
    Expression<int>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (title != null) 'title': title,
      if (writer != null) 'writer': writer,
      if (story != null) 'story': story,
      if (novelType != null) 'novel_type': novelType,
      if (end != null) 'end': end,
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
    Value<String>? ncode,
    Value<String?>? title,
    Value<String?>? writer,
    Value<String?>? story,
    Value<int?>? novelType,
    Value<int?>? end,
    Value<int?>? isr15,
    Value<int?>? isbl,
    Value<int?>? isgl,
    Value<int?>? iszankoku,
    Value<int?>? istensei,
    Value<int?>? istenni,
    Value<String?>? keyword,
    Value<int?>? generalFirstup,
    Value<int?>? generalLastup,
    Value<int?>? globalPoint,
    Value<int?>? fav,
    Value<int?>? reviewCount,
    Value<int?>? rateCount,
    Value<int?>? allPoint,
    Value<int?>? pointCount,
    Value<int?>? dailyPoint,
    Value<int?>? weeklyPoint,
    Value<int?>? monthlyPoint,
    Value<int?>? quarterPoint,
    Value<int?>? yearlyPoint,
    Value<int?>? generalAllNo,
    Value<String?>? novelUpdatedAt,
    Value<int?>? cachedAt,
    Value<int>? rowid,
  }) {
    return NovelsCompanion(
      ncode: ncode ?? this.ncode,
      title: title ?? this.title,
      writer: writer ?? this.writer,
      story: story ?? this.story,
      novelType: novelType ?? this.novelType,
      end: end ?? this.end,
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
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ncode.present) {
      map['ncode'] = Variable<String>(ncode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (writer.present) {
      map['writer'] = Variable<String>(writer.value);
    }
    if (story.present) {
      map['story'] = Variable<String>(story.value);
    }
    if (novelType.present) {
      map['novel_type'] = Variable<int>(novelType.value);
    }
    if (end.present) {
      map['end'] = Variable<int>(end.value);
    }
    if (isr15.present) {
      map['isr15'] = Variable<int>(isr15.value);
    }
    if (isbl.present) {
      map['isbl'] = Variable<int>(isbl.value);
    }
    if (isgl.present) {
      map['isgl'] = Variable<int>(isgl.value);
    }
    if (iszankoku.present) {
      map['iszankoku'] = Variable<int>(iszankoku.value);
    }
    if (istensei.present) {
      map['istensei'] = Variable<int>(istensei.value);
    }
    if (istenni.present) {
      map['istenni'] = Variable<int>(istenni.value);
    }
    if (keyword.present) {
      map['keyword'] = Variable<String>(keyword.value);
    }
    if (generalFirstup.present) {
      map['general_firstup'] = Variable<int>(generalFirstup.value);
    }
    if (generalLastup.present) {
      map['general_lastup'] = Variable<int>(generalLastup.value);
    }
    if (globalPoint.present) {
      map['global_point'] = Variable<int>(globalPoint.value);
    }
    if (fav.present) {
      map['fav'] = Variable<int>(fav.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (rateCount.present) {
      map['rate_count'] = Variable<int>(rateCount.value);
    }
    if (allPoint.present) {
      map['all_point'] = Variable<int>(allPoint.value);
    }
    if (pointCount.present) {
      map['point_count'] = Variable<int>(pointCount.value);
    }
    if (dailyPoint.present) {
      map['daily_point'] = Variable<int>(dailyPoint.value);
    }
    if (weeklyPoint.present) {
      map['weekly_point'] = Variable<int>(weeklyPoint.value);
    }
    if (monthlyPoint.present) {
      map['monthly_point'] = Variable<int>(monthlyPoint.value);
    }
    if (quarterPoint.present) {
      map['quarter_point'] = Variable<int>(quarterPoint.value);
    }
    if (yearlyPoint.present) {
      map['yearly_point'] = Variable<int>(yearlyPoint.value);
    }
    if (generalAllNo.present) {
      map['general_all_no'] = Variable<int>(generalAllNo.value);
    }
    if (novelUpdatedAt.present) {
      map['novel_updated_at'] = Variable<String>(novelUpdatedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<int>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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

class $HistoryTable extends History with TableInfo<$HistoryTable, HistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ncodeMeta = const VerificationMeta('ncode');
  @override
  late final GeneratedColumn<String> ncode = GeneratedColumn<String>(
    'ncode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _writerMeta = const VerificationMeta('writer');
  @override
  late final GeneratedColumn<String> writer = GeneratedColumn<String>(
    'writer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastEpisodeMeta = const VerificationMeta(
    'lastEpisode',
  );
  @override
  late final GeneratedColumn<int> lastEpisode = GeneratedColumn<int>(
    'last_episode',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _viewedAtMeta = const VerificationMeta(
    'viewedAt',
  );
  @override
  late final GeneratedColumn<int> viewedAt = GeneratedColumn<int>(
    'viewed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ncode,
    title,
    writer,
    lastEpisode,
    viewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ncode};
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
    );
  }

  @override
  $HistoryTable createAlias(String alias) {
    return $HistoryTable(attachedDatabase, alias);
  }
}

class HistoryData extends DataClass implements Insertable<HistoryData> {
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
  const HistoryData({
    required this.ncode,
    this.title,
    this.writer,
    this.lastEpisode,
    required this.viewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ncode'] = Variable<String>(ncode);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || writer != null) {
      map['writer'] = Variable<String>(writer);
    }
    if (!nullToAbsent || lastEpisode != null) {
      map['last_episode'] = Variable<int>(lastEpisode);
    }
    map['viewed_at'] = Variable<int>(viewedAt);
    return map;
  }

  HistoryCompanion toCompanion(bool nullToAbsent) {
    return HistoryCompanion(
      ncode: Value(ncode),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      writer: writer == null && nullToAbsent
          ? const Value.absent()
          : Value(writer),
      lastEpisode: lastEpisode == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEpisode),
      viewedAt: Value(viewedAt),
    );
  }

  factory HistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryData(
      ncode: serializer.fromJson<String>(json['ncode']),
      title: serializer.fromJson<String?>(json['title']),
      writer: serializer.fromJson<String?>(json['writer']),
      lastEpisode: serializer.fromJson<int?>(json['lastEpisode']),
      viewedAt: serializer.fromJson<int>(json['viewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'title': serializer.toJson<String?>(title),
      'writer': serializer.toJson<String?>(writer),
      'lastEpisode': serializer.toJson<int?>(lastEpisode),
      'viewedAt': serializer.toJson<int>(viewedAt),
    };
  }

  HistoryData copyWith({
    String? ncode,
    Value<String?> title = const Value.absent(),
    Value<String?> writer = const Value.absent(),
    Value<int?> lastEpisode = const Value.absent(),
    int? viewedAt,
  }) => HistoryData(
    ncode: ncode ?? this.ncode,
    title: title.present ? title.value : this.title,
    writer: writer.present ? writer.value : this.writer,
    lastEpisode: lastEpisode.present ? lastEpisode.value : this.lastEpisode,
    viewedAt: viewedAt ?? this.viewedAt,
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryData(')
          ..write('ncode: $ncode, ')
          ..write('title: $title, ')
          ..write('writer: $writer, ')
          ..write('lastEpisode: $lastEpisode, ')
          ..write('viewedAt: $viewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ncode, title, writer, lastEpisode, viewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryData &&
          other.ncode == this.ncode &&
          other.title == this.title &&
          other.writer == this.writer &&
          other.lastEpisode == this.lastEpisode &&
          other.viewedAt == this.viewedAt);
}

class HistoryCompanion extends UpdateCompanion<HistoryData> {
  final Value<String> ncode;
  final Value<String?> title;
  final Value<String?> writer;
  final Value<int?> lastEpisode;
  final Value<int> viewedAt;
  final Value<int> rowid;
  const HistoryCompanion({
    this.ncode = const Value.absent(),
    this.title = const Value.absent(),
    this.writer = const Value.absent(),
    this.lastEpisode = const Value.absent(),
    this.viewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoryCompanion.insert({
    required String ncode,
    this.title = const Value.absent(),
    this.writer = const Value.absent(),
    this.lastEpisode = const Value.absent(),
    required int viewedAt,
    this.rowid = const Value.absent(),
  }) : ncode = Value(ncode),
       viewedAt = Value(viewedAt);
  static Insertable<HistoryData> custom({
    Expression<String>? ncode,
    Expression<String>? title,
    Expression<String>? writer,
    Expression<int>? lastEpisode,
    Expression<int>? viewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (title != null) 'title': title,
      if (writer != null) 'writer': writer,
      if (lastEpisode != null) 'last_episode': lastEpisode,
      if (viewedAt != null) 'viewed_at': viewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoryCompanion copyWith({
    Value<String>? ncode,
    Value<String?>? title,
    Value<String?>? writer,
    Value<int?>? lastEpisode,
    Value<int>? viewedAt,
    Value<int>? rowid,
  }) {
    return HistoryCompanion(
      ncode: ncode ?? this.ncode,
      title: title ?? this.title,
      writer: writer ?? this.writer,
      lastEpisode: lastEpisode ?? this.lastEpisode,
      viewedAt: viewedAt ?? this.viewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ncode.present) {
      map['ncode'] = Variable<String>(ncode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (writer.present) {
      map['writer'] = Variable<String>(writer.value);
    }
    if (lastEpisode.present) {
      map['last_episode'] = Variable<int>(lastEpisode.value);
    }
    if (viewedAt.present) {
      map['viewed_at'] = Variable<int>(viewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EpisodesTable extends Episodes with TableInfo<$EpisodesTable, Episode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ncodeMeta = const VerificationMeta('ncode');
  @override
  late final GeneratedColumn<String> ncode = GeneratedColumn<String>(
    'ncode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeMeta = const VerificationMeta(
    'episode',
  );
  @override
  late final GeneratedColumn<int> episode = GeneratedColumn<int>(
    'episode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<int> cachedAt = GeneratedColumn<int>(
    'cached_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
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
  VerificationContext validateIntegrity(
    Insertable<Episode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
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
  Set<GeneratedColumn> get $primaryKey => {ncode, episode};
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

class Episode extends DataClass implements Insertable<Episode> {
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
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ncode'] = Variable<String>(ncode);
    map['episode'] = Variable<int>(episode);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || cachedAt != null) {
      map['cached_at'] = Variable<int>(cachedAt);
    }
    return map;
  }

  EpisodesCompanion toCompanion(bool nullToAbsent) {
    return EpisodesCompanion(
      ncode: Value(ncode),
      episode: Value(episode),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      cachedAt: cachedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedAt),
    );
  }

  factory Episode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    Value<String?> title = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<int?> cachedAt = const Value.absent(),
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

class EpisodesCompanion extends UpdateCompanion<Episode> {
  final Value<String> ncode;
  final Value<int> episode;
  final Value<String?> title;
  final Value<String?> content;
  final Value<int?> cachedAt;
  final Value<int> rowid;
  const EpisodesCompanion({
    this.ncode = const Value.absent(),
    this.episode = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EpisodesCompanion.insert({
    required String ncode,
    required int episode,
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ncode = Value(ncode),
       episode = Value(episode);
  static Insertable<Episode> custom({
    Expression<String>? ncode,
    Expression<int>? episode,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (episode != null) 'episode': episode,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EpisodesCompanion copyWith({
    Value<String>? ncode,
    Value<int>? episode,
    Value<String?>? title,
    Value<String?>? content,
    Value<int?>? cachedAt,
    Value<int>? rowid,
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
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ncode.present) {
      map['ncode'] = Variable<String>(ncode.value);
    }
    if (episode.present) {
      map['episode'] = Variable<int>(episode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<int>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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

class $DownloadedEpisodesTable extends DownloadedEpisodes
    with TableInfo<$DownloadedEpisodesTable, DownloadedEpisode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedEpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ncodeMeta = const VerificationMeta('ncode');
  @override
  late final GeneratedColumn<String> ncode = GeneratedColumn<String>(
    'ncode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeMeta = const VerificationMeta(
    'episode',
  );
  @override
  late final GeneratedColumn<int> episode = GeneratedColumn<int>(
    'episode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<NovelContentElement>, String>
  content =
      GeneratedColumn<String>(
        'content',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<NovelContentElement>>(
        $DownloadedEpisodesTable.$convertercontent,
      );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
    'downloaded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ncode,
    episode,
    title,
    content,
    downloadedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_episodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadedEpisode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ncode, episode};
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
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
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
    );
  }

  @override
  $DownloadedEpisodesTable createAlias(String alias) {
    return $DownloadedEpisodesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<NovelContentElement>, String> $convertercontent =
      const ContentConverter();
}

class DownloadedEpisode extends DataClass
    implements Insertable<DownloadedEpisode> {
  /// 小説のncode
  final String ncode;

  /// エピソード番号
  final int episode;

  /// エピソードのタイトル
  final String? title;

  /// エピソードの内容
  /// JSON形式で保存される
  final List<NovelContentElement> content;

  /// ダウンロード日時
  final int downloadedAt;
  const DownloadedEpisode({
    required this.ncode,
    required this.episode,
    this.title,
    required this.content,
    required this.downloadedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ncode'] = Variable<String>(ncode);
    map['episode'] = Variable<int>(episode);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    {
      map['content'] = Variable<String>(
        $DownloadedEpisodesTable.$convertercontent.toSql(content),
      );
    }
    map['downloaded_at'] = Variable<int>(downloadedAt);
    return map;
  }

  DownloadedEpisodesCompanion toCompanion(bool nullToAbsent) {
    return DownloadedEpisodesCompanion(
      ncode: Value(ncode),
      episode: Value(episode),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      content: Value(content),
      downloadedAt: Value(downloadedAt),
    );
  }

  factory DownloadedEpisode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedEpisode(
      ncode: serializer.fromJson<String>(json['ncode']),
      episode: serializer.fromJson<int>(json['episode']),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<List<NovelContentElement>>(json['content']),
      downloadedAt: serializer.fromJson<int>(json['downloadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ncode': serializer.toJson<String>(ncode),
      'episode': serializer.toJson<int>(episode),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<List<NovelContentElement>>(content),
      'downloadedAt': serializer.toJson<int>(downloadedAt),
    };
  }

  DownloadedEpisode copyWith({
    String? ncode,
    int? episode,
    Value<String?> title = const Value.absent(),
    List<NovelContentElement>? content,
    int? downloadedAt,
  }) => DownloadedEpisode(
    ncode: ncode ?? this.ncode,
    episode: episode ?? this.episode,
    title: title.present ? title.value : this.title,
    content: content ?? this.content,
    downloadedAt: downloadedAt ?? this.downloadedAt,
  );
  DownloadedEpisode copyWithCompanion(DownloadedEpisodesCompanion data) {
    return DownloadedEpisode(
      ncode: data.ncode.present ? data.ncode.value : this.ncode,
      episode: data.episode.present ? data.episode.value : this.episode,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedEpisode(')
          ..write('ncode: $ncode, ')
          ..write('episode: $episode, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ncode, episode, title, content, downloadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedEpisode &&
          other.ncode == this.ncode &&
          other.episode == this.episode &&
          other.title == this.title &&
          other.content == this.content &&
          other.downloadedAt == this.downloadedAt);
}

class DownloadedEpisodesCompanion extends UpdateCompanion<DownloadedEpisode> {
  final Value<String> ncode;
  final Value<int> episode;
  final Value<String?> title;
  final Value<List<NovelContentElement>> content;
  final Value<int> downloadedAt;
  final Value<int> rowid;
  const DownloadedEpisodesCompanion({
    this.ncode = const Value.absent(),
    this.episode = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadedEpisodesCompanion.insert({
    required String ncode,
    required int episode,
    this.title = const Value.absent(),
    required List<NovelContentElement> content,
    required int downloadedAt,
    this.rowid = const Value.absent(),
  }) : ncode = Value(ncode),
       episode = Value(episode),
       content = Value(content),
       downloadedAt = Value(downloadedAt);
  static Insertable<DownloadedEpisode> custom({
    Expression<String>? ncode,
    Expression<int>? episode,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? downloadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (episode != null) 'episode': episode,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadedEpisodesCompanion copyWith({
    Value<String>? ncode,
    Value<int>? episode,
    Value<String?>? title,
    Value<List<NovelContentElement>>? content,
    Value<int>? downloadedAt,
    Value<int>? rowid,
  }) {
    return DownloadedEpisodesCompanion(
      ncode: ncode ?? this.ncode,
      episode: episode ?? this.episode,
      title: title ?? this.title,
      content: content ?? this.content,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ncode.present) {
      map['ncode'] = Variable<String>(ncode.value);
    }
    if (episode.present) {
      map['episode'] = Variable<int>(episode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
        $DownloadedEpisodesTable.$convertercontent.toSql(content.value),
      );
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedEpisodesCompanion(')
          ..write('ncode: $ncode, ')
          ..write('episode: $episode, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ncodeMeta = const VerificationMeta('ncode');
  @override
  late final GeneratedColumn<String> ncode = GeneratedColumn<String>(
    'ncode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeMeta = const VerificationMeta(
    'episode',
  );
  @override
  late final GeneratedColumn<int> episode = GeneratedColumn<int>(
    'episode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
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
  VerificationContext validateIntegrity(
    Insertable<Bookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
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
  Set<GeneratedColumn> get $primaryKey => {ncode, episode, position};
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

class Bookmark extends DataClass implements Insertable<Bookmark> {
  /// 小説のncode
  final String ncode;

  /// エピソード番号
  final int episode;

  /// ブックマークの位置
  final int position;

  /// ブックマークの内容
  final String? content;

  /// ブックマークの作成日時
  /// UNIXタイムスタンプ形式で保存される
  final int createdAt;
  const Bookmark({
    required this.ncode,
    required this.episode,
    required this.position,
    this.content,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ncode'] = Variable<String>(ncode);
    map['episode'] = Variable<int>(episode);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      ncode: Value(ncode),
      episode: Value(episode),
      position: Value(position),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    Value<String?> content = const Value.absent(),
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

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<String> ncode;
  final Value<int> episode;
  final Value<int> position;
  final Value<String?> content;
  final Value<int> createdAt;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.ncode = const Value.absent(),
    this.episode = const Value.absent(),
    this.position = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required String ncode,
    required int episode,
    required int position,
    this.content = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : ncode = Value(ncode),
       episode = Value(episode),
       position = Value(position),
       createdAt = Value(createdAt);
  static Insertable<Bookmark> custom({
    Expression<String>? ncode,
    Expression<int>? episode,
    Expression<int>? position,
    Expression<String>? content,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ncode != null) 'ncode': ncode,
      if (episode != null) 'episode': episode,
      if (position != null) 'position': position,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith({
    Value<String>? ncode,
    Value<int>? episode,
    Value<int>? position,
    Value<String?>? content,
    Value<int>? createdAt,
    Value<int>? rowid,
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
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ncode.present) {
      map['ncode'] = Variable<String>(ncode.value);
    }
    if (episode.present) {
      map['episode'] = Variable<int>(episode.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NovelsTable novels = $NovelsTable(this);
  late final $HistoryTable history = $HistoryTable(this);
  late final $EpisodesTable episodes = $EpisodesTable(this);
  late final $DownloadedEpisodesTable downloadedEpisodes =
      $DownloadedEpisodesTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    novels,
    history,
    episodes,
    downloadedEpisodes,
    bookmarks,
  ];
}

typedef $$NovelsTableCreateCompanionBuilder =
    NovelsCompanion Function({
      required String ncode,
      Value<String?> title,
      Value<String?> writer,
      Value<String?> story,
      Value<int?> novelType,
      Value<int?> end,
      Value<int?> isr15,
      Value<int?> isbl,
      Value<int?> isgl,
      Value<int?> iszankoku,
      Value<int?> istensei,
      Value<int?> istenni,
      Value<String?> keyword,
      Value<int?> generalFirstup,
      Value<int?> generalLastup,
      Value<int?> globalPoint,
      Value<int?> fav,
      Value<int?> reviewCount,
      Value<int?> rateCount,
      Value<int?> allPoint,
      Value<int?> pointCount,
      Value<int?> dailyPoint,
      Value<int?> weeklyPoint,
      Value<int?> monthlyPoint,
      Value<int?> quarterPoint,
      Value<int?> yearlyPoint,
      Value<int?> generalAllNo,
      Value<String?> novelUpdatedAt,
      Value<int?> cachedAt,
      Value<int> rowid,
    });
typedef $$NovelsTableUpdateCompanionBuilder =
    NovelsCompanion Function({
      Value<String> ncode,
      Value<String?> title,
      Value<String?> writer,
      Value<String?> story,
      Value<int?> novelType,
      Value<int?> end,
      Value<int?> isr15,
      Value<int?> isbl,
      Value<int?> isgl,
      Value<int?> iszankoku,
      Value<int?> istensei,
      Value<int?> istenni,
      Value<String?> keyword,
      Value<int?> generalFirstup,
      Value<int?> generalLastup,
      Value<int?> globalPoint,
      Value<int?> fav,
      Value<int?> reviewCount,
      Value<int?> rateCount,
      Value<int?> allPoint,
      Value<int?> pointCount,
      Value<int?> dailyPoint,
      Value<int?> weeklyPoint,
      Value<int?> monthlyPoint,
      Value<int?> quarterPoint,
      Value<int?> yearlyPoint,
      Value<int?> generalAllNo,
      Value<String?> novelUpdatedAt,
      Value<int?> cachedAt,
      Value<int> rowid,
    });

class $$NovelsTableFilterComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get writer => $composableBuilder(
    column: $table.writer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get novelType => $composableBuilder(
    column: $table.novelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isr15 => $composableBuilder(
    column: $table.isr15,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isbl => $composableBuilder(
    column: $table.isbl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isgl => $composableBuilder(
    column: $table.isgl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iszankoku => $composableBuilder(
    column: $table.iszankoku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get istensei => $composableBuilder(
    column: $table.istensei,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get istenni => $composableBuilder(
    column: $table.istenni,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyword => $composableBuilder(
    column: $table.keyword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generalFirstup => $composableBuilder(
    column: $table.generalFirstup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generalLastup => $composableBuilder(
    column: $table.generalLastup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get globalPoint => $composableBuilder(
    column: $table.globalPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fav => $composableBuilder(
    column: $table.fav,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rateCount => $composableBuilder(
    column: $table.rateCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allPoint => $composableBuilder(
    column: $table.allPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyPoint => $composableBuilder(
    column: $table.dailyPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyPoint => $composableBuilder(
    column: $table.weeklyPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyPoint => $composableBuilder(
    column: $table.monthlyPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quarterPoint => $composableBuilder(
    column: $table.quarterPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearlyPoint => $composableBuilder(
    column: $table.yearlyPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generalAllNo => $composableBuilder(
    column: $table.generalAllNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get novelUpdatedAt => $composableBuilder(
    column: $table.novelUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NovelsTableOrderingComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get writer => $composableBuilder(
    column: $table.writer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get novelType => $composableBuilder(
    column: $table.novelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isr15 => $composableBuilder(
    column: $table.isr15,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isbl => $composableBuilder(
    column: $table.isbl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isgl => $composableBuilder(
    column: $table.isgl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iszankoku => $composableBuilder(
    column: $table.iszankoku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get istensei => $composableBuilder(
    column: $table.istensei,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get istenni => $composableBuilder(
    column: $table.istenni,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyword => $composableBuilder(
    column: $table.keyword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generalFirstup => $composableBuilder(
    column: $table.generalFirstup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generalLastup => $composableBuilder(
    column: $table.generalLastup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get globalPoint => $composableBuilder(
    column: $table.globalPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fav => $composableBuilder(
    column: $table.fav,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rateCount => $composableBuilder(
    column: $table.rateCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allPoint => $composableBuilder(
    column: $table.allPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyPoint => $composableBuilder(
    column: $table.dailyPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyPoint => $composableBuilder(
    column: $table.weeklyPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyPoint => $composableBuilder(
    column: $table.monthlyPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quarterPoint => $composableBuilder(
    column: $table.quarterPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearlyPoint => $composableBuilder(
    column: $table.yearlyPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generalAllNo => $composableBuilder(
    column: $table.generalAllNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get novelUpdatedAt => $composableBuilder(
    column: $table.novelUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NovelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get writer =>
      $composableBuilder(column: $table.writer, builder: (column) => column);

  GeneratedColumn<String> get story =>
      $composableBuilder(column: $table.story, builder: (column) => column);

  GeneratedColumn<int> get novelType =>
      $composableBuilder(column: $table.novelType, builder: (column) => column);

  GeneratedColumn<int> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<int> get isr15 =>
      $composableBuilder(column: $table.isr15, builder: (column) => column);

  GeneratedColumn<int> get isbl =>
      $composableBuilder(column: $table.isbl, builder: (column) => column);

  GeneratedColumn<int> get isgl =>
      $composableBuilder(column: $table.isgl, builder: (column) => column);

  GeneratedColumn<int> get iszankoku =>
      $composableBuilder(column: $table.iszankoku, builder: (column) => column);

  GeneratedColumn<int> get istensei =>
      $composableBuilder(column: $table.istensei, builder: (column) => column);

  GeneratedColumn<int> get istenni =>
      $composableBuilder(column: $table.istenni, builder: (column) => column);

  GeneratedColumn<String> get keyword =>
      $composableBuilder(column: $table.keyword, builder: (column) => column);

  GeneratedColumn<int> get generalFirstup => $composableBuilder(
    column: $table.generalFirstup,
    builder: (column) => column,
  );

  GeneratedColumn<int> get generalLastup => $composableBuilder(
    column: $table.generalLastup,
    builder: (column) => column,
  );

  GeneratedColumn<int> get globalPoint => $composableBuilder(
    column: $table.globalPoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fav =>
      $composableBuilder(column: $table.fav, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rateCount =>
      $composableBuilder(column: $table.rateCount, builder: (column) => column);

  GeneratedColumn<int> get allPoint =>
      $composableBuilder(column: $table.allPoint, builder: (column) => column);

  GeneratedColumn<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyPoint => $composableBuilder(
    column: $table.dailyPoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyPoint => $composableBuilder(
    column: $table.weeklyPoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyPoint => $composableBuilder(
    column: $table.monthlyPoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quarterPoint => $composableBuilder(
    column: $table.quarterPoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yearlyPoint => $composableBuilder(
    column: $table.yearlyPoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get generalAllNo => $composableBuilder(
    column: $table.generalAllNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get novelUpdatedAt => $composableBuilder(
    column: $table.novelUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$NovelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NovelsTable,
          Novel,
          $$NovelsTableFilterComposer,
          $$NovelsTableOrderingComposer,
          $$NovelsTableAnnotationComposer,
          $$NovelsTableCreateCompanionBuilder,
          $$NovelsTableUpdateCompanionBuilder,
          (Novel, BaseReferences<_$AppDatabase, $NovelsTable, Novel>),
          Novel,
          PrefetchHooks Function()
        > {
  $$NovelsTableTableManager(_$AppDatabase db, $NovelsTable table)
    : super(
        TableManagerState(
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
                Value<String> ncode = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> writer = const Value.absent(),
                Value<String?> story = const Value.absent(),
                Value<int?> novelType = const Value.absent(),
                Value<int?> end = const Value.absent(),
                Value<int?> isr15 = const Value.absent(),
                Value<int?> isbl = const Value.absent(),
                Value<int?> isgl = const Value.absent(),
                Value<int?> iszankoku = const Value.absent(),
                Value<int?> istensei = const Value.absent(),
                Value<int?> istenni = const Value.absent(),
                Value<String?> keyword = const Value.absent(),
                Value<int?> generalFirstup = const Value.absent(),
                Value<int?> generalLastup = const Value.absent(),
                Value<int?> globalPoint = const Value.absent(),
                Value<int?> fav = const Value.absent(),
                Value<int?> reviewCount = const Value.absent(),
                Value<int?> rateCount = const Value.absent(),
                Value<int?> allPoint = const Value.absent(),
                Value<int?> pointCount = const Value.absent(),
                Value<int?> dailyPoint = const Value.absent(),
                Value<int?> weeklyPoint = const Value.absent(),
                Value<int?> monthlyPoint = const Value.absent(),
                Value<int?> quarterPoint = const Value.absent(),
                Value<int?> yearlyPoint = const Value.absent(),
                Value<int?> generalAllNo = const Value.absent(),
                Value<String?> novelUpdatedAt = const Value.absent(),
                Value<int?> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NovelsCompanion(
                ncode: ncode,
                title: title,
                writer: writer,
                story: story,
                novelType: novelType,
                end: end,
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
                Value<String?> title = const Value.absent(),
                Value<String?> writer = const Value.absent(),
                Value<String?> story = const Value.absent(),
                Value<int?> novelType = const Value.absent(),
                Value<int?> end = const Value.absent(),
                Value<int?> isr15 = const Value.absent(),
                Value<int?> isbl = const Value.absent(),
                Value<int?> isgl = const Value.absent(),
                Value<int?> iszankoku = const Value.absent(),
                Value<int?> istensei = const Value.absent(),
                Value<int?> istenni = const Value.absent(),
                Value<String?> keyword = const Value.absent(),
                Value<int?> generalFirstup = const Value.absent(),
                Value<int?> generalLastup = const Value.absent(),
                Value<int?> globalPoint = const Value.absent(),
                Value<int?> fav = const Value.absent(),
                Value<int?> reviewCount = const Value.absent(),
                Value<int?> rateCount = const Value.absent(),
                Value<int?> allPoint = const Value.absent(),
                Value<int?> pointCount = const Value.absent(),
                Value<int?> dailyPoint = const Value.absent(),
                Value<int?> weeklyPoint = const Value.absent(),
                Value<int?> monthlyPoint = const Value.absent(),
                Value<int?> quarterPoint = const Value.absent(),
                Value<int?> yearlyPoint = const Value.absent(),
                Value<int?> generalAllNo = const Value.absent(),
                Value<String?> novelUpdatedAt = const Value.absent(),
                Value<int?> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NovelsCompanion.insert(
                ncode: ncode,
                title: title,
                writer: writer,
                story: story,
                novelType: novelType,
                end: end,
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NovelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NovelsTable,
      Novel,
      $$NovelsTableFilterComposer,
      $$NovelsTableOrderingComposer,
      $$NovelsTableAnnotationComposer,
      $$NovelsTableCreateCompanionBuilder,
      $$NovelsTableUpdateCompanionBuilder,
      (Novel, BaseReferences<_$AppDatabase, $NovelsTable, Novel>),
      Novel,
      PrefetchHooks Function()
    >;
typedef $$HistoryTableCreateCompanionBuilder =
    HistoryCompanion Function({
      required String ncode,
      Value<String?> title,
      Value<String?> writer,
      Value<int?> lastEpisode,
      required int viewedAt,
      Value<int> rowid,
    });
typedef $$HistoryTableUpdateCompanionBuilder =
    HistoryCompanion Function({
      Value<String> ncode,
      Value<String?> title,
      Value<String?> writer,
      Value<int?> lastEpisode,
      Value<int> viewedAt,
      Value<int> rowid,
    });

class $$HistoryTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get writer => $composableBuilder(
    column: $table.writer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastEpisode => $composableBuilder(
    column: $table.lastEpisode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get writer => $composableBuilder(
    column: $table.writer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastEpisode => $composableBuilder(
    column: $table.lastEpisode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get writer =>
      $composableBuilder(column: $table.writer, builder: (column) => column);

  GeneratedColumn<int> get lastEpisode => $composableBuilder(
    column: $table.lastEpisode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get viewedAt =>
      $composableBuilder(column: $table.viewedAt, builder: (column) => column);
}

class $$HistoryTableTableManager
    extends
        RootTableManager<
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
            BaseReferences<_$AppDatabase, $HistoryTable, HistoryData>,
          ),
          HistoryData,
          PrefetchHooks Function()
        > {
  $$HistoryTableTableManager(_$AppDatabase db, $HistoryTable table)
    : super(
        TableManagerState(
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
                Value<String> ncode = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> writer = const Value.absent(),
                Value<int?> lastEpisode = const Value.absent(),
                Value<int> viewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HistoryCompanion(
                ncode: ncode,
                title: title,
                writer: writer,
                lastEpisode: lastEpisode,
                viewedAt: viewedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                Value<String?> title = const Value.absent(),
                Value<String?> writer = const Value.absent(),
                Value<int?> lastEpisode = const Value.absent(),
                required int viewedAt,
                Value<int> rowid = const Value.absent(),
              }) => HistoryCompanion.insert(
                ncode: ncode,
                title: title,
                writer: writer,
                lastEpisode: lastEpisode,
                viewedAt: viewedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoryTable,
      HistoryData,
      $$HistoryTableFilterComposer,
      $$HistoryTableOrderingComposer,
      $$HistoryTableAnnotationComposer,
      $$HistoryTableCreateCompanionBuilder,
      $$HistoryTableUpdateCompanionBuilder,
      (HistoryData, BaseReferences<_$AppDatabase, $HistoryTable, HistoryData>),
      HistoryData,
      PrefetchHooks Function()
    >;
typedef $$EpisodesTableCreateCompanionBuilder =
    EpisodesCompanion Function({
      required String ncode,
      required int episode,
      Value<String?> title,
      Value<String?> content,
      Value<int?> cachedAt,
      Value<int> rowid,
    });
typedef $$EpisodesTableUpdateCompanionBuilder =
    EpisodesCompanion Function({
      Value<String> ncode,
      Value<int> episode,
      Value<String?> title,
      Value<String?> content,
      Value<int?> cachedAt,
      Value<int> rowid,
    });

class $$EpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  GeneratedColumn<int> get episode =>
      $composableBuilder(column: $table.episode, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$EpisodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EpisodesTable,
          Episode,
          $$EpisodesTableFilterComposer,
          $$EpisodesTableOrderingComposer,
          $$EpisodesTableAnnotationComposer,
          $$EpisodesTableCreateCompanionBuilder,
          $$EpisodesTableUpdateCompanionBuilder,
          (Episode, BaseReferences<_$AppDatabase, $EpisodesTable, Episode>),
          Episode,
          PrefetchHooks Function()
        > {
  $$EpisodesTableTableManager(_$AppDatabase db, $EpisodesTable table)
    : super(
        TableManagerState(
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
                Value<String> ncode = const Value.absent(),
                Value<int> episode = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int?> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
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
                Value<String?> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int?> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EpisodesCompanion.insert(
                ncode: ncode,
                episode: episode,
                title: title,
                content: content,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EpisodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EpisodesTable,
      Episode,
      $$EpisodesTableFilterComposer,
      $$EpisodesTableOrderingComposer,
      $$EpisodesTableAnnotationComposer,
      $$EpisodesTableCreateCompanionBuilder,
      $$EpisodesTableUpdateCompanionBuilder,
      (Episode, BaseReferences<_$AppDatabase, $EpisodesTable, Episode>),
      Episode,
      PrefetchHooks Function()
    >;
typedef $$DownloadedEpisodesTableCreateCompanionBuilder =
    DownloadedEpisodesCompanion Function({
      required String ncode,
      required int episode,
      Value<String?> title,
      required List<NovelContentElement> content,
      required int downloadedAt,
      Value<int> rowid,
    });
typedef $$DownloadedEpisodesTableUpdateCompanionBuilder =
    DownloadedEpisodesCompanion Function({
      Value<String> ncode,
      Value<int> episode,
      Value<String?> title,
      Value<List<NovelContentElement>> content,
      Value<int> downloadedAt,
      Value<int> rowid,
    });

class $$DownloadedEpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedEpisodesTable> {
  $$DownloadedEpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<NovelContentElement>,
    List<NovelContentElement>,
    String
  >
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DownloadedEpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedEpisodesTable> {
  $$DownloadedEpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DownloadedEpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedEpisodesTable> {
  $$DownloadedEpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  GeneratedColumn<int> get episode =>
      $composableBuilder(column: $table.episode, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<NovelContentElement>, String>
  get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );
}

class $$DownloadedEpisodesTableTableManager
    extends
        RootTableManager<
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
            BaseReferences<
              _$AppDatabase,
              $DownloadedEpisodesTable,
              DownloadedEpisode
            >,
          ),
          DownloadedEpisode,
          PrefetchHooks Function()
        > {
  $$DownloadedEpisodesTableTableManager(
    _$AppDatabase db,
    $DownloadedEpisodesTable table,
  ) : super(
        TableManagerState(
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
                Value<String> ncode = const Value.absent(),
                Value<int> episode = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<List<NovelContentElement>> content = const Value.absent(),
                Value<int> downloadedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DownloadedEpisodesCompanion(
                ncode: ncode,
                episode: episode,
                title: title,
                content: content,
                downloadedAt: downloadedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ncode,
                required int episode,
                Value<String?> title = const Value.absent(),
                required List<NovelContentElement> content,
                required int downloadedAt,
                Value<int> rowid = const Value.absent(),
              }) => DownloadedEpisodesCompanion.insert(
                ncode: ncode,
                episode: episode,
                title: title,
                content: content,
                downloadedAt: downloadedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadedEpisodesTableProcessedTableManager =
    ProcessedTableManager<
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
        BaseReferences<
          _$AppDatabase,
          $DownloadedEpisodesTable,
          DownloadedEpisode
        >,
      ),
      DownloadedEpisode,
      PrefetchHooks Function()
    >;
typedef $$BookmarksTableCreateCompanionBuilder =
    BookmarksCompanion Function({
      required String ncode,
      required int episode,
      required int position,
      Value<String?> content,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$BookmarksTableUpdateCompanionBuilder =
    BookmarksCompanion Function({
      Value<String> ncode,
      Value<int> episode,
      Value<int> position,
      Value<String?> content,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ncode => $composableBuilder(
    column: $table.ncode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episode => $composableBuilder(
    column: $table.episode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ncode =>
      $composableBuilder(column: $table.ncode, builder: (column) => column);

  GeneratedColumn<int> get episode =>
      $composableBuilder(column: $table.episode, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
          Bookmark,
          PrefetchHooks Function()
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
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
                Value<String> ncode = const Value.absent(),
                Value<int> episode = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
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
                Value<String?> content = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion.insert(
                ncode: ncode,
                episode: episode,
                position: position,
                content: content,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
      Bookmark,
      PrefetchHooks Function()
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
  $$DownloadedEpisodesTableTableManager get downloadedEpisodes =>
      $$DownloadedEpisodesTableTableManager(_db, _db.downloadedEpisodes);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// アプリケーションのデータベース
@ProviderFor(appDatabase)
const appDatabaseProvider = AppDatabaseProvider._();

/// アプリケーションのデータベース
final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// アプリケーションのデータベース
  const AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'18ce5c8c4d8ddbfe5a7d819d8fb7d5aca76bf416';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
