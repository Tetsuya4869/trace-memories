import type { GpsPoint } from '@/types/gps'
import type { PhotoMemory } from '@/types/photo'

// 渋谷〜原宿デモルート（実際の道路に沿った座標）
export const DEMO_ROUTE: GpsPoint[] = [
  { id: 'd1', lat: 35.6580, lng: 139.7016, timestamp: Date.now() - 3600000, date: '2026-02-23' },
  { id: 'd2', lat: 35.6590, lng: 139.7020, timestamp: Date.now() - 3500000, date: '2026-02-23' },
  { id: 'd3', lat: 35.6600, lng: 139.7025, timestamp: Date.now() - 3400000, date: '2026-02-23' },
  { id: 'd4', lat: 35.6615, lng: 139.7030, timestamp: Date.now() - 3300000, date: '2026-02-23' },
  { id: 'd5', lat: 35.6630, lng: 139.7038, timestamp: Date.now() - 3200000, date: '2026-02-23' },
  { id: 'd6', lat: 35.6645, lng: 139.7042, timestamp: Date.now() - 3100000, date: '2026-02-23' },
  { id: 'd7', lat: 35.6660, lng: 139.7045, timestamp: Date.now() - 3000000, date: '2026-02-23' },
  { id: 'd8', lat: 35.6675, lng: 139.7040, timestamp: Date.now() - 2900000, date: '2026-02-23' },
  { id: 'd9', lat: 35.6690, lng: 139.7035, timestamp: Date.now() - 2800000, date: '2026-02-23' },
  { id: 'd10', lat: 35.6710, lng: 139.7010, timestamp: Date.now() - 2700000, date: '2026-02-23' },
]

// デモ写真（GPS座標付き、実際のサムネイルなし）
export const DEMO_PHOTOS: Omit<PhotoMemory, 'thumbnailBuffer'>[] = [
  { id: 'p1', lat: 35.6615, lng: 139.7030, timestamp: Date.now() - 3250000, date: '2026-02-23', fileName: 'demo1.jpg' },
  { id: 'p2', lat: 35.6660, lng: 139.7045, timestamp: Date.now() - 2950000, date: '2026-02-23', fileName: 'demo2.jpg' },
]

export const DEMO_CENTER = { lat: 35.6645, lng: 139.7030 }
export const DEMO_ZOOM = 15
