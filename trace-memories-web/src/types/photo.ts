export interface PhotoMemory {
  id: string
  lat: number
  lng: number
  timestamp: number
  date: string // YYYY-MM-DD
  thumbnailBuffer: ArrayBuffer
  fileName: string
}
