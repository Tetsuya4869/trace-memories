import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/subscription.dart';
import '../services/subscription_database.dart';
import '../theme/app_theme.dart';
import '../widgets/subscription_card.dart';

class SubscriptionStatsScreen extends StatefulWidget {
  const SubscriptionStatsScreen({super.key});

  @override
  State<SubscriptionStatsScreen> createState() => _SubscriptionStatsScreenState();
}

class _SubscriptionStatsScreenState extends State<SubscriptionStatsScreen> {
  double _monthlyTotal = 0;
  double _yearlyTotal = 0;
  Map<SubscriptionCategory, double> _categoryTotals = {};
  List<Subscription> _upcomingBillings = [];
  int _activeCount = 0;
  int _totalCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final subscriptions = await SubscriptionDatabase.instance.readAll();
    final activeSubscriptions = subscriptions.where((s) => s.isActive).toList();
    final monthlyTotal = await SubscriptionDatabase.instance.calculateMonthlyTotal();
    final yearlyTotal = await SubscriptionDatabase.instance.calculateYearlyTotal();
    final categoryTotals = await SubscriptionDatabase.instance.calculateMonthlyByCategory();
    final upcomingBillings = await SubscriptionDatabase.instance.getUpcomingBillings(days: 7);

    setState(() {
      _monthlyTotal = monthlyTotal;
      _yearlyTotal = yearlyTotal;
      _categoryTotals = categoryTotals;
      _upcomingBillings = upcomingBillings;
      _activeCount = activeSubscriptions.length;
      _totalCount = subscriptions.length;
      _isLoading = false;
    });
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
                  child: CircularProgressIndicator(color: AppTheme.accentBlue),
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader()),
                    SliverToBoxAdapter(child: _buildSummarySection()),
                    SliverToBoxAdapter(child: _buildCategorySection()),
                    SliverToBoxAdapter(child: _buildUpcomingSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          const Text(
            '統計',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // メインサマリーカード
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accentBlue.withOpacity(0.3),
                  AppTheme.accentPurple.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.accentBlue.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '月額支出',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¥',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      _monthlyTotal.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '年額換算: ¥${_yearlyTotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // サブスク数カード
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'アクティブ',
                  '$_activeCount',
                  '件',
                  Icons.check_circle_outline,
                  AppTheme.accentBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '合計',
                  '$_totalCount',
                  '件',
                  Icons.list_alt,
                  AppTheme.accentPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '平均',
                  _activeCount > 0
                      ? '¥${(_monthlyTotal / _activeCount).toStringAsFixed(0)}'
                      : '¥0',
                  '/件',
                  Icons.analytics_outlined,
                  const Color(0xFF4ADE80),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatCard(
    String label,
    String value,
    String suffix,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                suffix,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    // 金額が0より大きいカテゴリのみを抽出してソート
    final nonZeroCategories = _categoryTotals.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (nonZeroCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'カテゴリ別支出',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...nonZeroCategories.map((entry) {
            final percentage = _monthlyTotal > 0
                ? (entry.value / _monthlyTotal) * 100
                : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CategorySpendingCard(
                category: entry.key,
                amount: entry.value,
                percentage: percentage,
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildUpcomingSection() {
    if (_upcomingBillings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.glassBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.glassBorder),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.event_available,
                color: AppTheme.textSecondary,
                size: 40,
              ),
              SizedBox(height: 12),
              Text(
                '7日以内の請求予定はありません',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Color(0xFFFB923C),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                '7日以内の請求予定',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFB923C).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_upcomingBillings.length}件',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFB923C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._upcomingBillings.map((sub) => _buildUpcomingItem(sub)),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildUpcomingItem(Subscription subscription) {
    final daysUntil = subscription.daysUntilNextBilling ?? 0;
    final isUrgent = daysUntil <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.glassBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent
              ? const Color(0xFFEF4444).withOpacity(0.5)
              : AppTheme.glassBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUrgent
                  ? const Color(0xFFEF4444).withOpacity(0.1)
                  : AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                subscription.category.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  daysUntil == 0
                      ? '今日請求'
                      : daysUntil == 1
                          ? '明日請求'
                          : '$daysUntil日後',
                  style: TextStyle(
                    fontSize: 12,
                    color: isUrgent
                        ? const Color(0xFFEF4444)
                        : AppTheme.textSecondary,
                    fontWeight: isUrgent ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '¥${subscription.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
