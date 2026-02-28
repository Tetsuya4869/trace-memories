'use client'
import { useMapStore } from '@/store/mapStore'
import { useAppStore } from '@/store/appStore'

export default function StatusBadge() {
  const { isTracking, gpsPoints } = useMapStore()
  const { locationPermission, isDemoMode } = useAppStore()

  if (isDemoMode) {
    return (
      <div className="flex items-center gap-1.5 bg-accent-purple/20 border border-accent-purple/30 rounded-full px-3 py-1">
        <span className="w-2 h-2 rounded-full bg-accent-purple" />
        <span className="text-accent-purple text-xs font-medium">デモ</span>
      </div>
    )
  }

  if (locationPermission === 'denied') {
    return (
      <div className="flex items-center gap-1.5 bg-red-500/20 border border-red-500/30 rounded-full px-3 py-1">
        <span className="w-2 h-2 rounded-full bg-red-500" />
        <span className="text-red-400 text-xs font-medium">位置情報オフ</span>
      </div>
    )
  }

  if (isTracking) {
    return (
      <div className="flex items-center gap-1.5 bg-accent-blue/20 border border-accent-blue/30 rounded-full px-3 py-1">
        <span className="w-2 h-2 rounded-full bg-accent-blue animate-pulse" />
        <span className="text-accent-blue text-xs font-medium">
          {gpsPoints.length} pts
        </span>
      </div>
    )
  }

  return (
    <div className="flex items-center gap-1.5 bg-white/10 border border-white/20 rounded-full px-3 py-1">
      <span className="w-2 h-2 rounded-full bg-text-secondary" />
      <span className="text-text-secondary text-xs font-medium">停止中</span>
    </div>
  )
}
