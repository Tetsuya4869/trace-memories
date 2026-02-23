const ONBOARDING_KEY = 'trace_memories_onboarding_done'

export function isOnboardingDone(): boolean {
  if (typeof window === 'undefined') return false
  return localStorage.getItem(ONBOARDING_KEY) === 'true'
}

export function markOnboardingDone(): void {
  if (typeof window === 'undefined') return
  localStorage.setItem(ONBOARDING_KEY, 'true')
}

export function resetOnboarding(): void {
  if (typeof window === 'undefined') return
  localStorage.removeItem(ONBOARDING_KEY)
}
