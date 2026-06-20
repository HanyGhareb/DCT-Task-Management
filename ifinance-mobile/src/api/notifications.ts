/**
 * notifications.ts — list / unread count / mark read.
 */
import { api } from './client';
import type { AppNotification } from './types';

export async function getNotifications(): Promise<AppNotification[]> {
  const r = await api.get<{ items: AppNotification[] }>('/notifications/');
  return r.items ?? [];
}

export async function getUnreadCount(): Promise<number> {
  // Cheap COUNT endpoint (Wave 3); fall back to counting the full list.
  try {
    const r = await api.get<{ count: number }>('/notifications/count', { silent: true });
    return r.count ?? 0;
  } catch {
    try {
      const items = await getNotifications();
      return items.filter((n) => n.isRead === 'N').length;
    } catch {
      return 0;
    }
  }
}

export async function markRead(notifId: number): Promise<void> {
  await api.put(`/notifications/${notifId}/read`, {});
}
