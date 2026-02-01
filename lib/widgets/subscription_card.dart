import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/subscription.dart';
import '../theme/app_theme.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    this.onTap,
    this.onDelete,
  });

  Color get _categoryColor {
    switch (subscription.category) {
      case SubscriptionCategory.entertainment:
        return const Color(0xFFE879F9); // pink
      case SubscriptionCategory.productivity:
        return const Color(0xFF38BDF8); // blue
      case SubscriptionCategory.lifestyle:
        return const Color(0xFF4ADE80); // green
      case SubscriptionCategory.utilities:
        return const Color(0xFFA78BFA); // purple
      case SubscriptionCategory.gaming:
        return const Color(0xFFFB923C); // orange
      case SubscriptionCategory.education:
        return const Color(0xFF60A5FA); // light blue
      case SubscriptionCategory.shopping:
        return const Color(0xFFF472B6); // rose
      case SubscriptionCategory.other:
        return const Color(0xFF94A3B8); // gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysUntil = subscription.daysUntilNextBilling;
    final isUrgent = daysUntil != null && daysUntil <= 3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.glassBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUrgent
                ? const Color(0xFFEF4444).withOpacity(0.5)
                : AppTheme.glassBorder,
            width: isUrgent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // カテゴリカラーのアクセント
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _categoryColor,
                        _categoryColor.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // カテゴリアイコン
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _categoryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          subscription.category.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // サブスクリプション情報
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  subscription.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!subscription.isActive)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '停止中',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subscription.category.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: _categoryColor,
                            ),
                          ),
                          if (daysUntil != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 14,
                                  color: isUrgent
                                      ? const Color(0xFFEF4444)
                                      : AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  daysUntil == 0
                                      ? '今日請求'
                                      : daysUntil == 1
                                          ? '明日請求'
                                          : '$daysUntil日後に請求',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isUrgent
                                        ? const Color(0xFFEF4444)
                                        : AppTheme.textSecondary,
                                    fontWeight: isUrgent
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    // 価格
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '¥${subscription.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          subscription.billingCycle.shortName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // 削除ボタン（スワイプ代替）
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        onPressed: onDelete,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
  }
}

/// サマリーカード（月額/年額表示用）
class SubscriptionSummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const SubscriptionSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '¥${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// カテゴリ別支出カード
class CategorySpendingCard extends StatelessWidget {
  final SubscriptionCategory category;
  final double amount;
  final double percentage;

  const CategorySpendingCard({
    super.key,
    required this.category,
    required this.amount,
    required this.percentage,
  });

  Color get _categoryColor {
    switch (category) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.glassBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                category.icon,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Text(
                '¥${amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _categoryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppTheme.surfaceDark,
              valueColor: AlwaysStoppedAnimation<Color>(_categoryColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
