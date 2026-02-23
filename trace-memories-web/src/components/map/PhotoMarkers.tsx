'use client'
import { Marker } from 'react-map-gl'
import PhotoCard from './PhotoCard'
import type { PhotoMemory } from '@/types/photo'

interface PhotoMarkersProps {
  photos: PhotoMemory[]
}

export default function PhotoMarkers({ photos }: PhotoMarkersProps) {
  return (
    <>
      {photos.map((photo) => (
        <Marker
          key={photo.id}
          latitude={photo.lat}
          longitude={photo.lng}
          anchor="bottom"
        >
          <PhotoCard photo={photo} />
        </Marker>
      ))}
    </>
  )
}
