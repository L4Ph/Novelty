import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
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
    _initPackageInfo();
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
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('このアプリについて'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(_packageInfo.appName),
            subtitle: Text(
              'Version ${_packageInfo.version}+${_packageInfo.buildNumber}',
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('ライセンス'),
            onTap: () =>
                _launchUrl('https://github.com/L4Ph/Novelty/blob/main/LICENSE'),
          ),
          ListTile(
            title: const Text('ソースコード'),
            onTap: () => _launchUrl('https://github.com/L4Ph/Novelty'),
          ),
          ListTile(
            title: const Text('リリースノート'),
            onTap: () =>
                _launchUrl('https://github.com/L4Ph/Novelty/releases/latest'),
          ),
          const ListTile(
            title: Text('プライバシーポリシー'),
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
        ],
      ),
    );
  }
}
