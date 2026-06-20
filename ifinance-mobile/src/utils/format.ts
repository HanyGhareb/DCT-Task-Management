/**
 * format.ts — display helpers. Latin digits always (platform rule), AED amounts.
 */
export function formatAmount(value: number | undefined | null): string {
  const n = typeof value === 'number' && isFinite(value) ? value : 0;
  return n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

export function relativeDate(iso: string | undefined): string {
  if (!iso) return '';
  // Accept both 'YYYY-MM-DD HH:MI' and ISO; render a compact local string.
  const d = new Date(iso.replace(' ', 'T'));
  if (isNaN(d.getTime())) return iso;
  return d.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
}

/** Compact date + time, Latin digits: '20 Jun, 14:32'. */
export function formatDateTime(iso: string | undefined): string {
  if (!iso) return '';
  const d = new Date(iso.replace(' ', 'T'));
  if (isNaN(d.getTime())) return iso;
  return d.toLocaleString('en-GB', {
    day: '2-digit',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
  });
}

/** Seconds → compact duration: '7s', '1m 04s', '1h 02m'. */
export function formatDuration(sec: number | undefined | null): string {
  const n = typeof sec === 'number' && isFinite(sec) && sec >= 0 ? Math.floor(sec) : 0;
  if (n < 60) return `${n}s`;
  if (n < 3600) return `${Math.floor(n / 60)}m ${String(n % 60).padStart(2, '0')}s`;
  return `${Math.floor(n / 3600)}h ${String(Math.floor((n % 3600) / 60)).padStart(2, '0')}m`;
}

/** Friendly label for an approval source-module discriminator. */
const MODULE_LABEL: Record<string, string> = {
  PETTY_CASH: 'Petty Cash',
  REIMBURSEMENT: 'Reimbursement',
  CLEARING: 'Clearing',
  TRAVEL_REQUEST: 'Duty Travel',
  SETTLEMENT: 'Travel Settlement',
  FL_CONTRACT: 'Freelancer Contract',
  FL_AMENDMENT: 'Contract Amendment',
  FL_VOUCHER: 'Payment Voucher',
  FL_RENEWAL: 'Contract Renewal',
  CC_REQUEST: 'Card Request',
  CC_REPLENISHMENT: 'Card Replenishment',
};

export function moduleLabel(code: string): string {
  return MODULE_LABEL[code] ?? code;
}
