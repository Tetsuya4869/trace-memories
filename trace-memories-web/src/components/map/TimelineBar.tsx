'use client'
import { useRef, useCallback } from 'react'
import { useMapStore } from '@/store/mapStore'
import GlassContainer from '@/components/ui/GlassContainer'

export default function TimelineBar() {
  const { timelineProgress, setTimelineProgress, gpsPoints } = useMapStore()
  const trackRef = useRef<HTMLDivElement>(null)

  const handlePointerEvent = useCallback(
    (clientX: number) => {
      if (!trackRef.current) return
      const rect = trackRef.current.getBoundingClientRect()
      const newProgress = (clientX - rect.left) / rect.width
      setTimelineProgress(Math.max(0, Math.min(1, newProgress)))
    },
    [setTimelineProgress]
  )

  if (gpsPoints.length === 0) return null

  return (
    <GlassContainer className="px-4 py-3 mx-4 mb-4">
      <div className="flex items-center gap-3">
        <span className="text-text-secondary text-xs">start</span>
        <div
          ref={trackRef}
          className="flex-1 relative h-1.5 bg-white/20 rounded-full cursor-pointer"
          onPointerDown={(e) => {
            e.currentTarget.setPointerCapture(e.pointerId)
            handlePointerEvent(e.clientX)
          }}
          onPointerMove={(e) => {
            if (e.buttons === 1) handlePointerEvent(e.clientX)
          }}
        >
          {/* 進行バー */}
          <div
            className="absolute inset-y-0 left-0 bg-gradient-to-r from-accent-blue to-accent-purple rounded-full transition-none"
            style={{ width: `${timelineProgress * 100}%` }}
          />
          {/* サムつまみ */}
          <div
            className="absolute top-1/2 -translate-y-1/2 -translate-x-1/2 w-4 h-4 bg-white rounded-full shadow-lg border-2 border-accent-blue transition-none"
            style={{ left: `${timelineProgress * 100}%` }}
          />
        </div>
        <span className="text-text-secondary text-xs">now</span>
      </div>
    </GlassContainer>
  )
}
