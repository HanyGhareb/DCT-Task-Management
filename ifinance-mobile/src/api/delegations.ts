/**
 * delegations.ts — list mine / create / cancel.
 */
import { api } from './client';
import type { CreateDelegationInput, Delegation } from './types';

export async function getMyDelegations(): Promise<Delegation[]> {
  const r = await api.get<{ items: Delegation[] }>('/delegations/?mine=Y');
  return r.items ?? [];
}

export async function createDelegation(
  input: CreateDelegationInput,
): Promise<{ delegationId: number; ok: boolean }> {
  return api.post('/delegations/', input);
}

export async function cancelDelegation(delegationId: number): Promise<void> {
  await api.post(`/delegations/${delegationId}/cancel`, {});
}
