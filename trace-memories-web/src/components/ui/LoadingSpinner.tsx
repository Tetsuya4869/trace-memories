export default function LoadingSpinner({ size = 24 }: { size?: number }) {
  return (
    <div
      className="inline-block rounded-full border-2 border-white/20 border-t-accent-blue animate-spin"
      style={{ width: size, height: size }}
    />
  )
}
