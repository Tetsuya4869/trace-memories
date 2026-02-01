import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/subscription.dart';

/// サブスクリプション管理用データベースサービス
class SubscriptionDatabase {
  static final SubscriptionDatabase instance = SubscriptionDatabase._init();
  static Database? _database;

  // Web用のインメモリストレージ
  static final List<Subscription> _webStorage = [];
  static int _webIdCounter = 1;

  SubscriptionDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('subscriptions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        billing_cycle INTEGER NOT NULL,
        category INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        next_billing_date TEXT,
        description TEXT,
        icon_url TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  /// サブスクリプションを追加
  Future<Subscription> create(Subscription subscription) async {
    if (kIsWeb) {
      final newSubscription = subscription.copyWith(id: _webIdCounter++);
      _webStorage.add(newSubscription);
      return newSubscription;
    }

    final db = await instance.database;
    final id = await db.insert('subscriptions', subscription.toMap());
    return subscription.copyWith(id: id);
  }

  /// すべてのサブスクリプションを取得
  Future<List<Subscription>> readAll() async {
    if (kIsWeb) {
      return List.from(_webStorage);
    }

    final db = await instance.database;
    final result = await db.query(
      'subscriptions',
      orderBy: 'next_billing_date ASC',
    );
    return result.map((json) => Subscription.fromMap(json)).toList();
  }

  /// アクティブなサブスクリプションのみを取得
  Future<List<Subscription>> readActive() async {
    if (kIsWeb) {
      return _webStorage.where((s) => s.isActive).toList();
    }

    final db = await instance.database;
    final result = await db.query(
      'subscriptions',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'next_billing_date ASC',
    );
    return result.map((json) => Subscription.fromMap(json)).toList();
  }

  /// IDでサブスクリプションを取得
  Future<Subscription?> read(int id) async {
    if (kIsWeb) {
      try {
        return _webStorage.firstWhere((s) => s.id == id);
      } catch (_) {
        return null;
      }
    }

    final db = await instance.database;
    final maps = await db.query(
      'subscriptions',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Subscription.fromMap(maps.first);
    }
    return null;
  }

  /// サブスクリプションを更新
  Future<int> update(Subscription subscription) async {
    if (kIsWeb) {
      final index = _webStorage.indexWhere((s) => s.id == subscription.id);
      if (index != -1) {
        _webStorage[index] = subscription;
        return 1;
      }
      return 0;
    }

    final db = await instance.database;
    return db.update(
      'subscriptions',
      subscription.toMap(),
      where: 'id = ?',
      whereArgs: [subscription.id],
    );
  }

  /// サブスクリプションを削除
  Future<int> delete(int id) async {
    if (kIsWeb) {
      final index = _webStorage.indexWhere((s) => s.id == id);
      if (index != -1) {
        _webStorage.removeAt(index);
        return 1;
      }
      return 0;
    }

    final db = await instance.database;
    return await db.delete(
      'subscriptions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// カテゴリ別のサブスクリプションを取得
  Future<List<Subscription>> readByCategory(SubscriptionCategory category) async {
    if (kIsWeb) {
      return _webStorage.where((s) => s.category == category && s.isActive).toList();
    }

    final db = await instance.database;
    final result = await db.query(
      'subscriptions',
      where: 'category = ? AND is_active = ?',
      whereArgs: [category.index, 1],
      orderBy: 'next_billing_date ASC',
    );
    return result.map((json) => Subscription.fromMap(json)).toList();
  }

  /// 月額合計を計算
  Future<double> calculateMonthlyTotal() async {
    final subscriptions = await readActive();
    return subscriptions.fold(0.0, (sum, sub) => sum + sub.monthlyEquivalent);
  }

  /// 年額合計を計算
  Future<double> calculateYearlyTotal() async {
    final subscriptions = await readActive();
    return subscriptions.fold(0.0, (sum, sub) => sum + sub.yearlyEquivalent);
  }

  /// カテゴリ別の月額合計を計算
  Future<Map<SubscriptionCategory, double>> calculateMonthlyByCategory() async {
    final subscriptions = await readActive();
    final result = <SubscriptionCategory, double>{};

    for (final category in SubscriptionCategory.values) {
      result[category] = subscriptions
          .where((sub) => sub.category == category)
          .fold(0.0, (sum, sub) => sum + sub.monthlyEquivalent);
    }

    return result;
  }

  /// 次回請求日が近いサブスクリプションを取得（7日以内）
  Future<List<Subscription>> getUpcomingBillings({int days = 7}) async {
    final subscriptions = await readActive();
    final now = DateTime.now();
    final threshold = now.add(Duration(days: days));

    return subscriptions.where((sub) {
      if (sub.nextBillingDate == null) return false;
      return sub.nextBillingDate!.isAfter(now) &&
          sub.nextBillingDate!.isBefore(threshold);
    }).toList();
  }

  /// データベースを閉じる
  Future close() async {
    if (kIsWeb) return;

    final db = await instance.database;
    db.close();
  }

  /// デモデータを追加（Web用）
  Future<void> addDemoData() async {
    if (_webStorage.isNotEmpty) return;

    final demoSubscriptions = [
      Subscription(
        name: 'Netflix',
        price: 1490,
        billingCycle: BillingCycle.monthly,
        category: SubscriptionCategory.entertainment,
        startDate: DateTime(2023, 1, 15),
        nextBillingDate: DateTime.now().add(const Duration(days: 12)),
        description: 'スタンダードプラン',
      ),
      Subscription(
        name: 'Spotify Premium',
        price: 980,
        billingCycle: BillingCycle.monthly,
        category: SubscriptionCategory.entertainment,
        startDate: DateTime(2022, 6, 1),
        nextBillingDate: DateTime.now().add(const Duration(days: 5)),
        description: '個人プラン',
      ),
      Subscription(
        name: 'Adobe Creative Cloud',
        price: 6480,
        billingCycle: BillingCycle.monthly,
        category: SubscriptionCategory.productivity,
        startDate: DateTime(2023, 3, 10),
        nextBillingDate: DateTime.now().add(const Duration(days: 18)),
        description: 'コンプリートプラン',
      ),
      Subscription(
        name: 'Amazon Prime',
        price: 5900,
        billingCycle: BillingCycle.yearly,
        category: SubscriptionCategory.shopping,
        startDate: DateTime(2021, 11, 20),
        nextBillingDate: DateTime.now().add(const Duration(days: 45)),
        description: '年間プラン',
      ),
      Subscription(
        name: 'iCloud+',
        price: 400,
        billingCycle: BillingCycle.monthly,
        category: SubscriptionCategory.utilities,
        startDate: DateTime(2022, 9, 5),
        nextBillingDate: DateTime.now().add(const Duration(days: 3)),
        description: '200GB ストレージ',
      ),
      Subscription(
        name: 'Nintendo Switch Online',
        price: 2400,
        billingCycle: BillingCycle.yearly,
        category: SubscriptionCategory.gaming,
        startDate: DateTime(2023, 7, 1),
        nextBillingDate: DateTime.now().add(const Duration(days: 120)),
        description: '個人プラン',
      ),
      Subscription(
        name: 'Duolingo Plus',
        price: 1100,
        billingCycle: BillingCycle.monthly,
        category: SubscriptionCategory.education,
        startDate: DateTime(2024, 1, 1),
        nextBillingDate: DateTime.now().add(const Duration(days: 8)),
        description: '言語学習',
      ),
    ];

    for (final sub in demoSubscriptions) {
      await create(sub);
    }
  }
}
