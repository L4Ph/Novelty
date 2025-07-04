class NovelSearchQuery {

  NovelSearchQuery({this.ncode});
  String? word;
  String? notword;
  bool title = false;
  bool ex = false;
  bool keyword = false;
  bool wname = false;
  List<int>? biggenre;
  List<int>? notbiggenre;
  List<int>? genre;
  List<int>? notgenre;
  List<int>? userid;
  bool isr15 = false;
  bool isbl = false;
  bool isgl = false;
  bool iszankoku = false;
  bool istensei = false;
  bool istenni = false;
  bool istt = false;
  bool notr15 = false;
  bool notbl = false;
  bool notgl = false;
  bool notzankoku = false;
  bool nottensei = false;
  bool nottenni = false;
  int? minlen;
  int? maxlen;
  String? length;
  String? kaiwaritu;
  String? sasie;
  int? mintime;
  int? maxtime;
  String? time;
  List<String>? ncode;
  String? type;
  List<int>? buntai;
  int? stop;
  String? lastup;
  String? lastupdate;
  bool ispickup = false;
  String order = 'new';
  int lim = 20;
  int st = 1;

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'notword': notword,
      'title': title ? 1 : null,
      'ex': ex ? 1 : null,
      'keyword': keyword ? 1 : null,
      'wname': wname ? 1 : null,
      'biggenre': biggenre?.join('-'),
      'notbiggenre': notbiggenre?.join('-'),
      'genre': genre?.join('-'),
      'notgenre': notgenre?.join('-'),
      'userid': userid?.join('-'),
      'isr15': isr15 ? 1 : null,
      'isbl': isbl ? 1 : null,
      'isgl': isgl ? 1 : null,
      'iszankoku': iszankoku ? 1 : null,
      'istensei': istensei ? 1 : null,
      'istenni': istenni ? 1 : null,
      'istt': istt ? 1 : null,
      'notr15': notr15 ? 1 : null,
      'notbl': notbl ? 1 : null,
      'notgl': notgl ? 1 : null,
      'notzankoku': notzankoku ? 1 : null,
      'nottensei': nottensei ? 1 : null,
      'nottenni': nottenni ? 1 : null,
      'minlen': minlen,
      'maxlen': maxlen,
      'length': length,
      'kaiwaritu': kaiwaritu,
      'sasie': sasie,
      'mintime': mintime,
      'maxtime': maxtime,
      'time': time,
      'ncode': ncode?.join('-'),
      'type': type,
      'buntai': buntai?.join('-'),
      'stop': stop,
      'lastup': lastup,
      'lastupdate': lastupdate,
      'ispickup': ispickup ? 1 : null,
      'order': order,
      'lim': lim,
      'st': st,
    };
  }
}
