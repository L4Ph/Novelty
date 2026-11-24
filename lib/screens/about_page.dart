import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/router/app_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// よくある質問の一覧。旧サイト（ヘルプページ）から移植した。
///
/// answer の各要素は段落で、表示時に改行で連結する。
const List<({String question, List<String> answer})> _faqItems = [
  (
    question: '「小説家になろう」のアカウントでログインできますか？（ブックマーク連携はできますか？）',
    answer: [
      'ログイン機能やブックマークの直接同期機能は提供していません。',
      'プライバシー保護とセキュリティを優先したためです。',
      '代わりに検索機能、ローカルでのライブラリ管理、バックアップを用意しています。',
    ],
  ),
  (
    question: 'iOS(iPhone/iPad)版はありますか？',
    answer: [
      '技術的には対応しており、ソースコードからビルドすれば動作するはずですが、未検証です。',
      'App Store での公開も現在未定です。将来的には対応を検討しています。',
    ],
  ),
  (
    question: '「カクヨム」や「ハーメルン」など、他の小説サイトには対応していますか？',
    answer: [
      '「小説家になろう」と「カクヨム」に対応しています。',
      '同じ操作感でランキングや検索、縦書き読書やオフライン保存が使えます。',
    ],
  ),
  (
    question: 'アプリ内に広告は表示されますか？',
    answer: [
      '一切表示されません。(作者本人が表示されてほしくありません。)',
      '読書への没入感を最優先し、余計な通信を排除しているため、今後も導入予定はありません。',
    ],
  ),
  (
    question: 'オフラインで読むことはできますか？',
    answer: [
      'はい、可能です。',
      '小説をダウンロードしておけば、通信できない環境でも読むことができます。',
    ],
  ),
  (
    question: '縦書き表示には対応していますか？',
    answer: [
      'はい、対応しています。',
      '設定から「縦書き」モードに切り替えると、文庫本のような縦書きで閲覧できます。',
      'フォントや文字サイズの変更も可能です。',
    ],
  ),
  (
    question: 'データのバックアップは可能ですか？',
    answer: [
      'はい、設定の「データとストレージ」から行えます。',
      'ライブラリや閲覧履歴を含むすべてのデータを書き出し（エクスポート）、復元（インポート）できます。',
    ],
  ),
  (
    question: '推奨環境や対応プラットフォームを教えてください。',
    answer: [
      '現在はAndroidを主対象として開発・動作確認しています。',
      'Windows、macOS、Linuxでも動作しますが、最適化はAndroidが優先です。',
    ],
  ),
  (
    question: 'アプリのインストール・アップデート方法は？',
    answer: [
      'Google Playでの配信準備中のため、現在はベータテストとして配布しています。',
      '参加には Google グループへの登録が必要です。',
      'Obtainium などのオープンソースアプリから GitHub Releases の自動更新も使えます。',
    ],
  ),
];

/// "アプリについて"ページのウィジェット。
class AboutPage extends StatefulWidget {
  /// コンストラクタ。
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: appRouter.pop),
        title: const Text('アプリについて'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 32),
          Center(
            child: Image.asset(
              'assets/app_icon/base.webp',
              width: 100,
              height: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            title: const Text('更新情報'),
            onTap: () => _launchUrl('https://github.com/L4Ph/Novelty/releases'),
          ),
          ListTile(
            title: const Text('ソースコード'),
            onTap: () => _launchUrl('https://github.com/L4Ph/Novelty'),
          ),
          ListTile(
            title: const Text('ライセンス'),
            onTap: () =>
                _launchUrl('https://github.com/L4Ph/Novelty/blob/main/LICENSE'),
          ),
          ListTile(
            title: const Text('オープンソースライセンス'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Novelty',
                applicationLegalese: '© ${DateTime.now().year} L4Ph',
              );
            },
          ),
          ListTile(
            title: const Text('プライバシーポリシー'),
            onTap: () => _launchUrl(
              'https://github.com/L4Ph/Novelty/blob/main/PRIVACY_POLICY.md',
            ),
          ),
          ListTile(
            title: const Text('ベータ版に参加（Google Play）'),
            onTap: () => _launchUrl(
              'https://play.google.com/apps/testing/moe.l4ph.novelty',
            ),
          ),
          ListTile(
            title: const Text('ベータ版のGoogleグループ'),
            onTap: () => _launchUrl('https://groups.google.com/g/novelty-app'),
          ),
          ListTile(
            title: const Text('Obtainium（GitHub Releasesから自動更新）'),
            onTap: () => _launchUrl('https://obtainium.imranr.dev/'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'よくある質問',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (final faq in _faqItems)
            ExpansionTile(
              // 展開状態を復元できるよう、項目ごとに一意なキーを付ける
              key: PageStorageKey(faq.question),
              title: Text(faq.question),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(faq.answer.join('\n'))],
            ),
        ],
      ),
    );
  }
}
