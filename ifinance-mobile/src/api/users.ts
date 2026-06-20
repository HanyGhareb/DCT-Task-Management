/**
 * users.ts — directory lookup for pickers (e.g. choosing a delegate).
 * Backed by GET /dct/users/?search=&status=A&limit= (server-side search).
 */
import { api } from './client';

export interface UserLite {
  userId: number;
  username: string;
  displayName: string;
  displayNameAr?: string;
  email?: string;
  orgName?: string;
  color?: string;
}

export async function searchUsers(search: string): Promise<UserLite[]> {
  const q = search.trim() ? `&search=${encodeURIComponent(search.trim())}` : '';
  const r = await api.get<{ items: UserLite[] }>(`/users/?status=A&limit=25${q}`);
  return r.items ?? [];
}
