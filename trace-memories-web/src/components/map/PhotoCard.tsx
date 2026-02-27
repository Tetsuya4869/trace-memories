'use client'
import { useEffect, useState } from 'react'
import type { PhotoMemory } from '@/types/photo'

interface PhotoCardProps {
  photo: PhotoMemory
  onClick?: () => void
}

export default function PhotoCard({ photo, onClick }: PhotoCardProps) {
  const [objectUrl, setObjectUrl] = useState<string | null>(null)

  useEffect(() => {
    const blob = new Blob([photo.thumbnailBuffer])
    const url = URL.createObjectURL(blob)
    setObjectUrl(url)
    return () => URL.revokeObjectURL(url)
  }, [photo.thumbnailBuffer])

  if (!objectUrl) {
    return (
      <div className="w-10 h-10 rounded-full bg-white/20 border-2 border-white/40 animate-pulse" />
    )
  }

  return (
    <button
      onClick={onClick}
      className="w-10 h-10 rounded-full border-2 border-white overflow-hidden shadow-lg hover:scale-110 active:scale-95 transition-transform"
    >
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img
        src={objectUrl}
        alt={photo.fileName}
        className="w-full h-full object-cover"
      />
    </button>
  )
}
