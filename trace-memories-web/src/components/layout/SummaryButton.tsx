'use client'
import { useAppStore } from '@/store/appStore'
import GlassContainer from '@/components/ui/GlassContainer'

export default function SummaryButton() {
  const { setSummaryModalOpen } = useAppStore()

  return (
    <GlassContainer
      className="px-4 py-2 cursor-pointer hover:bg-white/20 transition-colors"
      onClick={() => setSummaryModalOpen(true)}
    >
      <span className="text-text-primary text-sm">今日のふりかえり ✨</span>
    </GlassContainer>
  )
}
