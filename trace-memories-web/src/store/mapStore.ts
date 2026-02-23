'use client'
import { create } from 'zustand'
import type { GpsPoint } from '@/types/gps'

interface MapState {
  gpsPoints: GpsPoint[]
  addGpsPoint: (point: GpsPoint) => void
  setGpsPoints: (points: GpsPoint[]) => void
  clearGpsPoints: () => void

  isTracking: boolean
  setIsTracking: (v: boolean) => void

  timelineProgress: number // 0.0 〜 1.0
  setTimelineProgress: (v: number) => void

  currentCenter: { lat: number; lng: number } | null
  setCurrentCenter: (v: { lat: number; lng: number } | null) => void
}

export const useMapStore = create<MapState>((set) => ({
  gpsPoints: [],
  addGpsPoint: (point) =>
    set((state) => ({ gpsPoints: [...state.gpsPoints, point] })),
  setGpsPoints: (points) => set({ gpsPoints: points }),
  clearGpsPoints: () => set({ gpsPoints: [] }),

  isTracking: false,
  setIsTracking: (v) => set({ isTracking: v }),

  timelineProgress: 1.0,
  setTimelineProgress: (v) => set({ timelineProgress: v }),

  currentCenter: null,
  setCurrentCenter: (v) => set({ currentCenter: v }),
}))
