'use client'
import { useEffect, useRef } from 'react'
import dynamic from 'next/dynamic'
import { motion, AnimatePresence } from 'framer-motion'
import { useGPS } from '@/hooks/useGPS'
import { usePhotos } from '@/hooks/usePhotos'
import { useMapStore } from '@/store/mapStore'
import { useAppStore } from '@/store/appStore'
import GlassContainer from '@/components/ui/GlassContainer'
import Button from '@/components/ui/Button'
import AppTitle from '@/components/layout/AppTitle'
import StatusBadge from '@/components/layout/StatusBadge'
import SummaryButton from '@/components/layout/SummaryButton'
import SettingsButton from '@/components/layout/SettingsButton'
import TimelineBar from '@/components/map/TimelineBar'
import SummaryModal from '@/components/modals/SummaryModal'
import { DEMO_ROUTE } from '@/lib/demoData'

// Mapbox は SSR 不可のため動的インポート
const MapView = dynamic(() => import('@/components/map/MapView'), {
  ssr: false,
  loading: () => (
    <div className="w-full h-full flex items-center justify-center bg-primary-dark">
      <div className="text-text-secondary text-sm">地図を読み込み中...</div>
    </div>
  ),
})

export default function MapPage() {
  const { startTracking, stopTracking } = useGPS()
  const { loadSavedPhotos, importPhotos } = usePhotos()
  const { isTracking, gpsPoints, setGpsPoints } = useMapStore()
  const { locationPermission, isDemoMode, setDemoMode } = useAppStore()
  const photoInputRef = useRef<HTMLInputElement>(null)

  // 起動時に保存済み写真をロード
  useEffect(() => {
    loadSavedPhotos()
  }, [loadSavedPhotos])

  function handleTrackingToggle() {
    if (isTracking) {
      stopTracking()
    } else {
      startTracking()
    }
  }

  function handleDemoMode() {
    setGpsPoints(DEMO_ROUTE)
    setDemoMode(true)
  }

  function handlePhotoImport(e: React.ChangeEvent<HTMLInputElement>) {
    if (e.target.files && e.target.files.length > 0) {
      importPhotos(e.target.files)
    }
  }

  return (
    <div className="flex flex-col h-screen bg-primary-dark">
      {/* 地図（全画面） */}
      <div className="flex-1 relative">
        <MapView />

        {/* 位置情報拒否バナー */}
        <AnimatePresence>
          {locationPermission === 'denied' && (
            <motion.div
              className="absolute top-0 inset-x-0 z-10"
              initial={{ y: -60 }}
              animate={{ y: 0 }}
              exit={{ y: -60 }}
            >
              <div className="mx-4 mt-4">
                <GlassContainer className="px-4 py-3 border-red-500/30 bg-red-500/10">
                  <p className="text-red-400 text-sm text-center">
                    位置情報が無効です。デバイスの設定から許可してください。
                  </p>
                </GlassContainer>
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* ヘッダーオーバーレイ */}
        <div className="absolute top-4 inset-x-4 flex items-center gap-3 z-10">
          <GlassContainer className="flex-1 px-4 py-2.5 flex items-center justify-between">
            <AppTitle />
            <StatusBadge />
          </GlassContainer>
          <SettingsButton />
        </div>

        {/* 写真インポートボタン */}
        <div className="absolute bottom-32 right-4 z-10">
          <input
            ref={photoInputRef}
            type="file"
            multiple
            accept="image/*"
            className="hidden"
            onChange={handlePhotoImport}
          />
          <GlassContainer
            className="w-12 h-12 flex items-center justify-center cursor-pointer hover:bg-white/20 transition-colors"
            onClick={() => photoInputRef.current?.click()}
          >
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
              <circle cx="8.5" cy="8.5" r="1.5" />
              <polyline points="21 15 16 10 5 21" />
            </svg>
          </GlassContainer>
        </div>
      </div>

      {/* ボトムパネル */}
      <div className="bg-primary-dark/80 backdrop-blur-[8px] pb-safe">
        <TimelineBar />

        <div className="flex items-center gap-3 px-4 pb-4">
          {/* GPS トラッキングボタン */}
          <Button
            variant={isTracking ? 'glass' : 'primary'}
            className="flex-1"
            onClick={handleTrackingToggle}
          >
            {isTracking ? '⏹ 記録停止' : '▶ 記録開始'}
          </Button>

          {/* デモモードボタン（軌跡なし時のみ） */}
          {gpsPoints.length === 0 && !isDemoMode && (
            <Button variant="glass" size="sm" onClick={handleDemoMode}>
              デモ
            </Button>
          )}

          {/* サマリーボタン */}
          <SummaryButton />
        </div>
      </div>

      {/* サマリーモーダル */}
      <SummaryModal />
    </div>
  )
}
