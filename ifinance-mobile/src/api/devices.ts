/**
 * devices.ts — push-token registration against the new /dct/devices endpoints
 * (db/v2/28_push_tokens.sql). Called after login (register) and on logout
 * (unregister). The body-less DELETE sends no Content-Type (ORDS gotcha).
 */
import { api } from './client';

export interface RegisterDeviceInput {
  token: string; // Expo push token (ExponentPushToken[...]) for v1
  platform: 'IOS' | 'ANDROID';
  appVersion?: string;
}

export async function registerDevice(input: RegisterDeviceInput): Promise<void> {
  await api.post('/devices/register', input, { silent: true }).catch(() => {});
}

export async function unregisterDevice(token: string): Promise<void> {
  await api.delete(`/devices/${encodeURIComponent(token)}`, { silent: true }).catch(() => {});
}
