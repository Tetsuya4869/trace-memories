'use client'
import { useCallback } from 'react'
import {
  saveGpsPoint, getGpsPointsByDate,
  savePhoto, getPhotosByDate,
  saveSummary, getSummaryByDate,
  clearAllData, todayString,
} from '@/lib/db'
import type { GpsPoint } from '@/types/gps'
import type { PhotoMemory } from '@/types/photo'
import type { DaySummary } from '@/types/summary'

export function useIndexedDB() {
  const loadTodayGpsPoints = useCallback(async (): Promise<GpsPoint[]> => {
    return getGpsPointsByDate(todayString())
  }, [])

  const persistGpsPoint = useCallback(async (point: GpsPoint): Promise<void> => {
    await saveGpsPoint(point)
  }, [])

  const loadTodayPhotos = useCallback(async (): Promise<PhotoMemory[]> => {
    return getPhotosByDate(todayString())
  }, [])

  const persistPhoto = useCallback(async (photo: PhotoMemory): Promise<void> => {
    await savePhoto(photo)
  }, [])

  const loadTodaySummary = useCallback(async (): Promise<DaySummary | undefined> => {
    return getSummaryByDate(todayString())
  }, [])

  const persistSummary = useCallback(async (summary: DaySummary): Promise<void> => {
    await saveSummary(summary)
  }, [])

  const clearAll = useCallback(async (): Promise<void> => {
    await clearAllData()
  }, [])

  return {
    loadTodayGpsPoints,
    persistGpsPoint,
    loadTodayPhotos,
    persistPhoto,
    loadTodaySummary,
    persistSummary,
    clearAll,
  }
}
