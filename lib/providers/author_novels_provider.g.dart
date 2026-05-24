// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_novels_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 指定したuserIdの作者の小説一覧を取得するFutureProvider

@ProviderFor(authorNovels)
const authorNovelsProvider = AuthorNovelsFamily._();

/// 指定したuserIdの作者の小説一覧を取得するFutureProvider

final class AuthorNovelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NovelInfo>>,
          List<NovelInfo>,
          FutureOr<List<NovelInfo>>
        >
    with $FutureModifier<List<NovelInfo>>, $FutureProvider<List<NovelInfo>> {
  /// 指定したuserIdの作者の小説一覧を取得するFutureProvider
  const AuthorNovelsProvider._({
    required AuthorNovelsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'authorNovelsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$authorNovelsHash();

  @override
  String toString() {
    return r'authorNovelsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<NovelInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NovelInfo>> create(Ref ref) {
    final argument = this.argument as int;
    return authorNovels(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthorNovelsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$authorNovelsHash() => r'16b9425294ee33feb1b0529f49f9709f0aa722a6';

/// 指定したuserIdの作者の小説一覧を取得するFutureProvider

final class AuthorNovelsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<NovelInfo>>, int> {
  const AuthorNovelsFamily._()
    : super(
        retry: null,
        name: r'authorNovelsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 指定したuserIdの作者の小説一覧を取得するFutureProvider

  AuthorNovelsProvider call(int userId) =>
      AuthorNovelsProvider._(argument: userId, from: this);

  @override
  String toString() => r'authorNovelsProvider';
}
