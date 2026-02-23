'use client'
import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { motion, AnimatePresence } from 'framer-motion'
import OnboardingSlide from '@/components/onboarding/OnboardingSlide'
import PageIndicator from '@/components/onboarding/PageIndicator'
import Button from '@/components/ui/Button'
import { markOnboardingDone } from '@/lib/storage'

const SLIDES = [
  {
    emoji: '🗺️',
    title: '今日の軌跡を地図に',
    description: 'GPSで移動ルートをリアルタイムに記録。\n歩いた道が美しいラインとして地図に残ります。',
  },
  {
    emoji: '📸',
    title: '写真を地図上にピン留め',
    description: 'GPS付き写真をインポートすると、\n撮影場所のマーカーとして地図に表示されます。',
  },
  {
    emoji: '📍',
    title: '位置情報のアクセスについて',
    description: 'TraceMemoriesは位置情報と写真ライブラリを使用します。\nデータはすべてこのデバイスにのみ保存されます。',
  },
]

export default function OnboardingPage() {
  const [page, setPage] = useState(0)
  const router = useRouter()
  const isLast = page === SLIDES.length - 1

  function handleNext() {
    if (isLast) {
      markOnboardingDone()
      router.replace('/map')
    } else {
      setPage((p) => p + 1)
    }
  }

  function handleSkip() {
    markOnboardingDone()
    router.replace('/map')
  }

  return (
    <div className="flex flex-col min-h-screen bg-app-gradient">
      {/* スキップボタン */}
      <div className="flex justify-end p-4 pt-safe">
        <Button variant="ghost" size="sm" onClick={handleSkip}>
          スキップ
        </Button>
      </div>

      {/* スライド */}
      <div className="flex-1 relative overflow-hidden">
        <AnimatePresence mode="wait">
          <motion.div
            key={page}
            className="absolute inset-0"
            initial={{ x: 60, opacity: 0 }}
            animate={{ x: 0, opacity: 1 }}
            exit={{ x: -60, opacity: 0 }}
            transition={{ duration: 0.3 }}
          >
            <OnboardingSlide
              {...SLIDES[page]}
              isActive={true}
            />
          </motion.div>
        </AnimatePresence>
      </div>

      {/* インジケーター＆ボタン */}
      <div className="flex flex-col items-center gap-6 pb-12 pb-safe px-8">
        <PageIndicator total={SLIDES.length} current={page} />
        <Button
          size="lg"
          className="w-full"
          onClick={handleNext}
        >
          {isLast ? 'はじめる' : '次へ'}
        </Button>
      </div>
    </div>
  )
}
