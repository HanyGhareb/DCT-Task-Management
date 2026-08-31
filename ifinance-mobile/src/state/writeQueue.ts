/**
 * writeQueue.ts — persisted offline write-queue (Phase 2 foundation).
 *
 * Queueable writes (forms) that fail on the network, or are issued while
 * offline, are stored here and retried automatically: on reconnect (subscribes
 * to connectivity), on app foreground (AppState), and on a light interval while
 * items remain. The UI reviews/retries/discards them in the Outbox screen.
 *
 * Retry policy per flush attempt:
 *   - network (status 0) / 401  → transient: stop, leave pending (retry later)
 *   - 4xx (except 401)          → permanent (validation/business): mark FAILED
 *   - 5xx                       → bump attempts; cap (MAX_ATTEMPTS) → FAILED
 * On success the item's `invalidateKeys` are invalidated so lists refresh.
 *
 * Triggering writes (e.g. ATD job enqueue) do NOT use this queue — they are
 * `requireOnline` in `useQueuedMutation` and fail fast offline.
 */
import { create } from 'zustand';
import { AppState } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { api } from '@/api/client';
import { queryClient } from '@/state/queryClient';
import { useConnectivity, isOnline } from '@/services/connectivity';
import type { ApiError } from '@/api/types';

const STORAGE_KEY_PREFIX = 'ifinance_write_queue';
const MAX_ATTEMPTS = 5;
const FLUSH_INTERVAL_MS = 30_000;

export type QueueStatus = 'pending' | 'failed';
export type QueueMethod = 'POST' | 'PUT' | 'DELETE';

export interface QueueItem {
  id: string;
  /** User that created the write. Never replay an item as another identity. */
  userId: number;
  /** ORDS module for `api.for(module)`; '' (or omitted) = shared `/dct`. */
  module: string;
  method: QueueMethod;
  path: string;
  body?: unknown;
  /** Human label shown in the Outbox. */
  label: string;
  /** Query keys to invalidate once the item lands. */
  invalidateKeys?: string[][];
  createdAt: number;
  status: QueueStatus;
  attempts: number;
  error?: string;
}

interface WriteQueueState {
  items: QueueItem[];
  hydrated: boolean;
  ownerUserId: number | null;
  hydrate: (userId: number) => Promise<void>;
  /** Add an item and attempt an immediate flush. */
  enqueue: (item: Omit<QueueItem, 'id' | 'userId' | 'createdAt' | 'status' | 'attempts'>) => Promise<void>;
  flush: () => Promise<void>;
  retry: (id: string) => Promise<void>;
  discard: (id: string) => void;
  clearFailed: () => void;
  clearMemory: () => void;
}

let flushing = false;
let interval: ReturnType<typeof setInterval> | null = null;

export function queueStorageKey(userId: number): string {
  return `${STORAGE_KEY_PREFIX}:${userId}`;
}

export function queueItemsForUser(items: QueueItem[], userId: number): QueueItem[] {
  return items.filter((item) => item.userId === userId);
}

function persist(userId: number | null, items: QueueItem[]): void {
  if (userId !== null) void AsyncStorage.setItem(queueStorageKey(userId), JSON.stringify(items));
}

function genId(): string {
  return `${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 8)}`;
}

/** Send one item via the correct module client. */
function send(item: QueueItem): Promise<unknown> {
  const client = item.module ? api.for(item.module) : api;
  if (item.method === 'POST') return client.post(item.path, item.body);
  if (item.method === 'PUT') return client.put(item.path, item.body);
  return client.delete(item.path);
}

export const useWriteQueue = create<WriteQueueState>((set, get) => ({
  items: [],
  hydrated: false,
  ownerUserId: null,

  hydrate: async (userId) => {
    try {
      const raw = await AsyncStorage.getItem(queueStorageKey(userId));
      const parsed: QueueItem[] = raw ? JSON.parse(raw) : [];
      const items = queueItemsForUser(parsed, userId);
      set({ items, hydrated: true, ownerUserId: userId });
    } catch {
      set({ items: [], hydrated: true, ownerUserId: userId });
    }
    if (!interval) interval = setInterval(() => void get().flush(), FLUSH_INTERVAL_MS);
    void get().flush();
  },

  enqueue: async (partial) => {
    const ownerUserId = get().ownerUserId;
    if (ownerUserId === null) throw { status: 401, message: 'No active session.' } as ApiError;
    const item: QueueItem = {
      ...partial,
      userId: ownerUserId,
      id: genId(),
      createdAt: Date.now(),
      status: 'pending',
      attempts: 0,
    };
    const items = [...get().items, item];
    set({ items });
    persist(ownerUserId, items);
    await get().flush();
  },

  flush: async () => {
    const ownerUserId = get().ownerUserId;
    if (flushing || !isOnline() || ownerUserId === null) return;
    flushing = true;
    try {
      // Process oldest-first; re-read state each loop since it can change.
      // We snapshot the pending ids up front to avoid an infinite loop on retries.
      const pendingIds = get().items.filter((i) => i.status === 'pending').map((i) => i.id);
      for (const id of pendingIds) {
        const item = get().items.find((i) => i.id === id);
        if (!item || item.status !== 'pending') continue;
        try {
          await send(item);
          // success → drop it and refresh affected lists
          const next = get().items.filter((i) => i.id !== id);
          set({ items: next });
          persist(ownerUserId, next);
          item.invalidateKeys?.forEach((key) => void queryClient.invalidateQueries({ queryKey: key }));
        } catch (e) {
          const status = (e as ApiError).status ?? 0;
          const message = (e as ApiError).message || 'Submit failed';
          if (status === 0 || status === 401) {
            // transient → stop; everything stays pending for the next trigger
            break;
          }
          if (status >= 400 && status < 500) {
            // permanent → mark failed, keep going with the rest
            mark(set, get, id, { status: 'failed', error: message });
            continue;
          }
          // 5xx → bump attempts; cap then fail; stop this pass (back off)
          const attempts = item.attempts + 1;
          if (attempts >= MAX_ATTEMPTS) {
            mark(set, get, id, { status: 'failed', error: message, attempts });
          } else {
            mark(set, get, id, { attempts, error: message });
          }
          break;
        }
      }
    } finally {
      flushing = false;
    }
  },

  retry: async (id) => {
    mark(set, get, id, { status: 'pending', error: undefined, attempts: 0 });
    await get().flush();
  },

  discard: (id) => {
    const next = get().items.filter((i) => i.id !== id);
    set({ items: next });
    persist(get().ownerUserId, next);
  },

  clearFailed: () => {
    const next = get().items.filter((i) => i.status !== 'failed');
    set({ items: next });
    persist(get().ownerUserId, next);
  },

  clearMemory: () => set({ items: [], hydrated: false, ownerUserId: null }),
}));

function mark(
  set: (partial: Partial<WriteQueueState>) => void,
  get: () => WriteQueueState,
  id: string,
  patch: Partial<QueueItem>,
): void {
  const next = get().items.map((i) => (i.id === id ? { ...i, ...patch } : i));
  set({ items: next });
  persist(get().ownerUserId, next);
}

/** Selectors for the UI (badges). */
export const selectPendingCount = (s: WriteQueueState): number =>
  s.items.filter((i) => i.status === 'pending').length;
export const selectFailedCount = (s: WriteQueueState): number =>
  s.items.filter((i) => i.status === 'failed').length;

// ── Auto-flush triggers (module-load, once) ──────────────────────────────────
// Reconnect: flush when connectivity flips offline→online.
useConnectivity.subscribe((s, prev) => {
  if (s.online && !prev.online) void useWriteQueue.getState().flush();
});
// App foreground.
AppState.addEventListener('change', (st) => {
  if (st === 'active') void useWriteQueue.getState().flush();
});
