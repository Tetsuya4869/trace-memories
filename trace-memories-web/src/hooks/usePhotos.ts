'use client'
import { useCallback } from 'react'
import { usePhotoStore } from '@/store/photoStore'
import { useIndexedDB } from './useIndexedDB'
import type { PhotoMemory } from '@/types/photo'
import { todayString } from '@/lib/db'

export function usePhotos() {
  const { addPhoto, setPhotos } = usePhotoStore()
  const { persistPhoto, loadTodayPhotos } = useIndexedDB()

  const loadSavedPhotos = useCallback(async () => {
    const saved = await loadTodayPhotos()
    if (saved.length > 0) setPhotos(saved)
  }, [loadTodayPhotos, setPhotos])

  const importPhotos = useCallback(async (files: FileList) => {
    // exifr は動的インポート（SSR 回避）
    const exifr = await import('exifr')

    for (const file of Array.from(files)) {
      try {
        const gps = await exifr.gps(file)
        if (!gps) continue // GPS なし → スキップ

        const exifData = await exifr.parse(file, ['DateTimeOriginal'])
        const timestamp = exifData?.DateTimeOriginal
          ? new Date(exifData.DateTimeOriginal as string).getTime()
          : Date.now()

        // ArrayBuffer で保存（createObjectURL はセッション終了で無効になるため）
        const buffer = await file.arrayBuffer()

        const photo: PhotoMemory = {
          id: `photo_${Date.now()}_${Math.random().toString(36).slice(2)}`,
          lat: gps.latitude,
          lng: gps.longitude,
          timestamp,
          date: todayString(),
          thumbnailBuffer: buffer,
          fileName: file.name,
        }

        addPhoto(photo)
        await persistPhoto(photo)
      } catch {
        // EXIF 解析失敗は無視
      }
    }
  }, [addPhoto, persistPhoto])

  return { importPhotos, loadSavedPhotos }
}
