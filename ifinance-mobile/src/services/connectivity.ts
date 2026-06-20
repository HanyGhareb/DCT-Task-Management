/**
 * connectivity.ts — online/offline state from NetInfo.
 *
 * Exposes a Zustand store (`useConnectivity`) for the UI (offline banner) and a
 * synchronous `isOnline()` for non-React code (the write-queue). Subscribes to
 * NetInfo once at module load; the write-queue listens to this store to flush
 * on reconnect (kept here dependency-free to avoid a import cycle).
 */
import NetInfo from '@react-native-community/netinfo';
import { create } from 'zustand';

interface ConnState {
  /** True until NetInfo says we are definitively offline. */
  online: boolean;
}

export const useConnectivity = create<ConnState>(() => ({ online: true }));

/** Treat unknown (`null`) as online — only an explicit `false` means offline,
 *  so we never wrongly block actions on a slow reachability probe. */
function derive(isConnected: boolean | null, reachable: boolean | null): boolean {
  return isConnected !== false && reachable !== false;
}

let cached = true;
export function isOnline(): boolean {
  return cached;
}

function apply(isConnected: boolean | null, reachable: boolean | null): void {
  const next = derive(isConnected, reachable);
  cached = next;
  if (useConnectivity.getState().online !== next) useConnectivity.setState({ online: next });
}

NetInfo.addEventListener((s) => apply(s.isConnected, s.isInternetReachable));
void NetInfo.fetch().then((s) => apply(s.isConnected, s.isInternetReachable));
