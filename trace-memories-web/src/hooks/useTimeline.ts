'use client'
import { useMemo } from 'react'
import { useMapStore } from '@/store/mapStore'
import { usePhotoStore } from '@/store/photoStore'
import type { GpsPoint } from '@/types/gps'
import type { PhotoMemory } from '@/types/photo'

interface TimelineResult {
  visiblePoints: GpsPoint[]
  visiblePhotos: PhotoMemory[]
}

export function useTimeline(): TimelineResult {
  const { gpsPoints, timelineProgress } = useMapStore()
  const { photos } = usePhotoStore()

  return useMemo(() => {
    if (gpsPoints.length === 0) {
      return { visiblePoints: [], visiblePhotos: [] }
    }

    const sorted = [...gpsPoints].sort((a, b) => a.timestamp - b.timestamp)
    const minTs = sorted[0].timestamp
    const maxTs = sorted[sorted.length - 1].timestamp
    const cutoff = minTs + (maxTs - minTs) * timelineProgress

    const visiblePoints = sorted.filter((p) => p.timestamp <= cutoff)

    const visiblePhotos = photos.filter((p) => p.timestamp <= cutoff)

    return { visiblePoints, visiblePhotos }
  }, [gpsPoints, photos, timelineProgress])
}
