/**
 * secureStore.ts — session persistence in the OS keystore
 * (iOS Keychain / Android Keystore via expo-secure-store). Replaces the web's
 * localStorage `ifinance_jet_session`. NEVER store the token in AsyncStorage.
 */
import * as SecureStore from 'expo-secure-store';
import { config } from '@/config';
import type { Session } from '@/api/types';

export async function saveSession(session: Session): Promise<void> {
  await SecureStore.setItemAsync(config.sessionKey, JSON.stringify(session));
}

export async function loadSession(): Promise<Session | null> {
  try {
    const raw = await SecureStore.getItemAsync(config.sessionKey);
    return raw ? (JSON.parse(raw) as Session) : null;
  } catch {
    return null;
  }
}

export async function clearSession(): Promise<void> {
  await SecureStore.deleteItemAsync(config.sessionKey);
}
