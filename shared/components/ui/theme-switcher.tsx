'use client'

import { useTheme } from '@/shared/components/ui/theme-provider'

export function ThemeSwitcher(): JSX.Element {
  const { theme } = useTheme()

  return (
    <span className="text-xs text-muted capitalize" aria-label={`Current theme: ${theme}`}>
      {theme}
    </span>
  )
}
