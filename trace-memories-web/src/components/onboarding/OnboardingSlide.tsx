import { motion } from 'framer-motion'

interface OnboardingSlideProps {
  emoji: string
  title: string
  description: string
  isActive: boolean
}

export default function OnboardingSlide({
  emoji, title, description, isActive,
}: OnboardingSlideProps) {
  return (
    <motion.div
      className="flex flex-col items-center justify-center px-8 text-center h-full"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: isActive ? 1 : 0, y: isActive ? 0 : 20 }}
      transition={{ duration: 0.4 }}
    >
      <div className="text-7xl mb-8">{emoji}</div>
      <h2 className="text-2xl font-bold text-text-primary mb-4">{title}</h2>
      <p className="text-text-secondary text-base leading-relaxed">{description}</p>
    </motion.div>
  )
}
