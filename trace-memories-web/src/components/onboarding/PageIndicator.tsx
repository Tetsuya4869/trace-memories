interface PageIndicatorProps {
  total: number
  current: number
}

export default function PageIndicator({ total, current }: PageIndicatorProps) {
  return (
    <div className="flex gap-2 justify-center">
      {Array.from({ length: total }).map((_, i) => (
        <div
          key={i}
          className={`rounded-full transition-all duration-300 ${
            i === current
              ? 'w-6 h-2 bg-accent-blue'
              : 'w-2 h-2 bg-white/30'
          }`}
        />
      ))}
    </div>
  )
}
