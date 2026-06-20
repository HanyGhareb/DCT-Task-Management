/**
 * atd.ts — Analytics Loader (App 208) read API. All under `api.for('atd')`
 * (`…/ords/admin/atd`); the shared session authenticates it (handlers enforce
 * SYS_ADMIN). Writes (enqueue/reset/reap) are issued via `useQueuedMutation`
 * with `requireOnline: true` from the screens, not here.
 *
 * Shapes verified live against PROD (2026-06-20) — see MOBILE_PHASE2_PLAN.md.
 */
import { api } from './client';

const atd = () => api.for('atd');

export interface AtdQueueCounts {
  ready: number;
  claimed: number;
  done: number;
  failed: number;
}

export interface AtdRecentRun {
  runId: number;
  jobName: string;
  status: string;
  rowCount: number;
  started: string;
  finished: string;
}

export interface AtdAlert {
  runId: number;
  jobName: string;
  status: string;
  kind: 'WARNING' | 'FAILED';
  message: string;
  started: string;
}

export interface AtdDashboard {
  queue: AtdQueueCounts;
  jobs: number;
  enabledJobs: number;
  runs24h: number;
  success24h: number;
  successRate: number;
  lastFinished: string | null;
  recent: AtdRecentRun[];
  alerts: AtdAlert[];
}

export interface AtdJob {
  jobName: string;
  envName: string;
  targetName: string;
  sourceRef: string;
  stageTable: string;
  loadMode: string;
  priority: number;
  runOrder: number;
  enabled: 'Y' | 'N';
  prepared: 'Y' | 'N';
  runStatus: string;
  lastRunId: number | null;
  lastRunStatus: string | null;
  lastFinished: string | null;
  lastDurationSec: number | null;
}

export interface AtdRun {
  runId: number;
  jobName: string;
  track: string;
  status: string;
  rowCount: number;
  warn: 'Y' | 'N';
  started: string;
  finished: string | null;
  durationSec: number;
  message?: string;
}

export interface AtdRunDetail extends AtdRun {
  csvChecksum?: string;
}

export function getAtdDashboard(): Promise<AtdDashboard> {
  return atd().get<AtdDashboard>('/dashboard');
}

export async function getAtdJobs(): Promise<AtdJob[]> {
  const r = await atd().get<{ items: AtdJob[] }>('/jobs');
  return r.items ?? [];
}

export async function getAtdRuns(offset = 0, limit = 30): Promise<AtdRun[]> {
  const r = await atd().get<{ items: AtdRun[] }>(`/runs?limit=${limit}&offset=${offset}`);
  return r.items ?? [];
}

export function getAtdRun(runId: number): Promise<AtdRunDetail> {
  return atd().get<AtdRunDetail>(`/runs/${runId}`);
}

/* ── Environments ──────────────────────────────────────────────────────────── */
export interface AtdEnv {
  envName: string;
  description?: string;
  analyticsBaseUrl?: string;
  xmlpserverBaseUrl?: string;
  authType: string; // WSS | BASIC | OAUTH | SESSION
  credentialRef?: string;
  extractTrack: string; // API | BROWSER
  enabled: 'Y' | 'N';
}
export const ENV_AUTH_TYPES = ['WSS', 'BASIC', 'OAUTH', 'SESSION'] as const;
export const ENV_TRACKS = ['API', 'BROWSER'] as const;

export async function getAtdEnvs(): Promise<AtdEnv[]> {
  const r = await atd().get<{ items: AtdEnv[] }>('/envs');
  return r.items ?? [];
}

/* ── Targets ───────────────────────────────────────────────────────────────── */
export interface AtdTarget {
  targetName: string;
  description?: string;
  dbKind: string; // LOCAL_ATP | REMOTE
  dbLink?: string;
  schemaName?: string;
  tnsAlias?: string;
  enabled: 'Y' | 'N';
}
export const TARGET_KINDS = ['LOCAL_ATP', 'REMOTE'] as const;

export async function getAtdTargets(): Promise<AtdTarget[]> {
  const r = await atd().get<{ items: AtdTarget[] }>('/targets');
  return r.items ?? [];
}

/* ── Runner settings (/config) ─────────────────────────────────────────────── */
export interface AtdConfigItem {
  key: string;
  value: string;
  isSecret: 'Y' | 'N';
  secretSet: 'Y' | 'N';
  valueType: 'STRING' | 'NUMBER' | 'ENUM' | 'BOOL';
  enumValues: string; // CSV
  description: string;
  updatedBy?: string;
  updatedAt?: string;
}
export async function getAtdConfig(): Promise<AtdConfigItem[]> {
  const r = await atd().get<{ items: AtdConfigItem[] }>('/config');
  return r.items ?? [];
}

/* ── Discovery (subject areas) ─────────────────────────────────────────────── */
export interface AtdSubjectArea {
  subjectArea: string;
  status: string; // QUEUED | READY | FAILED | ...
  folderCount: number;
  columnCount: number;
  message?: string;
  scrapedAt?: string;
}
export async function getAtdSubjectAreas(): Promise<AtdSubjectArea[]> {
  const r = await atd().get<{ items: AtdSubjectArea[] }>('/subject-areas');
  return r.items ?? [];
}

export interface AtdDiscoveryRun {
  runId: number;
  subjectArea: string;
  status: string;
  columnCount: number;
  message?: string;
  started: string;
  finished?: string;
  durationSec: number | null;
}
export async function getAtdDiscoveryRuns(offset = 0, limit = 30): Promise<AtdDiscoveryRun[]> {
  const r = await atd().get<{ items: AtdDiscoveryRun[] }>(`/subject-areas/runs?limit=${limit}&offset=${offset}`);
  return r.items ?? [];
}
