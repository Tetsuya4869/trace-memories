'use client'
import { useRef, useEffect } from 'react'
import Map, { type MapRef } from 'react-map-gl'
import 'mapbox-gl/dist/mapbox-gl.css'
import RouteLayer from './RouteLayer'
import PhotoMarkers from './PhotoMarkers'
import { useTimeline } from '@/hooks/useTimeline'
import { useMapStore } from '@/store/mapStore'
import { DEMO_CENTER, DEMO_ZOOM } from '@/lib/demoData'

const MAPBOX_TOKEN = process.env.NEXT_PUBLIC_MAPBOX_TOKEN ?? ''

export default function MapView() {
  const mapRef = useRef<MapRef>(null)
  const { visiblePoints, visiblePhotos } = useTimeline()
  const { currentCenter } = useMapStore()

  // 現在地が更新されたら地図を追従
  useEffect(() => {
    if (!currentCenter || !mapRef.current) return
    mapRef.current.easeTo({
      center: [currentCenter.lng, currentCenter.lat],
      duration: 1000,
    })
  }, [currentCenter])

  return (
    <Map
      ref={mapRef}
      mapboxAccessToken={MAPBOX_TOKEN}
      initialViewState={{
        latitude: DEMO_CENTER.lat,
        longitude: DEMO_CENTER.lng,
        zoom: DEMO_ZOOM,
      }}
      style={{ width: '100%', height: '100%' }}
      mapStyle="mapbox://styles/mapbox/dark-v11"
      attributionControl={false}
    >
      <RouteLayer points={visiblePoints} />
      <PhotoMarkers photos={visiblePhotos} />
    </Map>
  )
}
