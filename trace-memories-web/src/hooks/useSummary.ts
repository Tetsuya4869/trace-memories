'use client'
import { useCallback } from 'react'
import { useMapStore } from '@/store/mapStore'
import { usePhotoStore } from '@/store/photoStore'
import { useIndexedDB } from './useIndexedDB'
import { generateSummary } from '@/lib/summary'
import type { DaySummary } from '@/types/summary'
import { totalDistance } from '@/lib/distance'
import { todayString } from '@/lib/db'

export function useSummary() {
  const { gpsPoints } = useMapStore()
  const { photos } = usePhotoStore()
  const { persistSummary, loadTodaySummary } = useIndexedDB()

  const generate = useCallback(async (): Promise<DaySummary> => {
    const text = generateSummary({
      points: gpsPoints,
      photos,
      date: new Date().toLocaleDateString('ja-JP', { month: 'long', day: 'numeric' }),
    })

    const summary: DaySummary = {
      id: `summary_${Date.now()}`,
      date: todayString(),
      totalDistanceM: totalDistance(gpsPoints),
      photoCount: photos.length,
      text,
      generatedAt: Date.now(),
    }

    await persistSummary(summary)
    return summary
  }, [gpsPoints, photos, persistSummary])

  return { generate, loadTodaySummary }
}
