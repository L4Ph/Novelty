import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// "アプリについて"ページのウィジェット。
class AboutPage extends StatefulWidget {
  /// コンストラクタ。
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  var _packageInfo = PackageInfo(
    appName: 'Novelty',
    packageName: 'moe.l4ph.novelty',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    unawaited(_initPackageInfo());
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

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
        title: const Text('アプリについて'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 32),
          Center(
            child: SvgPicture.asset(
              'assets/app_icon/base.svg',
              width: 100,
              height: 100,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            title: const Text('バージョン'),
            subtitle: Text(
              '${_packageInfo.version} (${_packageInfo.buildNumber})',
            ),
          ),
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
                applicationName: _packageInfo.appName,
                applicationVersion: _packageInfo.version,
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
        ],
      ),
    );
  }
}
