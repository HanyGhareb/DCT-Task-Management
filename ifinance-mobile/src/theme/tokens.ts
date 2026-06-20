/**
 * tokens.ts — design tokens mirrored from `final apps/shared/css/platform.css`.
 *
 * Per-module brand colors come from shell.js MODULES; the amber focus accent
 * and surface/text scale mirror platform.css. Light + dark are defined together
 * (ui-ux-pro-max: design both, test contrast per mode). The live brand color is
 * overridden at boot from GET /dct/boot, exactly like the web shell.
 */

/** Per-module brand color (fallbacks; live value from /dct/boot). */
export const MODULE_BRAND: Record<string, string> = {
  ADMIN: '#C74634',
  PETTY_CASH: '#2E7D32',
  CREDIT_CARDS: '#B0721E',
  FREELANCERS: '#7C4DBE',
  DUTY_TRAVEL: '#0572CE',
  HR: '#1a7f5a',
  AR: '#6C4AB6',
  TASK_MGMT: '#0E8A8A',
  ATD: '#3A4FB0',
  // Approval source-module discriminators map onto their owning module color:
  REIMBURSEMENT: '#2E7D32',
  CLEARING: '#2E7D32',
  TRAVEL_REQUEST: '#0572CE',
  SETTLEMENT: '#0572CE',
  FL_CONTRACT: '#7C4DBE',
  FL_AMENDMENT: '#7C4DBE',
  FL_VOUCHER: '#7C4DBE',
  FL_RENEWAL: '#7C4DBE',
  CC_REQUEST: '#B0721E',
  CC_REPLENISHMENT: '#B0721E',
};

export function moduleColor(moduleCode: string | undefined | null): string {
  if (!moduleCode) return '#C74634';
  return MODULE_BRAND[moduleCode] ?? '#C74634';
}

export interface ThemePalette {
  bg: string;
  surface: string;
  surfaceAlt: string;
  border: string;
  text: string;
  textMuted: string;
  brand: string;
  focus: string; // amber accent
  chromeBg: string;
  chromeText: string;
  success: string;
  successSoft: string;
  danger: string;
  dangerSoft: string;
  warning: string;
  warningSoft: string;
  info: string;
}

const AMBER = '#F0883E';

export const lightPalette: ThemePalette = {
  bg: '#F6F7F9',
  surface: '#FFFFFF',
  surfaceAlt: '#F0F2F5',
  border: '#E3E6EB',
  text: '#1A1F26',
  textMuted: '#5B6573',
  brand: '#C74634',
  focus: AMBER,
  chromeBg: '#0F141B',
  chromeText: '#C9D2DC',
  success: '#2E7D32',
  successSoft: '#E5F2E6',
  danger: '#C62828',
  dangerSoft: '#FBE9E9',
  warning: '#B0721E',
  warningSoft: '#FBF0E0',
  info: '#0572CE',
};

export const darkPalette: ThemePalette = {
  bg: '#0D1117',
  surface: '#161B22',
  surfaceAlt: '#1C2230',
  border: '#30363D',
  text: '#E6EDF3',
  textMuted: '#8B98A6',
  brand: '#E0604E',
  focus: AMBER,
  chromeBg: '#0A0E14',
  chromeText: '#C9D2DC',
  success: '#3FB950',
  successSoft: '#16271A',
  danger: '#F85149',
  dangerSoft: '#2A1517',
  warning: '#D9963B',
  warningSoft: '#2A2113',
  info: '#58A6FF',
};

/** 4 / 8 spacing rhythm (ui-ux-pro-max spacing-scale). */
export const spacing = { xs: 4, sm: 8, md: 12, lg: 16, xl: 24, xxl: 32 } as const;

export const radius = { sm: 8, md: 12, lg: 16, pill: 999 } as const;

export const fontFamily = {
  // Bundled at build time; falls back to system if not loaded.
  sans: 'Outfit',
  arabic: 'IBMPlexSansArabic',
  mono: 'FiraCode',
} as const;

export const type = {
  h1: { fontSize: 24, fontWeight: '700' as const, lineHeight: 30 },
  h2: { fontSize: 20, fontWeight: '700' as const, lineHeight: 26 },
  title: { fontSize: 17, fontWeight: '600' as const, lineHeight: 23 },
  body: { fontSize: 16, fontWeight: '400' as const, lineHeight: 24 },
  label: { fontSize: 14, fontWeight: '500' as const, lineHeight: 20 },
  caption: { fontSize: 12, fontWeight: '400' as const, lineHeight: 16 },
};
