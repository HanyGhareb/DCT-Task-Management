/**
 * atdStatus — map an ATD run/job status to themed fg/bg colors for badges.
 */
import type { ThemePalette } from '@/theme/tokens';

export function atdStatusColors(palette: ThemePalette, status: string): { fg: string; bg: string } {
  const s = (status || '').toUpperCase();
  if (s === 'SUCCESS' || s === 'DONE' || s === 'READY') return { fg: palette.success, bg: palette.successSoft };
  if (s === 'FAILED' || s === 'ERROR') return { fg: palette.danger, bg: palette.dangerSoft };
  if (s === 'WARNING') return { fg: palette.warning, bg: palette.warningSoft };
  if (s === 'CLAIMED' || s === 'RUNNING') return { fg: palette.info, bg: palette.surfaceAlt };
  return { fg: palette.textMuted, bg: palette.surfaceAlt };
}
