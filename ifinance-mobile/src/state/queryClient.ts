/**
 * queryClient.ts — TanStack Query client + AsyncStorage persistence.
 * Persistence gives offline READ of the approvals/notifications lists
 * (per the plan's offline strategy). Writes still require connectivity.
 */
import { QueryClient } from '@tanstack/react-query';
import { createAsyncStoragePersister } from '@tanstack/query-async-storage-persister';
import AsyncStorage from '@react-native-async-storage/async-storage';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      gcTime: 24 * 60 * 60 * 1000, // keep 24h so offline reads survive restarts
      retry: 1,
      refetchOnReconnect: true,
    },
    mutations: { retry: 0 },
  },
});

export const asyncStoragePersister = createAsyncStoragePersister({
  storage: AsyncStorage,
  key: 'ifinance_rq_cache',
});
