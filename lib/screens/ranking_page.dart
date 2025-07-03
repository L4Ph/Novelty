import 'package:flutter/material.dart';
import 'package:novelty/widgets/ranking_list.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '日間'),
            Tab(text: '週間'),
            Tab(text: '月間'),
            Tab(text: '四半期'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RankingList(rankingType: 'd', key: PageStorageKey('d')),
          RankingList(rankingType: 'w', key: PageStorageKey('w')),
          RankingList(rankingType: 'm', key: PageStorageKey('m')),
          RankingList(rankingType: 'q', key: PageStorageKey('q')),
        ],
      ),
    );
  }
}
