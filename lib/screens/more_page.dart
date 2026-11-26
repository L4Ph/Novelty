import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:tiny_state/tiny_state.dart';

/// "もっと"ページ（設定ハブ）のウィジェット。
class MorePage extends StatelessWidget {
  /// コンストラクタ
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsAsync = context.services.settings.state;

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
              _buildQuickActions(context, settingsAsync),
              const Divider(),
              _buildFeaturesSection(context),
              const Divider(),
              _buildSettingsSection(context),
              const Divider(),
              _buildAppInfoSection(context),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    Async<AppSettings> settingsAsync,
  ) {
    return Column(
      children: [
        settingsAsync.when(
          data: (settings) => SwitchListTile(
            secondary: const Icon(Icons.cloud_off),
            title: const Text('オフラインモード'),
            subtitle: const Text('通信を行わず、保存済みのコンテンツのみ利用します'),
            value: settings.isOfflineMode,
            onChanged: (value) => context.services.settings.setIsOfflineMode(
              isOfflineMode: value,
            ),
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
            onChanged: (value) =>
                context.services.settings.setIsIncognito(isIncognito: value),
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

  Widget _buildFeaturesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(context, '機能'),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('ダウンロードキュー'),
          onTap: () => appRouter.push(const DownloadsDest()),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(context, '設定'),
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

  Widget _buildAppInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(context, 'アプリ情報'),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('アプリについて'),
          onTap: () => appRouter.push(const AboutDest()),
        ),
      ],
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
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
