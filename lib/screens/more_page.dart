import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/utils/settings_provider.dart';

/// "もっと"ページ（設定ハブ）のウィジェット。
class MorePage extends ConsumerStatefulWidget {
  /// コンストラクタ
  const MorePage({super.key});

  @override
  ConsumerState<MorePage> createState() => _MorePageState();
}

class _MorePageState extends ConsumerState<MorePage> {
  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: Center(
                  child: Image.asset(
                    'assets/app_icon/base.webp',
                    width: 120,
                    height: 120,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildQuickActions(settingsAsync),
              const Divider(),
              _buildFeaturesSection(),
              const Divider(),
              _buildSettingsSection(),
              const Divider(),
              _buildAppInfoSection(),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AsyncValue<AppSettings> settingsAsync) {
    return Column(
      children: [
        settingsAsync.when(
          data: (settings) => SwitchListTile(
            secondary: const Icon(Icons.cloud_off),
            title: const Text('オフラインモード'),
            subtitle: const Text('通信を行わず、保存済みのコンテンツのみ利用します'),
            value: settings.isOfflineMode,
            onChanged: (value) async {
              await ref
                  .read(settingsProvider.notifier)
                  .setIsOfflineMode(isOfflineMode: value);
            },
          ),
          loading: () => const ListTile(
            leading: CircularProgressIndicator(),
            title: Text('読み込み中...'),
          ),
          error: (err, stack) => ListTile(title: Text('Error: $err')),
        ),
        settingsAsync.when(
          data: (settings) => SwitchListTile(
            secondary: const Icon(Icons.visibility_off),
            title: const Text('シークレットモード'),
            subtitle: const Text('閲覧履歴の記録を一時停止します'),
            value: settings.isIncognito,
            onChanged: (value) async {
              await ref
                  .read(settingsProvider.notifier)
                  .setIsIncognito(isIncognito: value);
            },
          ),
          loading: () => const ListTile(
            leading: CircularProgressIndicator(),
            title: Text('読み込み中...'),
          ),
          error: (err, stack) => ListTile(title: Text('Error: $err')),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('機能'),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('ダウンロードキュー'),
          onTap: () => appRouter.push(const DownloadsDest()),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('設定'),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text('一般設定'), // Appearance
          onTap: () => appRouter.push(const AppearanceSettingsDest()),
        ),
        ListTile(
          leading: const Icon(Icons.chrome_reader_mode_outlined),
          title: const Text('閲覧設定'), // Reader
          onTap: () => appRouter.push(const ReaderSettingsDest()),
        ),
        ListTile(
          leading: const Icon(Icons.storage_outlined),
          title: const Text('データとストレージ'),
          onTap: () => appRouter.push(const DataStorageDest()),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('アプリ情報'),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('アプリについて'),
          onTap: () => appRouter.push(const AboutDest()),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
