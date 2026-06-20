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
