/// サブスクリプションの請求サイクル
enum BillingCycle {
  monthly,
  yearly,
  weekly,
  custom,
}

/// サブスクリプションのカテゴリ
enum SubscriptionCategory {
  entertainment,    // エンタメ（Netflix, Spotify等）
  productivity,     // 仕事効率化（Office, Adobe等）
  lifestyle,        // ライフスタイル（ジム、雑誌等）
  utilities,        // ユーティリティ（クラウドストレージ等）
  gaming,           // ゲーム
  education,        // 教育・学習
  shopping,         // ショッピング（Amazon Prime等）
  other,            // その他
}

extension BillingCycleExtension on BillingCycle {
  String get displayName {
    switch (this) {
      case BillingCycle.monthly:
        return '月額';
      case BillingCycle.yearly:
        return '年額';
      case BillingCycle.weekly:
        return '週額';
      case BillingCycle.custom:
        return 'カスタム';
    }
  }

  String get shortName {
    switch (this) {
      case BillingCycle.monthly:
        return '/月';
      case BillingCycle.yearly:
        return '/年';
      case BillingCycle.weekly:
        return '/週';
      case BillingCycle.custom:
        return '';
    }
  }
}

extension SubscriptionCategoryExtension on SubscriptionCategory {
  String get displayName {
    switch (this) {
      case SubscriptionCategory.entertainment:
        return 'エンタメ';
      case SubscriptionCategory.productivity:
        return '仕事効率化';
      case SubscriptionCategory.lifestyle:
        return 'ライフスタイル';
      case SubscriptionCategory.utilities:
        return 'ユーティリティ';
      case SubscriptionCategory.gaming:
        return 'ゲーム';
      case SubscriptionCategory.education:
        return '教育・学習';
      case SubscriptionCategory.shopping:
        return 'ショッピング';
      case SubscriptionCategory.other:
        return 'その他';
    }
  }

  String get icon {
    switch (this) {
      case SubscriptionCategory.entertainment:
        return '🎬';
      case SubscriptionCategory.productivity:
        return '💼';
      case SubscriptionCategory.lifestyle:
        return '🏃';
      case SubscriptionCategory.utilities:
        return '☁️';
      case SubscriptionCategory.gaming:
        return '🎮';
      case SubscriptionCategory.education:
        return '📚';
      case SubscriptionCategory.shopping:
        return '🛒';
      case SubscriptionCategory.other:
        return '📦';
    }
  }
}

/// サブスクリプションモデル
class Subscription {
  final int? id;
  final String name;
  final double price;
  final BillingCycle billingCycle;
  final SubscriptionCategory category;
  final DateTime startDate;
  final DateTime? nextBillingDate;
  final String? description;
  final String? iconUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription({
    this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.category,
    required this.startDate,
    this.nextBillingDate,
    this.description,
    this.iconUrl,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// 月額換算コストを計算
  double get monthlyEquivalent {
    switch (billingCycle) {
      case BillingCycle.weekly:
        return price * 4.33; // 平均週数
      case BillingCycle.monthly:
        return price;
      case BillingCycle.yearly:
        return price / 12;
      case BillingCycle.custom:
        return price; // カスタムの場合はそのまま
    }
  }

  /// 年額換算コストを計算
  double get yearlyEquivalent {
    switch (billingCycle) {
      case BillingCycle.weekly:
        return price * 52;
      case BillingCycle.monthly:
        return price * 12;
      case BillingCycle.yearly:
        return price;
      case BillingCycle.custom:
        return price * 12; // カスタムの場合は月額として計算
    }
  }

  /// 次回請求日までの日数
  int? get daysUntilNextBilling {
    if (nextBillingDate == null) return null;
    return nextBillingDate!.difference(DateTime.now()).inDays;
  }

  /// データベース用にMapに変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'billing_cycle': billingCycle.index,
      'category': category.index,
      'start_date': startDate.toIso8601String(),
      'next_billing_date': nextBillingDate?.toIso8601String(),
      'description': description,
      'icon_url': iconUrl,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// MapからSubscriptionを作成
  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      billingCycle: BillingCycle.values[map['billing_cycle'] as int],
      category: SubscriptionCategory.values[map['category'] as int],
      startDate: DateTime.parse(map['start_date'] as String),
      nextBillingDate: map['next_billing_date'] != null
          ? DateTime.parse(map['next_billing_date'] as String)
          : null,
      description: map['description'] as String?,
      iconUrl: map['icon_url'] as String?,
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// コピーを作成
  Subscription copyWith({
    int? id,
    String? name,
    double? price,
    BillingCycle? billingCycle,
    SubscriptionCategory? category,
    DateTime? startDate,
    DateTime? nextBillingDate,
    String? description,
    String? iconUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
