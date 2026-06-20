/**
 * config.ts — runtime configuration.
 *
 * apiBase points at the shared Admin `/dct/` ORDS module (the identity
 * provider + unified approvals/notifications/delegations layer). Mirrors
 * `final apps/Admin/Jet/js/services/config.js`. Override per build via the
 * `extra.apiBase` field in app.json (read through expo-constants).
 */
import Constants from 'expo-constants';

const extra = (Constants.expoConfig?.extra ?? {}) as { apiBase?: string };

const apiBase =
  extra.apiBase ??
  'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/dct';

/** The ORDS root shared by every module — apiBase with its last segment
 *  (`/dct`) stripped, e.g. `…/ords/admin`. All `/ords/admin/<mod>/` modules
 *  hang off this on the same host with the same Bearer session. */
const ordsRoot = apiBase.replace(/\/[^/]+\/?$/, '');

export const config = {
  /** Base URL for the shared /dct/ module on ADB managed ORDS. */
  apiBase,
  /** ORDS root (`…/ords/admin`) — see `moduleBase`. */
  ordsRoot,
  /** Stored-session key (kept identical to the web for shared mental model). */
  sessionKey: 'ifinance_jet_session',
  /** Notification-count badge poll interval (ms) — fallback when push is idle. */
  notifPollMs: 60_000,
} as const;

/** Base URL for another module's ORDS path, e.g. `moduleBase('atd')` →
 *  `…/ords/admin/atd`. The shared session token authenticates all of them. */
export function moduleBase(mod: string): string {
  return `${ordsRoot}/${mod}`;
}
