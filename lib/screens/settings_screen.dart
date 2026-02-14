import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 60,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '設定',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // アプリ情報セクション
                      _buildSectionTitle('アプリ情報'),
                      const SizedBox(height: 12),
                      _buildSettingsCard(context, [
                        _SettingsItem(
                          icon: Icons.info_outline,
                          title: 'バージョン',
                          trailing: const Text(
                            '1.0.0',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 24),

                      // 法務セクション
                      _buildSectionTitle('法務・ポリシー'),
                      const SizedBox(height: 12),
                      _buildSettingsCard(context, [
                        _SettingsItem(
                          icon: Icons.description_outlined,
                          title: '利用規約',
                          onTap: () => _showLegalPage(context, 'terms'),
                        ),
                        _SettingsItem(
                          icon: Icons.shield_outlined,
                          title: 'プライバシーポリシー',
                          onTap: () => _showLegalPage(context, 'privacy'),
                        ),
                        _SettingsItem(
                          icon: Icons.code,
                          title: 'オープンソースライセンス',
                          onTap: () => showLicensePage(
                            context: context,
                            applicationName: 'TraceMemories',
                            applicationVersion: '1.0.0',
                            applicationIcon: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.map_outlined,
                                size: 48,
                                color: AppTheme.accentBlue,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 24),

                      // サポートセクション
                      _buildSectionTitle('サポート'),
                      const SizedBox(height: 12),
                      _buildSettingsCard(context, [
                        _SettingsItem(
                          icon: Icons.help_outline,
                          title: 'ヘルプ・お問い合わせ',
                          onTap: () => _showHelpDialog(context),
                        ),
                      ]),
                      const SizedBox(height: 40),

                      // フッター
                      Center(
                        child: Column(
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                                children: [
                                  TextSpan(text: 'Trace', style: TextStyle(color: Colors.white)),
                                  TextSpan(text: 'Memories', style: TextStyle(color: AppTheme.accentBlue)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'あなたの日々を、地図に刻む',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, letterSpacing: 1.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 戻るボタン
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<_SettingsItem> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppTheme.glassBlur, sigmaY: AppTheme.glassBlur),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.glassBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.glassBorder, width: 1),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: AppTheme.accentBlue, size: 22),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    trailing: item.trailing ?? (item.onTap != null
                        ? const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20)
                        : null),
                    onTap: item.onTap,
                  ),
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showLegalPage(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _LegalPageScreen(type: type),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mail_outline, color: AppTheme.accentBlue, size: 40),
                const SizedBox(height: 16),
                const Text(
                  'お問い合わせ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ご質問やご要望がございましたら、\n以下のメールアドレスまでご連絡ください。',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'support@tracememories.app',
                  style: TextStyle(color: AppTheme.accentBlue, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentBlue,
                      foregroundColor: AppTheme.primaryDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('閉じる', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  _SettingsItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });
}

class _LegalPageScreen extends StatelessWidget {
  final String type;

  const _LegalPageScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    final isTerms = type == 'terms';

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 60,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTerms ? '利用規約' : 'プライバシーポリシー',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '最終更新日: 2026年2月1日',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isTerms ? _termsOfService : _privacyPolicy,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.8,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  static const String _privacyPolicy = '''
TraceMemories（以下「本アプリ」）は、ユーザーのプライバシーを尊重し、個人情報の保護に努めています。

■ 収集する情報

【位置情報】
本アプリは、ユーザーの移動履歴を記録・表示するために位置情報を収集します。
・位置情報はユーザーの端末内にのみ保存されます
・サーバーへの送信は行いません
・ユーザーはいつでも位置情報の収集を停止できます

【写真データ】
本アプリは、思い出を地図上に表示するために写真ライブラリへアクセスします。
・写真データは端末内でのみ処理されます
・写真がサーバーにアップロードされることはありません
・アクセスする写真はユーザーが許可したものに限ります

■ 第三者サービス

本アプリは地図表示のためにMapbox社のサービスを利用しています。
Mapboxのプライバシーポリシー: https://www.mapbox.com/legal/privacy

■ データの保存

・すべてのユーザーデータは、ユーザーの端末内にローカル保存されます
・ユーザーはいつでもアプリ内のデータを削除できます

■ お子様のプライバシー

本アプリは13歳未満のお子様を対象としていません。13歳未満のお子様から意図的に個人情報を収集することはありません。

■ プライバシーポリシーの変更

本プライバシーポリシーは予告なく変更される場合があります。変更があった場合は、本ページにて通知します。

■ お問い合わせ

プライバシーに関するご質問は、以下までご連絡ください：
support@tracememories.app''';

  static const String _termsOfService = '''
本利用規約（以下「本規約」）は、TraceMemories（以下「本アプリ」）の利用に関する条件を定めるものです。本アプリをご利用いただくことにより、本規約に同意いただいたものとみなします。

■ サービスの概要

本アプリは、ユーザーの移動履歴を地図上に美しく可視化し、撮影した写真を位置情報と共に表示する個人向けアプリケーションです。

■ 利用条件

・本アプリの利用にあたり、ユーザーは自己の責任において利用するものとします
・13歳未満の方は本アプリを利用できません
・本アプリの機能を悪用・不正利用する行為を禁止します

■ データについて

・本アプリで記録されるデータ（位置情報、写真等）は、すべてユーザーの端末内に保存されます
・本アプリの削除により、アプリ内のデータは消去されます
・端末のバックアップ機能を通じてデータが保存される場合があります

■ 免責事項

・本アプリは「現状のまま」で提供されます
・位置情報の精度はGPS環境や端末の性能に依存します
・本アプリの利用により生じたいかなる損害についても、開発者は責任を負いません
・通信障害、端末の故障等によるデータの消失について、開発者は責任を負いません

■ 知的財産権

本アプリに含まれるすべてのコンテンツ（デザイン、コード、テキスト等）の知的財産権は開発者に帰属します。

■ 規約の変更

本規約は予告なく変更される場合があります。変更後の規約は、本アプリ内での表示をもって効力を生じるものとします。

■ 準拠法・管轄裁判所

本規約の解釈および適用は日本法に準拠するものとし、紛争が生じた場合は東京地方裁判所を第一審の専属的合意管轄裁判所とします。

■ お問い合わせ

本規約に関するご質問は、以下までご連絡ください：
support@tracememories.app''';
}
