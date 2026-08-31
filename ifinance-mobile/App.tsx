/**
 * App.tsx — root: providers (SafeArea, Theme, i18n, React Query w/ offline
 * persistence), session restore + biometric lock gate, push deep-link routing.
 */
import React, { useEffect, useRef } from 'react';
import { StatusBar } from 'expo-status-bar';
import { NavigationContainer, type NavigationContainerRef } from '@react-navigation/native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { PersistQueryClientProvider } from '@tanstack/react-query-persist-client';
import * as Notifications from 'expo-notifications';
import { ActivityIndicator, AppState, View } from 'react-native';

import { ThemeProvider, useTheme } from '@/theme/ThemeProvider';
import { I18nProvider } from '@/i18n/I18nProvider';
import { asyncStoragePersister, queryClient } from '@/state/queryClient';
import { useSession } from '@/state/session';
import { RootNavigator } from '@/navigation/RootNavigator';
import { LoginScreen } from '@/screens/LoginScreen';
import { LockScreen } from '@/screens/LockScreen';
import { linking } from '@/navigation/linking';
import { OfflineBanner } from '@/components/OfflineBanner';
import { extractDeepLink } from '@/services/push';
import type { RootStackParamList } from '@/navigation/types';
import { config } from '@/config';
import { getPending } from '@/api/approvals';
import type { PushDeepLink } from '@/services/push';

function Gate() {
  const { palette } = useTheme();
  const status = useSession((s) => s.status);
  const locked = useSession((s) => s.locked);
  const restore = useSession((s) => s.restore);
  const navRef = useRef<NavigationContainerRef<RootStackParamList>>(null);
  const backgroundedAt = useRef<number | null>(null);
  const pendingPush = useRef<PushDeepLink | null>(null);

  useEffect(() => {
    void restore();
  }, [restore]);

  // Re-try push registration whenever the app is authed + unlocked (covers
  // relaunch/biometric-unlock and permission/FCM that became available later).
  useEffect(() => {
    if (status === 'authed' && !locked) {
      void useSession.getState().ensurePushRegistered();
    }
  }, [status, locked]);

  useEffect(() => {
    const sub = AppState.addEventListener('change', (next) => {
      if (next === 'background' || next === 'inactive') {
        backgroundedAt.current ??= Date.now();
      } else if (next === 'active') {
        const elapsed = backgroundedAt.current === null ? 0 : Date.now() - backgroundedAt.current;
        backgroundedAt.current = null;
        if (elapsed >= config.backgroundLockMs) useSession.getState().lock();
      }
    });
    return () => sub.remove();
  }, []);

  // Route notification taps to their exact task when the payload identifies it.
  useEffect(() => {
    const route = async (link: PushDeepLink | null) => {
      if (!link) return;
      if (status !== 'authed' || locked || !navRef.current?.isReady()) {
        pendingPush.current = link;
        return;
      }
      const items = await getPending().catch(() => []);
      const sourceId = link.sourceId === undefined ? null : String(link.sourceId);
      const match = items.find((item) =>
        String(item.id) === sourceId || String(item.sourceRecordId ?? '') === sourceId,
      );
      if (match) navRef.current.navigate('ApprovalDetail', { approval: match });
      else navRef.current.navigate('Tabs', { screen: 'Approvals' } as never);
      pendingPush.current = null;
    };
    const sub = Notifications.addNotificationResponseReceivedListener((response) => {
      void route(extractDeepLink(response));
    });
    void Notifications.getLastNotificationResponseAsync().then(async (response) => {
      const link = extractDeepLink(response);
      if (link) await Notifications.clearLastNotificationResponseAsync();
      await route(link);
    });
    return () => sub.remove();
  }, [status, locked]);

  useEffect(() => {
    if (status === 'authed' && !locked && pendingPush.current) {
      // Navigation mounts on this render; yield once before asking it to route.
      const timer = setTimeout(() => {
        const link = pendingPush.current;
        if (!link || !navRef.current?.isReady()) return;
        void getPending().then((items) => {
          const sourceId = link.sourceId === undefined ? null : String(link.sourceId);
          const match = items.find((item) => String(item.id) === sourceId || String(item.sourceRecordId ?? '') === sourceId);
          if (match) navRef.current?.navigate('ApprovalDetail', { approval: match });
          else navRef.current?.navigate('Tabs', { screen: 'Approvals' } as never);
          pendingPush.current = null;
        });
      }, 0);
      return () => clearTimeout(timer);
    }
  }, [status, locked]);

  if (status === 'loading') {
    return (
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: palette.bg }}>
        <ActivityIndicator color={palette.brand} size="large" />
      </View>
    );
  }
  if (status === 'anon') return <LoginScreen />;
  if (locked) return <LockScreen />;

  return (
    <View style={{ flex: 1 }}>
      <NavigationContainer ref={navRef} linking={linking}>
        <RootNavigator />
      </NavigationContainer>
      <OfflineBanner />
    </View>
  );
}

export default function App() {
  return (
    <SafeAreaProvider>
      <ThemeProvider>
        <I18nProvider>
          <PersistQueryClientProvider client={queryClient} persistOptions={{ persister: asyncStoragePersister }}>
            <StatusBar style="auto" />
            <Gate />
          </PersistQueryClientProvider>
        </I18nProvider>
      </ThemeProvider>
    </SafeAreaProvider>
  );
}
