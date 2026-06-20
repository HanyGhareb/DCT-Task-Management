/**
 * OutboxScreen — review pending/failed offline submissions; retry or discard.
 * Gives queued writes a visible, trustworthy home (ui-ux-pro-max: offline-support,
 * error-recovery, undo-support).
 */
import React from 'react';
import { Alert, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { Ionicons } from '@expo/vector-icons';
import { selectFailedCount, useWriteQueue, type QueueItem } from '@/state/writeQueue';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Badge, Button, EmptyState, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { formatDateTime } from '@/utils/format';

export function OutboxScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const items = useWriteQueue((s) => s.items);
  const failed = useWriteQueue(selectFailedCount);
  const retry = useWriteQueue((s) => s.retry);
  const discard = useWriteQueue((s) => s.discard);
  const clearFailed = useWriteQueue((s) => s.clearFailed);

  const confirmDiscard = (item: QueueItem) =>
    Alert.alert(t('outbox.discard'), item.label, [
      { text: t('common.cancel'), style: 'cancel' },
      { text: t('outbox.discard'), style: 'destructive', onPress: () => discard(item.id) },
    ]);

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={t('outbox.title')}
        count={items.length}
        right={
          failed ? (
            <Button label={t('outbox.clearFailed')} variant="ghost" onPress={clearFailed} />
          ) : undefined
        }
      />
      <FlashList<QueueItem>
        data={items}
        keyExtractor={(i: QueueItem) => i.id}
        estimatedItemSize={96}
        contentContainerStyle={{ padding: spacing.lg }}
        ListEmptyComponent={
          <EmptyState icon="cloud-done-outline" title={t('outbox.empty')} subtitle={t('outbox.emptySub')} />
        }
        renderItem={({ item }: { item: QueueItem }) => {
          const isFailed = item.status === 'failed';
          return (
            <View style={[styles.row, { backgroundColor: palette.surface, borderColor: palette.border }]}>
              <View style={styles.rowTop}>
                <T variant="title" numberOfLines={2} style={{ flex: 1 }}>
                  {item.label}
                </T>
                <Badge
                  label={isFailed ? t('outbox.failed') : t('outbox.pending')}
                  color={isFailed ? palette.danger : palette.warning}
                  bg={isFailed ? palette.dangerSoft : palette.warningSoft}
                />
              </View>
              <T variant="caption" color={palette.textMuted} style={{ marginTop: 2 }}>
                {item.method} {item.module ? `/${item.module}` : ''}{item.path} · {formatDateTime(new Date(item.createdAt).toISOString())}
              </T>
              {isFailed && item.error ? (
                <View style={[styles.errBox, { backgroundColor: palette.dangerSoft }]}>
                  <Ionicons name="alert-circle" size={14} color={palette.danger} />
                  <T variant="caption" color={palette.danger} style={{ marginStart: 6, flex: 1 }}>
                    {item.error}
                  </T>
                </View>
              ) : null}
              <View style={styles.actions}>
                {isFailed ? (
                  <Button label={t('outbox.retry')} variant="secondary" icon="refresh" onPress={() => void retry(item.id)} style={styles.actionBtn} />
                ) : null}
                <Button label={t('outbox.discard')} variant="ghost" icon="trash" onPress={() => confirmDiscard(item)} style={styles.actionBtn} />
              </View>
            </View>
          );
        }}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  row: { borderWidth: 1, borderRadius: 12, padding: spacing.md, marginBottom: spacing.md },
  rowTop: { flexDirection: 'row', alignItems: 'flex-start', justifyContent: 'space-between', gap: spacing.sm },
  errBox: { flexDirection: 'row', alignItems: 'center', borderRadius: 8, padding: spacing.sm, marginTop: spacing.sm },
  actions: { flexDirection: 'row', justifyContent: 'flex-end', marginTop: spacing.sm, gap: spacing.sm },
  actionBtn: { paddingHorizontal: spacing.md, minHeight: 40 },
});
