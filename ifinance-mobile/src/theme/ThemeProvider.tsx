/**
 * ThemeProvider — exposes the active palette (light/dark from OS) and the live
 * brand color (set from GET /dct/boot at login, like the web shell.initBrand).
 */
import React, { createContext, useContext, useMemo, useState, useCallback } from 'react';
import { useColorScheme } from 'react-native';
import { darkPalette, lightPalette, ThemePalette } from './tokens';

interface ThemeContextValue {
  palette: ThemePalette;
  isDark: boolean;
  /** Override the brand color (from /dct/boot THEME_BRAND_COLOR). */
  setBrand: (hex: string | null) => void;
}

const ThemeContext = createContext<ThemeContextValue | null>(null);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const scheme = useColorScheme();
  const isDark = scheme === 'dark';
  const [brand, setBrandState] = useState<string | null>(null);

  const setBrand = useCallback((hex: string | null) => {
    setBrandState(hex && /^#?[0-9a-fA-F]{6}$/.test(hex) ? (hex[0] === '#' ? hex : `#${hex}`) : null);
  }, []);

  const palette = useMemo<ThemePalette>(() => {
    const base = isDark ? darkPalette : lightPalette;
    return brand ? { ...base, brand } : base;
  }, [isDark, brand]);

  const value = useMemo(() => ({ palette, isDark, setBrand }), [palette, isDark, setBrand]);
  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
}

export function useTheme(): ThemeContextValue {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error('useTheme must be used within ThemeProvider');
  return ctx;
}
