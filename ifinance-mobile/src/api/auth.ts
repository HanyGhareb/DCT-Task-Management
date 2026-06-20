/**
 * auth.ts — login / logout / boot. Mirrors authService.js: login posts
 * credentials and the response IS the session payload (token = sessionId).
 */
import { api } from './client';
import type { Session } from './types';

function initials(name?: string): string {
  const parts = (name || '').trim().split(/\s+/);
  if (parts.length >= 2) return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  return (parts[0] || '?')[0].toUpperCase();
}

export async function login(username: string, password: string): Promise<Session> {
  const data = await api.post<Session>('/auth/login', { username, password });
  data.roles = (data.rolesCsv || '').split(',').filter(Boolean);
  (data as any).initials = initials(data.displayName);
  return data;
}

export async function logout(): Promise<void> {
  // Close the server session (Bearer still set). Empty body — ORDS 400s a
  // body-less POST. Silent: a failed logout must never block the UI.
  await api.post('/auth/logout', {}, { silent: true }).catch(() => {});
}

/** GET /dct/boot — system settings incl. THEME_BRAND_COLOR / focus theme. */
export interface BootSettings {
  [key: string]: string | number | boolean;
}
export async function boot(): Promise<BootSettings> {
  return api.get<BootSettings>('/boot', { silent: true }).catch(() => ({}));
}
