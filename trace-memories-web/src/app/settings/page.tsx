import Link from 'next/link'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: '設定 | TraceMemories',
}

const VERSION = '1.0.0'

export default function SettingsPage() {
  return (
    <div className="min-h-screen bg-primary-dark">
      {/* ヘッダー */}
      <div className="flex items-center gap-4 p-4 pt-safe border-b border-white/10">
        <Link
          href="/map"
          className="text-accent-blue text-sm"
        >
          ← 戻る
        </Link>
        <h1 className="text-text-primary font-semibold">設定</h1>
      </div>

      <div className="p-4 space-y-6">
        {/* アプリ情報 */}
        <section>
          <h2 className="text-text-secondary text-xs font-semibold uppercase tracking-wider mb-2 px-2">
            アプリ情報
          </h2>
          <div className="bg-secondary-dark rounded-[16px] divide-y divide-white/5">
            <SettingsRow label="バージョン" value={VERSION} />
          </div>
        </section>

        {/* 法務 */}
        <section>
          <h2 className="text-text-secondary text-xs font-semibold uppercase tracking-wider mb-2 px-2">
            法務
          </h2>
          <div className="bg-secondary-dark rounded-[16px] divide-y divide-white/5">
            <SettingsLink href="/settings/terms" label="利用規約" />
            <SettingsLink href="/settings/privacy" label="プライバシーポリシー" />
          </div>
        </section>

        {/* サポート */}
        <section>
          <h2 className="text-text-secondary text-xs font-semibold uppercase tracking-wider mb-2 px-2">
            サポート
          </h2>
          <div className="bg-secondary-dark rounded-[16px]">
            <a
              href="mailto:support@tracememories.app"
              className="flex items-center justify-between px-4 py-3"
            >
              <span className="text-text-primary text-sm">お問い合わせ</span>
              <span className="text-text-secondary text-sm">›</span>
            </a>
          </div>
        </section>
      </div>
    </div>
  )
}

function SettingsRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center justify-between px-4 py-3">
      <span className="text-text-primary text-sm">{label}</span>
      <span className="text-text-secondary text-sm">{value}</span>
    </div>
  )
}

function SettingsLink({ href, label }: { href: string; label: string }) {
  return (
    <Link href={href} className="flex items-center justify-between px-4 py-3">
      <span className="text-text-primary text-sm">{label}</span>
      <span className="text-text-secondary text-sm">›</span>
    </Link>
  )
}
