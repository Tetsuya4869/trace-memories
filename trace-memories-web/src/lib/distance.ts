import type { GpsPoint } from '@/types/gps'

const R = 6371000 // 地球の半径（メートル）

function toRad(deg: number): number {
  return (deg * Math.PI) / 180
}

export function haversine(
  lat1: number, lng1: number,
  lat2: number, lng2: number
): number {
  const dLat = toRad(lat2 - lat1)
  const dLng = toRad(lng2 - lng1)
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLng / 2) ** 2
  return 2 * R * Math.asin(Math.sqrt(a))
}

export function totalDistance(points: GpsPoint[]): number {
  if (points.length < 2) return 0
  let total = 0
  for (let i = 1; i < points.length; i++) {
    total += haversine(
      points[i - 1].lat, points[i - 1].lng,
      points[i].lat, points[i].lng
    )
  }
  return total
}

export function formatDistance(meters: number): string {
  if (meters < 1000) {
    return `${Math.round(meters)} メートル`
  }
  return `${(meters / 1000).toFixed(1)} km`
}
