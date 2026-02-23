'use client'
import { create } from 'zustand'

type PermissionStatus = 'unknown' | 'granted' | 'denied' | 'prompt'

interface AppState {
  onboardingDone: boolean
  setOnboardingDone: (v: boolean) => void

  locationPermission: PermissionStatus
  setLocationPermission: (v: PermissionStatus) => void

  photoPermission: PermissionStatus
  setPhotoPermission: (v: PermissionStatus) => void

  summaryModalOpen: boolean
  setSummaryModalOpen: (v: boolean) => void

  isDemoMode: boolean
  setDemoMode: (v: boolean) => void
}

export const useAppStore = create<AppState>((set) => ({
  onboardingDone: false,
  setOnboardingDone: (v) => set({ onboardingDone: v }),

  locationPermission: 'unknown',
  setLocationPermission: (v) => set({ locationPermission: v }),

  photoPermission: 'unknown',
  setPhotoPermission: (v) => set({ photoPermission: v }),

  summaryModalOpen: false,
  setSummaryModalOpen: (v) => set({ summaryModalOpen: v }),

  isDemoMode: false,
  setDemoMode: (v) => set({ isDemoMode: v }),
}))
