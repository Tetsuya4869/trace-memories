import { type ReactNode } from 'react'

interface GlassContainerProps {
  children: ReactNode
  className?: string
  onClick?: () => void
}

export default function GlassContainer({ children, className = '', onClick }: GlassContainerProps) {
  return (
    <div
      className={`backdrop-blur-[12px] bg-white/10 border border-white/20 rounded-[20px] ${className}`}
      onClick={onClick}
    >
      {children}
    </div>
  )
}
