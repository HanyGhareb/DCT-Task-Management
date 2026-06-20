/**
 * useQueuedMutation — the one write primitive for Phase 2 submissions.
 *
 * Two policies:
 *  - `requireOnline: false` (default, forms): online → submit directly; a network
 *    failure (status 0) is enqueued for later; offline → enqueued optimistically.
 *    Resolves `{ queued: true }` when it went to the Outbox.
 *  - `requireOnline: true` (triggers, e.g. ATD job enqueue): never queues. Offline
 *    → rejects immediately with a status-0 error so the user knows it did NOT fire.
 *
 * On a direct success the configured `invalidateKeys` refresh affected lists; the
 * queue does the same when it later drains an enqueued item.
 */
import { useMutation, type UseMutationResult } from '@tanstack/react-query';
import { api } from '@/api/client';
import { queryClient } from '@/state/queryClient';
import { useWriteQueue, type QueueMethod } from '@/state/writeQueue';
import { isOnline } from '@/services/connectivity';
import type { ApiError } from '@/api/types';

/** Thrown when a `requireOnline` action is attempted offline. Screens map
 *  `status === 0` to the offline message. */
export const OFFLINE_ERROR: ApiError = { status: 0, message: 'offline' };

export interface QueuedMutationConfig<V> {
  /** ORDS module for `api.for(module)`; omit for the shared `/dct`. */
  module?: string;
  /** HTTP method — static or derived per call (default POST). */
  method?: QueueMethod | ((vars: V) => QueueMethod);
  path: (vars: V) => string;
  body?: (vars: V) => unknown;
  /** Human label stored with a queued item (shown in the Outbox). */
  label: (vars: V) => string;
  invalidateKeys?: (vars: V) => string[][];
  requireOnline?: boolean;
}

export type QueuedResult<T> = { queued: false; data: T } | { queued: true };

export function useQueuedMutation<V, T = unknown>(
  cfg: QueuedMutationConfig<V>,
): UseMutationResult<QueuedResult<T>, ApiError, V> {
  const enqueue = useWriteQueue((s) => s.enqueue);

  return useMutation<QueuedResult<T>, ApiError, V>({
    mutationFn: async (vars: V): Promise<QueuedResult<T>> => {
      const module = cfg.module ?? '';
      const method: QueueMethod = typeof cfg.method === 'function' ? cfg.method(vars) : cfg.method ?? 'POST';
      const path = cfg.path(vars);
      const body = cfg.body?.(vars);
      const keys = cfg.invalidateKeys?.(vars) ?? [];
      const client = module ? api.for(module) : api;

      const direct = async (): Promise<T> => {
        let data: T;
        if (method === 'POST') data = await client.post<T>(path, body);
        else if (method === 'PUT') data = await client.put<T>(path, body);
        else data = await client.delete<T>(path);
        keys.forEach((k) => void queryClient.invalidateQueries({ queryKey: k }));
        return data;
      };

      const queueIt = async (): Promise<QueuedResult<T>> => {
        await enqueue({ module, method, path, body, label: cfg.label(vars), invalidateKeys: keys });
        return { queued: true };
      };

      if (cfg.requireOnline) {
        if (!isOnline()) throw OFFLINE_ERROR;
        return { queued: false, data: await direct() };
      }

      if (isOnline()) {
        try {
          return { queued: false, data: await direct() };
        } catch (e) {
          if ((e as ApiError).status === 0) return queueIt(); // network blip → queue
          throw e; // validation/business error → surface now
        }
      }
      return queueIt(); // offline → optimistic queue
    },
  });
}
