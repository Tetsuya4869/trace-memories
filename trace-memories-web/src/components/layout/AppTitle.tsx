export default function AppTitle() {
  return (
    <div className="flex flex-col">
      <span className="text-text-primary text-lg font-bold tracking-wider">
        TraceMemories
      </span>
      <span className="text-text-secondary text-xs">
        {new Date().toLocaleDateString('ja-JP', { month: 'long', day: 'numeric', weekday: 'short' })}
      </span>
    </div>
  )
}
