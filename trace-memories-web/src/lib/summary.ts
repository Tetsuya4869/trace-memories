import type { GpsPoint } from '@/types/gps'
import type { PhotoMemory } from '@/types/photo'
import { totalDistance, formatDistance } from './distance'

interface SummaryInput {
  points: GpsPoint[]
  photos: PhotoMemory[]
  date?: string
}

export function generateSummary({ points, photos, date }: SummaryInput): string {
  const distM = totalDistance(points)
  const photoCount = photos.length
  const dateStr = date ?? new Date().toLocaleDateString('ja-JP', { month: 'long', day: 'numeric' })

  if (points.length === 0 && photoCount === 0) {
    return `${dateStr}は白紙のページ。\nどこかへ出かけてみませんか？`
  }

  const lines: string[] = []

  if (distM > 0) {
    lines.push(`今日は ${formatDistance(distM)} 歩きました。`)
  }

  if (photoCount > 0) {
    lines.push(`${photoCount} 枚の思い出を地図に刻みました。`)
  }

  if (distM > 5000) {
    lines.push('なかなかのロングウォークですね！')
  } else if (distM > 1000) {
    lines.push('いい散歩でしたね。')
  } else if (distM > 0) {
    lines.push('ちょっとそこまで、の一日。')
  }

  return lines.join('\n')
}
