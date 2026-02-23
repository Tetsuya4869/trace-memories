import { openDB, type IDBPDatabase } from 'idb'
import type { GpsPoint } from '@/types/gps'
import type { PhotoMemory } from '@/types/photo'
import type { DaySummary } from '@/types/summary'

const DB_NAME = 'trace-memories-db'
const DB_VERSION = 1

type TraceDB = {
  gpsPoints: {
    key: string
    value: GpsPoint
    indexes: { date: string; timestamp: number }
  }
  photos: {
    key: string
    value: PhotoMemory
    indexes: { date: string }
  }
  summaries: {
    key: string
    value: DaySummary
    indexes: { date: string }
  }
  settings: {
    key: string
    value: { key: string; value: unknown }
  }
}

let dbPromise: Promise<IDBPDatabase<TraceDB>> | null = null

export function getDB(): Promise<IDBPDatabase<TraceDB>> {
  if (!dbPromise) {
    dbPromise = openDB<TraceDB>(DB_NAME, DB_VERSION, {
      upgrade(db) {
        // gpsPoints
        const gpsStore = db.createObjectStore('gpsPoints', { keyPath: 'id' })
        gpsStore.createIndex('date', 'date')
        gpsStore.createIndex('timestamp', 'timestamp')

        // photos
        const photoStore = db.createObjectStore('photos', { keyPath: 'id' })
        photoStore.createIndex('date', 'date')

        // summaries
        const summaryStore = db.createObjectStore('summaries', { keyPath: 'id' })
        summaryStore.createIndex('date', 'date')

        // settings
        db.createObjectStore('settings', { keyPath: 'key' })
      },
    })
  }
  return dbPromise
}

// GPS ポイント
export async function saveGpsPoint(point: GpsPoint): Promise<void> {
  const db = await getDB()
  await db.put('gpsPoints', point)
}

export async function getGpsPointsByDate(date: string): Promise<GpsPoint[]> {
  const db = await getDB()
  return db.getAllFromIndex('gpsPoints', 'date', date)
}

// 写真
export async function savePhoto(photo: PhotoMemory): Promise<void> {
  const db = await getDB()
  await db.put('photos', photo)
}

export async function getPhotosByDate(date: string): Promise<PhotoMemory[]> {
  const db = await getDB()
  return db.getAllFromIndex('photos', 'date', date)
}

// サマリー
export async function saveSummary(summary: DaySummary): Promise<void> {
  const db = await getDB()
  await db.put('summaries', summary)
}

export async function getSummaryByDate(date: string): Promise<DaySummary | undefined> {
  const db = await getDB()
  const results = await db.getAllFromIndex('summaries', 'date', date)
  return results[0]
}

// 全データ削除（設定から）
export async function clearAllData(): Promise<void> {
  const db = await getDB()
  await db.clear('gpsPoints')
  await db.clear('photos')
  await db.clear('summaries')
}

export function todayString(): string {
  return new Date().toISOString().split('T')[0]
}
