/**
 * OfflineBanner — slim bar shown app-wide while offline (ui-ux-pro-max
 * offline-support). Pinned just above the bottom tab bar (avoids fighting each
 * screen's top safe-area), and surfaces the queued-submission count so the user
 * knows work is saved and will send on reconnect. Mounted once over the nav.
 */
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useConnectivity } from '@/services/connectivity';
import { selectPendingCount, useWriteQueue } from '@/state/writeQueue';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { T } from './ui';

const TAB_BAR_APPROX = 56;

export function OfflineBanner() {
  const online = useConnectivity((s) => s.online);
  const pending = useWriteQueue(selectPendingCount);
  const insets = useSafeAreaInsets();
  const { palette } = useTheme();
  const { t } = useI18n();
  if (online) return null;
  return (
    <View
      pointerEvents="none"
      style={[
        styles.bar,
        { bottom: insets.bottom + TAB_BAR_APPROX + spacing.sm },
      ]}
    >
      <View style={[styles.pill, { backgroundColor: palette.warningSoft, borderColor: palette.warning }]}>
        <Ionicons name="cloud-offline-outline" size={15} color={palette.warning} />
        <T variant="caption" color={palette.warning} style={{ marginStart: spacing.sm }}>
          {t('offline.banner')}
          {pending ? ` · ${pending}` : ''}
        </T>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  bar: { position: 'absolute', left: 0, right: 0, alignItems: 'center' },
  pill: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderRadius: 999,
    paddingHorizontal: spacing.md,
    paddingVertical: 6,
  },
});
