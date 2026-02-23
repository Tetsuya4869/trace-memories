export interface GpsPoint {
  id: string
  lat: number
  lng: number
  timestamp: number
  accuracy?: number
  date: string // YYYY-MM-DD
}
