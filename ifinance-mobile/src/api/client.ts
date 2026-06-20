/**
 * client.ts — the ONE fetch wrapper (TS port of `final apps/shared/js/api.js`).
 *
 * - Injects Bearer token from the in-memory session (set after login).
 * - No Content-Type on body-less requests (ORDS 400s a DELETE that declares
 *   application/json with an empty body).
 * - 401 (non /auth/*) → fire the onExpire handler (clears session, routes to
 *   Login) and reject with a normalized ApiError.
 * - Error message taken from data.message || data.error (matches ORDS err()).
 * - putBinary streams a File/Blob as the raw body with metadata in the query
 *   string (no base64), mirroring api.putBinary for profile-photo upload.
 */
import { config, moduleBase } from '@/config';
import type { ApiError } from './types';

let authToken: string | null = null;
let onExpire: (() => void) | null = null;

/** Wire the active token (called by the session store on login/restore). */
export function setAuthToken(token: string | null): void {
  authToken = token;
}

/** Register the 401 handler (called once by the session store). */
export function setOnExpire(handler: () => void): void {
  onExpire = handler;
}

interface CallOpts {
  silent?: boolean;
  /** Override the module base (default `config.apiBase` = `/dct`). Use
   *  `api.for(mod)` instead of setting this directly. */
  base?: string;
}

async function call<T>(method: string, path: string, body?: unknown, opts: CallOpts = {}): Promise<T> {
  const headers: Record<string, string> = {};
  if (body !== undefined) headers['Content-Type'] = 'application/json';
  if (authToken) headers['Authorization'] = `Bearer ${authToken}`;

  const isAuthCall = path.indexOf('/auth/') === 0;
  const base = opts.base ?? config.apiBase;

  let res: Response;
  try {
    res = await fetch(base + path, {
      method,
      headers,
      body: body !== undefined ? JSON.stringify(body) : undefined,
    });
  } catch (netErr) {
    throw { status: 0, message: String(netErr) } as ApiError;
  }

  if (res.status === 401 && !isAuthCall) {
    onExpire?.();
    throw { status: 401, message: 'Session expired. Please sign in again.' } as ApiError;
  }

  const text = await res.text();
  let data: any = {};
  try {
    if (text) data = JSON.parse(text);
  } catch {
    /* tolerant: non-JSON body stays {} */
  }

  if (!res.ok) {
    const msg = (data && (data.message || data.error)) || `Request failed (${res.status})`;
    throw { status: res.status, message: msg } as ApiError;
  }
  return data as T;
}

async function callBinary<T>(
  method: string,
  path: string,
  file: Blob,
  opts: { mime?: string; query?: Record<string, string | number | undefined>; base?: string } = {},
): Promise<T> {
  const headers: Record<string, string> = {
    'Content-Type': opts.mime || (file as any).type || 'application/octet-stream',
  };
  if (authToken) headers['Authorization'] = `Bearer ${authToken}`;

  const q: string[] = [];
  Object.entries(opts.query ?? {}).forEach(([k, v]) => {
    if (v !== undefined && v !== null && v !== '') {
      q.push(`${encodeURIComponent(k)}=${encodeURIComponent(String(v))}`);
    }
  });
  const base = opts.base ?? config.apiBase;
  const url = base + path + (q.length ? (path.includes('?') ? '&' : '?') + q.join('&') : '');

  let res: Response;
  try {
    res = await fetch(url, { method, headers, body: file });
  } catch (netErr) {
    throw { status: 0, message: String(netErr) } as ApiError;
  }
  if (res.status === 401) {
    onExpire?.();
    throw { status: 401, message: 'Session expired. Please sign in again.' } as ApiError;
  }
  const text = await res.text();
  let data: any = {};
  try {
    if (text) data = JSON.parse(text);
  } catch {
    /* ignore */
  }
  if (!res.ok) {
    const msg = (data && (data.message || data.error)) || `Upload failed (${res.status})`;
    throw { status: res.status, message: msg } as ApiError;
  }
  return data as T;
}

type BinaryOpts = { mime?: string; query?: Record<string, string | number | undefined>; base?: string };

/** Verb helpers bound to a base URL (default `/dct`; `api.for(mod)` rebinds). */
export interface ApiClient {
  get: <T>(path: string, opts?: CallOpts) => Promise<T>;
  post: <T>(path: string, body?: unknown, opts?: CallOpts) => Promise<T>;
  put: <T>(path: string, body?: unknown, opts?: CallOpts) => Promise<T>;
  delete: <T>(path: string, opts?: CallOpts) => Promise<T>;
  putBinary: <T>(path: string, file: Blob, opts?: BinaryOpts) => Promise<T>;
}

function makeClient(base?: string): ApiClient {
  const withBase = <O extends { base?: string }>(opts?: O): O =>
    ({ ...(opts as object), ...(base ? { base } : {}) }) as O;
  return {
    get: (path, opts) => call('GET', path, undefined, withBase(opts)),
    post: (path, body, opts) => call('POST', path, body, withBase(opts)),
    put: (path, body, opts) => call('PUT', path, body, withBase(opts)),
    delete: (path, opts) => call('DELETE', path, undefined, withBase(opts)),
    putBinary: (path, file, opts) => callBinary('PUT', path, file, withBase(opts)),
  };
}

/** Default client (shared `/dct` module) + `api.for(mod)` for other modules. */
export const api: ApiClient & { for: (mod: string) => ApiClient } = {
  ...makeClient(),
  /** Bind a client to another ORDS module, e.g. `api.for('atd').get('/dashboard')`. */
  for: (mod: string) => makeClient(moduleBase(mod)),
};
