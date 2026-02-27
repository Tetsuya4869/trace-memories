'use client'
import { useCallback, useEffect, useRef } from 'react'
import { useMapStore } from '@/store/mapStore'
import { useAppStore } from '@/store/appStore'
import { useIndexedDB } from './useIndexedDB'
import type { GpsPoint } from '@/types/gps'
import { todayString } from '@/lib/db'

export function useGPS() {
  const watchIdRef = useRef<number | null>(null)
  const { addGpsPoint, setGpsPoints, setIsTracking, setCurrentCenter } = useMapStore()
  const { setLocationPermission } = useAppStore()
  const { persistGpsPoint, loadTodayGpsPoints } = useIndexedDB()

  // 起動時に今日のデータをロード
  useEffect(() => {
    loadTodayGpsPoints().then((points) => {
      if (points.length > 0) {
        const sorted = [...points].sort((a, b) => a.timestamp - b.timestamp)
        setGpsPoints(sorted)
        const last = sorted[sorted.length - 1]
        setCurrentCenter({ lat: last.lat, lng: last.lng })
      }
    })
  }, [loadTodayGpsPoints, setGpsPoints, setCurrentCenter])

  const startTracking = useCallback(() => {
    if (!navigator.geolocation) {
      setLocationPermission('denied')
      return
    }

    watchIdRef.current = navigator.geolocation.watchPosition(
      (pos) => {
        setLocationPermission('granted')
        const point: GpsPoint = {
          id: `gps_${Date.now()}`,
          lat: pos.coords.latitude,
          lng: pos.coords.longitude,
          timestamp: pos.timestamp,
          accuracy: pos.coords.accuracy,
          date: todayString(),
        }
        addGpsPoint(point)
        setCurrentCenter({ lat: point.lat, lng: point.lng })
        persistGpsPoint(point)
      },
      (err) => {
        if (err.code === GeolocationPositionError.PERMISSION_DENIED) {
          setLocationPermission('denied')
        }
        setIsTracking(false)
      },
      {
        enableHighAccuracy: true,
        maximumAge: 5000,
        timeout: 10000,
      }
    )

    setIsTracking(true)
  }, [addGpsPoint, setCurrentCenter, persistGpsPoint, setIsTracking, setLocationPermission])

  const stopTracking = useCallback(() => {
    if (watchIdRef.current !== null) {
      navigator.geolocation.clearWatch(watchIdRef.current)
      watchIdRef.current = null
    }
    setIsTracking(false)
  }, [setIsTracking])

  useEffect(() => {
    return () => {
      if (watchIdRef.current !== null) {
        navigator.geolocation.clearWatch(watchIdRef.current)
      }
    }
  }, [])

  return { startTracking, stopTracking }
}
