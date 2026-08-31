import { queueItemsForUser, queueStorageKey, type QueueItem } from '../writeQueue';

const item = (id: string, userId: number): QueueItem => ({
  id,
  userId,
  module: 'atd',
  method: 'POST',
  path: '/jobs/enqueue',
  label: `job-${id}`,
  createdAt: 1,
  status: 'pending',
  attempts: 0,
});

describe('offline queue identity isolation', () => {
  it('uses a different persistence key for each user', () => {
    expect(queueStorageKey(17)).toBe('ifinance_write_queue:17');
    expect(queueStorageKey(17)).not.toBe(queueStorageKey(18));
  });

  it('never hydrates writes owned by another user', () => {
    expect(queueItemsForUser([item('a', 17), item('b', 18)], 18)).toEqual([item('b', 18)]);
  });
});
