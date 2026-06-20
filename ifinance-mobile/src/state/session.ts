/**
 * session.ts — Zustand store for the auth session (atomic state, avoids
 * context-wide re-renders per react-native-best-practices).
 *
 * Owns: the Session object, the token wiring into the API client, restore on
 * boot from secure store, login, logout, and the 401 expiry path.
 */
import { create } from 'zustand';
import { login as apiLogin, logout as apiLogout } from '@/api/auth';
import { setAuthToken, setOnExpire } from '@/api/client';
import { registerDevice, unregisterDevice } from '@/api/devices';
import { clearSession, loadSession, saveSession } from '@/services/secureStore';
import { getPushToken, platformTag } from '@/services/push';
import type { Session } from '@/api/types';

interface SessionState {
  session: Session | null;
  status: 'loading' | 'authed' | 'anon';
  /** Set true once a session exists but is locked behind biometrics. */
  locked: boolean;
  restore: () => Promise<void>;
  signIn: (username: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  unlock: () => void;
  expire: () => void;
  patchSession: (fields: Partial<Session>) => void;
  /** Obtain the push token and register the device (idempotent; safe to call
   *  on every launch). No-ops if no token (e.g. permission denied / no FCM). */
  ensurePushRegistered: () => Promise<void>;
}

export const useSession = create<SessionState>((set, get) => ({
  session: null,
  status: 'loading',
  locked: false,

  restore: async () => {
    const s = await loadSession();
    if (s?.sessionId) {
      setAuthToken(s.sessionId);
      // Existing session → require a biometric unlock before showing data.
      set({ session: s, status: 'authed', locked: true });
    } else {
      set({ session: null, status: 'anon', locked: false });
    }
  },

  signIn: async (username, password) => {
    const s = await apiLogin(username, password);
    setAuthToken(s.sessionId);
    await saveSession(s);
    set({ session: s, status: 'authed', locked: false });
    void useSession.getState().ensurePushRegistered();
  },

  signOut: async () => {
    const token = await getPushToken().catch(() => null);
    if (token) await unregisterDevice(token);
    await apiLogout();
    await clearSession();
    setAuthToken(null);
    set({ session: null, status: 'anon', locked: false });
  },

  ensurePushRegistered: async () => {
    if (!get().session) return;
    try {
      const token = await getPushToken();
      if (token) await registerDevice({ token, platform: platformTag() });
    } catch {
      /* best-effort: push registration must never break the session */
    }
  },

  unlock: () => set({ locked: false }),

  expire: () => {
    void clearSession();
    setAuthToken(null);
    set({ session: null, status: 'anon', locked: false });
  },

  patchSession: (fields) => {
    const cur = get().session;
    if (!cur) return;
    const next = { ...cur, ...fields };
    set({ session: next });
    void saveSession(next);
  },
}));

/** Reactive role check from the session's rolesCsv (e.g. SYS_ADMIN gates the
 *  Analytics tab). Re-renders when the membership flips. */
export const useHasRole = (role: string): boolean =>
  useSession((s) => (s.session?.rolesCsv || '').split(',').filter(Boolean).includes(role));

// Wire the API client's 401 handler to the store exactly once.
setOnExpire(() => useSession.getState().expire());
