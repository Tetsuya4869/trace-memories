import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/subscription.dart';
import '../services/subscription_database.dart';
import '../theme/app_theme.dart';
import '../widgets/subscription_card.dart';
import 'subscription_form_screen.dart';
import 'subscription_detail_screen.dart';
import 'subscription_stats_screen.dart';

class SubscriptionListScreen extends StatefulWidget {
  const SubscriptionListScreen({super.key});

  @override
  State<SubscriptionListScreen> createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  List<Subscription> _subscriptions = [];
  double _monthlyTotal = 0;
  double _yearlyTotal = 0;
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Web版ではデモデータを追加
    if (kIsWeb) {
      await SubscriptionDatabase.instance.addDemoData();
    }

    final subscriptions = await SubscriptionDatabase.instance.readAll();
    final monthlyTotal = await SubscriptionDatabase.instance.calculateMonthlyTotal();
    final yearlyTotal = await SubscriptionDatabase.instance.calculateYearlyTotal();

    setState(() {
      _subscriptions = subscriptions;
      _monthlyTotal = monthlyTotal;
      _yearlyTotal = yearlyTotal;
      _isLoading = false;
    });
  }

  Future<void> _deleteSubscription(Subscription subscription) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '削除の確認',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          '「${subscription.name}」を削除しますか？',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed == true && subscription.id != null) {
      await SubscriptionDatabase.instance.delete(subscription.id!);
      _loadData();
    }
  }

  void _navigateToForm({Subscription? subscription}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => SubscriptionFormScreen(subscription: subscription),
      ),
    );

    if (result == true) {
      _loadData();
    }
  }

  void _navigateToDetail(Subscription subscription) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => SubscriptionDetailScreen(subscription: subscription),
      ),
    );

    if (result == true) {
      _loadData();
    }
  }

  void _navigateToStats() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubscriptionStatsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.accentBlue,
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    // ヘッダー
                    SliverToBoxAdapter(
                      child: _buildHeader(),
                    ),
                    // サマリーカード
                    SliverToBoxAdapter(
                      child: _buildSummaryCards(),
                    ),
                    // セクションタイトル
                    SliverToBoxAdapter(
                      child: _buildSectionTitle(),
                    ),
                    // サブスクリプション一覧
                    _subscriptions.isEmpty
                        ? SliverToBoxAdapter(
                            child: _buildEmptyState(),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final subscription = _subscriptions[index];
                                return SubscriptionCard(
                                  subscription: subscription,
                                  onTap: () => _navigateToDetail(subscription),
                                  onDelete: () => _deleteSubscription(subscription),
                                );
                              },
                              childCount: _subscriptions.length,
                            ),
                          ),
                    // 下部の余白
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: AppTheme.accentBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 500.ms, duration: 300.ms),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'サブスク管理',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_subscriptions.where((s) => s.isActive).length}件のアクティブなサブスク',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.bar_chart_rounded,
              color: AppTheme.textPrimary,
              size: 28,
            ),
            onPressed: _navigateToStats,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SubscriptionSummaryCard(
              title: '月額',
              amount: _monthlyTotal,
              icon: Icons.calendar_today,
              color: AppTheme.accentBlue,
              subtitle: '毎月の支払い',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SubscriptionSummaryCard(
              title: '年額',
              amount: _yearlyTotal,
              icon: Icons.calendar_month,
              color: AppTheme.accentPurple,
              subtitle: '年間の支払い',
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'すべてのサブスク',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            '${_subscriptions.length}件',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.glassBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.subscriptions_outlined,
              size: 40,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'サブスクがありません',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '右下の＋ボタンから\nサブスクを追加しましょう',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        border: Border(
          top: BorderSide(
            color: AppTheme.glassBorder,
            width: 1,
          ),
        ),
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        indicatorColor: AppTheme.accentBlue.withOpacity(0.2),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            _navigateToStats();
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined, color: AppTheme.textSecondary),
            selectedIcon: Icon(Icons.list_alt, color: AppTheme.accentBlue),
            label: '一覧',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline, color: AppTheme.textSecondary),
            selectedIcon: Icon(Icons.pie_chart, color: AppTheme.accentBlue),
            label: '統計',
          ),
        ],
      ),
    );
  }
}
