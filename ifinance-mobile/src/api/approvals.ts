/**
 * approvals.ts — unified cross-module approvals (PC/DT/FL/CC/AR).
 */
import { api } from './client';
import type { PendingApproval } from './types';

const wf = api.for('wf');

export async function getPending(): Promise<PendingApproval[]> {
  const r = await wf.get<{ items: PendingApproval[] }>('/worklist');
  return r.items ?? [];
}

export async function actOnApproval(
  taskId: number,
  outcome: string,
  comments: string,
): Promise<{ ok: boolean; action: string }> {
  // Comments are required server-side (ORDS returns 400 otherwise).
  return wf.post(`/tasks/${taskId}/action`, { outcome, comments });
}
