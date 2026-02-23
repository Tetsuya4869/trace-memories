import { type ReactNode, type ButtonHTMLAttributes } from 'react'

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode
  variant?: 'primary' | 'glass' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
}

const variants = {
  primary:
    'bg-gradient-to-r from-accent-blue to-accent-purple text-white font-semibold shadow-lg hover:opacity-90 active:scale-95',
  glass:
    'backdrop-blur-[12px] bg-white/10 border border-white/20 text-white hover:bg-white/20 active:scale-95',
  ghost:
    'text-text-secondary hover:text-text-primary active:scale-95',
}

const sizes = {
  sm: 'px-3 py-1.5 text-sm rounded-xl',
  md: 'px-5 py-2.5 text-base rounded-[16px]',
  lg: 'px-8 py-3.5 text-lg rounded-[20px]',
}

export default function Button({
  children,
  variant = 'primary',
  size = 'md',
  className = '',
  ...props
}: ButtonProps) {
  return (
    <button
      className={`transition-all duration-150 ${variants[variant]} ${sizes[size]} ${className}`}
      {...props}
    >
      {children}
    </button>
  )
}
