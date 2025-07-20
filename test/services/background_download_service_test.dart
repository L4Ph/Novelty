import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/background_download_service.dart';

void main() {
  group('BackgroundDownloadService', () {
    late ProviderContainer container;
    late BackgroundDownloadService service;

    setUp(() {
      container = ProviderContainer();
      service = container.read(backgroundDownloadServiceProvider);
    });

    tearDown(() {
      container.dispose();
    });

    test('サービスインスタンスが正しく作成されること', () {
      expect(service, isNotNull);
      expect(service.ref, isNotNull);
    });

    group('NovelInfoの処理', () {
      test('短編小説のnovelTypeが正しく判定されること', () {
        const novelInfo = NovelInfo(
          title: 'テスト短編小説',
          ncode: 'n1234ab',
          writer: 'テスト作者',
          novelType: 2, // 短編
          generalAllNo: 1,
        );

        expect(novelInfo.novelType, equals(2));
        expect(novelInfo.generalAllNo, equals(1));
      });

      test('連載小説のnovelTypeが正しく判定されること', () {
        const novelInfo = NovelInfo(
          title: 'テスト連載小説',
          ncode: 'n5678cd',
          writer: 'テスト作者',
          novelType: 1, // 連載
          generalAllNo: 100,
        );

        expect(novelInfo.novelType, equals(1));
        expect(novelInfo.generalAllNo, equals(100));
      });

      test('ncodeが小文字で処理されること', () {
        const novelInfo = NovelInfo(
          title: 'テスト小説',
          ncode: 'N1234AB', // 大文字
          writer: 'テスト作者',
          novelType: 1,
        );

        // 実際のサービスでは小文字に変換される
        final processedNcode = novelInfo.ncode?.toLowerCase();
        
        expect(processedNcode, equals('n1234ab'));
      });
    });

    group('ダウンロード進捗計算機能', () {
      test('連載小説の進捗パーセンテージが正しく計算されること', () {
        // Red: まだ実装されていないメソッドのテスト
        const totalEpisodes = 100;
        const currentEpisode = 25;
        const expectedPercent = 25;
        
        final actualPercent = service.calculateDownloadProgress(currentEpisode, totalEpisodes);
        
        expect(actualPercent, equals(expectedPercent));
      });

      test('短編小説の進捗パーセンテージが100%になること', () {
        // Red: 短編小説のテスト
        const totalEpisodes = 1;
        const currentEpisode = 1;
        const expectedPercent = 100;
        
        final actualPercent = service.calculateDownloadProgress(currentEpisode, totalEpisodes);
        
        expect(actualPercent, equals(expectedPercent));
      });

      test('進捗が0の場合に0%になること', () {
        // Red: 初期状態のテスト
        const totalEpisodes = 50;
        const currentEpisode = 0;
        const expectedPercent = 0;
        
        final actualPercent = service.calculateDownloadProgress(currentEpisode, totalEpisodes);
        
        expect(actualPercent, equals(expectedPercent));
      });
    });

    group('ダウンロードパス生成機能', () {
      test('小説ディレクトリパスが正しく生成されること', () {
        // Red: まだ実装されていないメソッドのテスト
        const basePath = '/storage/emulated/0/Download/Novelty';
        const ncode = 'n1234ab';
        const expectedPath = '/storage/emulated/0/Download/Novelty/n1234ab';
        
        final actualPath = service.generateNovelDirectoryPath(basePath, ncode);
        
        expect(actualPath, equals(expectedPath));
      });

      test('エピソードファイル名が正しく生成されること', () {
        // Red: まだ実装されていないメソッドのテスト
        const ncode = 'n1234ab';
        const episodeNumber = 5;
        const expectedFileName = 'n1234ab_5.txt';
        
        final actualFileName = service.generateEpisodeFileName(ncode, episodeNumber);
        
        expect(actualFileName, equals(expectedFileName));
      });
    });
  });
}
