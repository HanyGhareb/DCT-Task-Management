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
import { ActivityIndicator, View } from 'react-native';

import { ThemeProvider, useTheme } from '@/theme/ThemeProvider';
import { I18nProvider } from '@/i18n/I18nProvider';
import { asyncStoragePersister, queryClient } from '@/state/queryClient';
import { useSession } from '@/state/session';
import { useWriteQueue } from '@/state/writeQueue';
import { RootNavigator } from '@/navigation/RootNavigator';
import { LoginScreen } from '@/screens/LoginScreen';
import { LockScreen } from '@/screens/LockScreen';
import { linking } from '@/navigation/linking';
import { OfflineBanner } from '@/components/OfflineBanner';
import { extractDeepLink } from '@/services/push';
import type { RootStackParamList } from '@/navigation/types';

function Gate() {
  const { palette } = useTheme();
  const status = useSession((s) => s.status);
  const locked = useSession((s) => s.locked);
  const restore = useSession((s) => s.restore);
  const navRef = useRef<NavigationContainerRef<RootStackParamList>>(null);

  useEffect(() => {
    void restore();
    // Load any submissions queued in a previous session and start draining.
    void useWriteQueue.getState().hydrate();
  }, [restore]);

  // Re-try push registration whenever the app is authed + unlocked (covers
  // relaunch/biometric-unlock and permission/FCM that became available later).
  useEffect(() => {
    if (status === 'authed' && !locked) {
      void useSession.getState().ensurePushRegistered();
    }
  }, [status, locked]);

  // Route a notification tap to the Approvals tab (then detail when matched).
  useEffect(() => {
    const sub = Notifications.addNotificationResponseReceivedListener((response) => {
      const link = extractDeepLink(response);
      if (link && navRef.current) {
        navRef.current.navigate('Tabs', { screen: 'Approvals' } as never);
      }
    });
    return () => sub.remove();
  }, []);

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
