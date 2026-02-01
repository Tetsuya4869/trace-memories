import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/subscription.dart';
import '../services/subscription_database.dart';
import '../theme/app_theme.dart';
import 'subscription_form_screen.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  final Subscription subscription;

  const SubscriptionDetailScreen({super.key, required this.subscription});

  @override
  State<SubscriptionDetailScreen> createState() => _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  late Subscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.subscription;
  }

  Color get _categoryColor {
    switch (_subscription.category) {
      case SubscriptionCategory.entertainment:
        return const Color(0xFFE879F9);
      case SubscriptionCategory.productivity:
        return const Color(0xFF38BDF8);
      case SubscriptionCategory.lifestyle:
        return const Color(0xFF4ADE80);
      case SubscriptionCategory.utilities:
        return const Color(0xFFA78BFA);
      case SubscriptionCategory.gaming:
        return const Color(0xFFFB923C);
      case SubscriptionCategory.education:
        return const Color(0xFF60A5FA);
      case SubscriptionCategory.shopping:
        return const Color(0xFFF472B6);
      case SubscriptionCategory.other:
        return const Color(0xFF94A3B8);
    }
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => SubscriptionFormScreen(subscription: _subscription),
      ),
    );

    if (result == true && _subscription.id != null) {
      final updated = await SubscriptionDatabase.instance.read(_subscription.id!);
      if (updated != null && mounted) {
        setState(() => _subscription = updated);
      }
    }
  }

  Future<void> _toggleActive() async {
    final updated = _subscription.copyWith(isActive: !_subscription.isActive);
    await SubscriptionDatabase.instance.update(updated);
    setState(() => _subscription = updated);
  }

  Future<void> _deleteSubscription() async {
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
          '「${_subscription.name}」を削除しますか？\nこの操作は取り消せません。',
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

    if (confirmed == true && _subscription.id != null) {
      await SubscriptionDatabase.instance.delete(_subscription.id!);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  @override
  Widget build(BuildContext context) {
    final daysUntil = _subscription.daysUntilNextBilling;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // ヘッダーカード
                      _buildHeaderCard(),
                      const SizedBox(height: 20),
                      // 料金情報
                      _buildPriceSection(),
                      const SizedBox(height: 20),
                      // 詳細情報
                      _buildDetailsSection(daysUntil),
                      const SizedBox(height: 20),
                      // アクションボタン
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppTheme.textPrimary),
            onPressed: _navigateToEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
            onPressed: _deleteSubscription,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _categoryColor.withOpacity(0.2),
            _categoryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _categoryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                _subscription.category.icon,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _subscription.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _subscription.category.displayName,
              style: TextStyle(
                fontSize: 14,
                color: _categoryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (!_subscription.isActive) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pause_circle_outline, size: 16, color: AppTheme.textSecondary),
                  SizedBox(width: 4),
                  Text(
                    '一時停止中',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
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
                _subscription.price.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _subscription.billingCycle.shortName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppTheme.glassBorder),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildPriceInfo(
                  '月額換算',
                  '¥${_subscription.monthlyEquivalent.toStringAsFixed(0)}',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.glassBorder,
              ),
              Expanded(
                child: _buildPriceInfo(
                  '年額換算',
                  '¥${_subscription.yearlyEquivalent.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPriceInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(int? daysUntil) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '詳細情報',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.calendar_today,
            '開始日',
            _formatDate(_subscription.startDate),
          ),
          if (_subscription.nextBillingDate != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.schedule,
              '次回請求日',
              _formatDate(_subscription.nextBillingDate!),
              subtitle: daysUntil != null
                  ? (daysUntil == 0
                      ? '今日'
                      : daysUntil == 1
                          ? '明日'
                          : '$daysUntil日後')
                  : null,
              isUrgent: daysUntil != null && daysUntil <= 3,
            ),
          ],
          if (_subscription.description != null && _subscription.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.notes,
              'メモ',
              _subscription.description!,
            ),
          ],
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.access_time,
            '登録日',
            _formatDate(_subscription.createdAt),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    String? subtitle,
    bool isUrgent = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isUrgent
                ? const Color(0xFFEF4444).withOpacity(0.1)
                : AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isUrgent ? const Color(0xFFEF4444) : AppTheme.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isUrgent ? const Color(0xFFEF4444) : AppTheme.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUrgent ? const Color(0xFFEF4444) : AppTheme.accentBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _toggleActive,
            style: ElevatedButton.styleFrom(
              backgroundColor: _subscription.isActive
                  ? AppTheme.surfaceDark
                  : AppTheme.accentBlue,
              foregroundColor: AppTheme.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              _subscription.isActive
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,
            ),
            label: Text(
              _subscription.isActive ? '一時停止する' : '再開する',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _navigateToEdit,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: AppTheme.glassBorder),
            ),
            icon: const Icon(Icons.edit_outlined),
            label: const Text(
              '編集する',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
