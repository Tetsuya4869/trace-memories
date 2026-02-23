'use client'
import { Source, Layer } from 'react-map-gl'
import type { GpsPoint } from '@/types/gps'

interface RouteLayerProps {
  points: GpsPoint[]
}

export default function RouteLayer({ points }: RouteLayerProps) {
  if (points.length < 2) return null

  const geojson: GeoJSON.Feature<GeoJSON.LineString> = {
    type: 'Feature',
    properties: {},
    geometry: {
      type: 'LineString',
      coordinates: points.map((p) => [p.lng, p.lat]),
    },
  }

  return (
    <Source id="route" type="geojson" data={geojson}>
      {/* 光彩（グロー効果）*/}
      <Layer
        id="route-glow"
        type="line"
        paint={{
          'line-color': '#38BDF8',
          'line-width': 8,
          'line-opacity': 0.3,
          'line-blur': 4,
        }}
        layout={{ 'line-cap': 'round', 'line-join': 'round' }}
      />
      {/* メインライン */}
      <Layer
        id="route-line"
        type="line"
        paint={{
          'line-color': '#38BDF8',
          'line-width': 3,
          'line-opacity': 0.9,
        }}
        layout={{ 'line-cap': 'round', 'line-join': 'round' }}
      />
    </Source>
  )
}
