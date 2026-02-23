import Link from 'next/link'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: '利用規約 | TraceMemories',
}

const TERMS = `第1条（適用）
本利用規約は、TraceMemories（以下「本アプリ」）の利用に関する条件を定めるものです。

第2条（禁止事項）
ユーザーは以下の行為を行ってはなりません。
・法令または公序良俗に違反する行為
・不正アクセス、ハッキング等の行為
・本アプリの運営を妨害する行為

第3条（免責事項）
本アプリは、位置情報や写真データの正確性・完全性を保証しません。本アプリの使用によって生じた損害については、一切の責任を負いかねます。

第4条（サービスの変更・停止）
当社は、予告なく本アプリのサービス内容を変更・停止することがあります。

第5条（準拠法）
本規約は日本法に準拠し、解釈されます。

最終更新日: 2026年2月1日`

export default function TermsPage() {
  return (
    <div className="min-h-screen bg-primary-dark">
      <div className="flex items-center gap-4 p-4 pt-safe border-b border-white/10">
        <Link href="/settings" className="text-accent-blue text-sm">
          ← 戻る
        </Link>
        <h1 className="text-text-primary font-semibold">利用規約</h1>
      </div>
      <div className="p-6">
        <pre className="text-text-secondary text-sm leading-relaxed whitespace-pre-wrap font-sans">
          {TERMS}
        </pre>
      </div>
    </div>
  )
}
