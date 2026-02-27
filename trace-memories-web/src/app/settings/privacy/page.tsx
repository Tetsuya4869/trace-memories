import Link from 'next/link'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'プライバシーポリシー | TraceMemories',
}

const PRIVACY = `TraceMemoriesは、ユーザーのプライバシーを尊重し、個人情報の保護に努めています。

■ 収集する情報

位置情報
本アプリは移動履歴を記録・表示するために位置情報を収集します。
・位置情報はユーザーの端末内にのみ保存されます
・サーバーへの送信は行いません
・ユーザーはいつでも位置情報の収集を停止できます

写真データ
本アプリは思い出を地図上に表示するために写真を使用します。
・写真データは端末内でのみ処理されます（IndexedDB）
・写真がサーバーにアップロードされることはありません

■ 第三者サービス

Mapbox
地図表示のためにMapbox社のサービスを利用しています。
Mapboxのプライバシーポリシー: https://www.mapbox.com/legal/privacy

■ お問い合わせ

support@tracememories.app

最終更新日: 2026年2月1日`

export default function PrivacyPage() {
  return (
    <div className="min-h-screen bg-primary-dark">
      <div className="flex items-center gap-4 p-4 pt-safe border-b border-white/10">
        <Link href="/settings" className="text-accent-blue text-sm">
          ← 戻る
        </Link>
        <h1 className="text-text-primary font-semibold">プライバシーポリシー</h1>
      </div>
      <div className="p-6">
        <pre className="text-text-secondary text-sm leading-relaxed whitespace-pre-wrap font-sans">
          {PRIVACY}
        </pre>
      </div>
    </div>
  )
}
