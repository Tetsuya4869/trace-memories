'use client'
import { create } from 'zustand'
import type { PhotoMemory } from '@/types/photo'

interface PhotoState {
  photos: PhotoMemory[]
  setPhotos: (photos: PhotoMemory[]) => void
  addPhoto: (photo: PhotoMemory) => void
  clearPhotos: () => void
}

export const usePhotoStore = create<PhotoState>((set) => ({
  photos: [],
  setPhotos: (photos) => set({ photos }),
  addPhoto: (photo) =>
    set((state) => ({ photos: [...state.photos, photo] })),
  clearPhotos: () => set({ photos: [] }),
}))
