/**
 * LockScreen — biometric gate shown on relaunch when a session exists.
 * Auto-prompts once; on success unlocks, on cancel offers retry or sign out.
 */
import React, { useCallback, useEffect, useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { authenticate } from '@/services/biometric';
import { useSession } from '@/state/session';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { Button, T } from '@/components/ui';
import { radius, spacing } from '@/theme/tokens';

export function LockScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const unlock = useSession((s) => s.unlock);
  const signOut = useSession((s) => s.signOut);
  const [tried, setTried] = useState(false);

  const prompt = useCallback(async () => {
    const ok = await authenticate(t('login.biometricPrompt'));
    setTried(true);
    if (ok) unlock();
  }, [t, unlock]);

  useEffect(() => {
    void prompt();
  }, [prompt]);

  return (
    <SafeAreaView style={[styles.safe, { backgroundColor: palette.chromeBg }]}>
      <View style={styles.center}>
        <View style={[styles.icon, { backgroundColor: palette.brand }]}>
          <Ionicons name="finger-print" size={40} color="#fff" />
        </View>
        <T variant="h2" color="#fff" style={{ marginTop: spacing.lg }}>
          {t('suite.name')}
        </T>
        <T variant="body" color={palette.chromeText} style={{ marginTop: 4, textAlign: 'center' }}>
          {t('login.biometricPrompt')}
        </T>
        <View style={{ marginTop: spacing.xl, width: '80%' }}>
          <Button label={t('login.biometric')} icon="finger-print" onPress={prompt} />
          {tried ? (
            <Button
              label={t('profile.logout')}
              variant="ghost"
              onPress={signOut}
              style={{ marginTop: spacing.sm }}
            />
          ) : null}
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: spacing.xl },
  icon: {
    width: 80,
    height: 80,
    borderRadius: radius.lg,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
