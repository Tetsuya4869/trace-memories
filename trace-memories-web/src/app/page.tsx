'use client'
import { useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { isOnboardingDone } from '@/lib/storage'
import LoadingSpinner from '@/components/ui/LoadingSpinner'

export default function RootPage() {
  const router = useRouter()

  useEffect(() => {
    if (isOnboardingDone()) {
      router.replace('/map')
    } else {
      router.replace('/onboarding')
    }
  }, [router])

  return (
    <div className="flex items-center justify-center min-h-screen bg-primary-dark">
      <LoadingSpinner size={40} />
    </div>
  )
}
