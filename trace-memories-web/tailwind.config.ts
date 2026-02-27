import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // AppTheme カラー完全移植
        'primary-dark': '#0F172A',
        'secondary-dark': '#1E293B',
        'surface-dark': '#334155',
        'accent-blue': '#38BDF8',
        'accent-purple': '#818CF8',
        'text-primary': '#FFFFFF',
        'text-secondary': '#94A3B8',
      },
      backdropBlur: {
        glass: '12px',
      },
      borderRadius: {
        glass: '20px',
      },
      backgroundImage: {
        'glass': 'linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%)',
        'app-gradient': 'linear-gradient(135deg, #0F172A 0%, #1E293B 50%, #0F172A 100%)',
      },
    },
  },
  plugins: [],
}

export default config
