/**
 * approvals.ts — unified cross-module approvals (PC/DT/FL/CC/AR).
 */
import { api } from './client';
import type { ApprovalAction, PendingApproval } from './types';

export async function getPending(): Promise<PendingApproval[]> {
  const r = await api.get<{ items: PendingApproval[] }>('/approvals/pending');
  return r.items ?? [];
}

export async function actOnApproval(
  instanceId: number,
  action: ApprovalAction,
  comments: string,
): Promise<{ ok: boolean; action: string }> {
  // Comments are required server-side (ORDS returns 400 otherwise).
  return api.post(`/approvals/${instanceId}/action`, { action, comments });
}
