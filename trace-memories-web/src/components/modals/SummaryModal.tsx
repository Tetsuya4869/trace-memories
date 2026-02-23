'use client'
import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useAppStore } from '@/store/appStore'
import { useSummary } from '@/hooks/useSummary'
import { formatDistance } from '@/lib/distance'
import GlassContainer from '@/components/ui/GlassContainer'
import Button from '@/components/ui/Button'
import LoadingSpinner from '@/components/ui/LoadingSpinner'
import type { DaySummary } from '@/types/summary'

export default function SummaryModal() {
  const { summaryModalOpen, setSummaryModalOpen } = useAppStore()
  const { generate } = useSummary()
  const [summary, setSummary] = useState<DaySummary | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    if (!summaryModalOpen) return
    setLoading(true)
    generate()
      .then(setSummary)
      .finally(() => setLoading(false))
  }, [summaryModalOpen, generate])

  return (
    <AnimatePresence>
      {summaryModalOpen && (
        <>
          {/* オーバーレイ */}
          <motion.div
            className="fixed inset-0 bg-black/50 z-40"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={() => setSummaryModalOpen(false)}
          />

          {/* モーダル */}
          <motion.div
            className="fixed inset-x-4 bottom-8 z-50"
            initial={{ y: 60, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: 60, opacity: 0 }}
            transition={{ type: 'spring', stiffness: 300, damping: 30 }}
          >
            <GlassContainer className="p-6">
              <h2 className="text-lg font-bold text-text-primary mb-4">今日のふりかえり</h2>

              {loading ? (
                <div className="flex justify-center py-6">
                  <LoadingSpinner size={32} />
                </div>
              ) : summary ? (
                <>
                  <p className="text-text-primary whitespace-pre-line leading-relaxed mb-4">
                    {summary.text}
                  </p>

                  <div className="flex gap-4 pt-3 border-t border-white/10">
                    <div className="flex-1 text-center">
                      <div className="text-accent-blue font-bold">
                        {formatDistance(summary.totalDistanceM)}
                      </div>
                      <div className="text-text-secondary text-xs mt-0.5">歩いた距離</div>
                    </div>
                    <div className="flex-1 text-center">
                      <div className="text-accent-purple font-bold">
                        {summary.photoCount} 枚
                      </div>
                      <div className="text-text-secondary text-xs mt-0.5">写真</div>
                    </div>
                  </div>
                </>
              ) : null}

              <Button
                variant="glass"
                className="w-full mt-4"
                onClick={() => setSummaryModalOpen(false)}
              >
                閉じる
              </Button>
            </GlassContainer>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  )
}
