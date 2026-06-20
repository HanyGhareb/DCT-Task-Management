/**
 * AtdQueueScreen — live queue view: counts (ready/running/done/failed) + the
 * jobs currently READY/CLAIMED, with a Reap-stale action. Derived from
 * /dashboard (counts) + /jobs (run_status); no separate queue endpoint.
 */
import React from 'react';
import { Alert, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { useQuery } from '@tanstack/react-query';
import { getAtdDashboard, getAtdJobs, type AtdJob } from '@/api/atd';
import { config } from '@/config';
import { useQueuedMutation } from '@/hooks/useQueuedMutation';
import type { ApiError } from '@/api/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Badge, Button, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { atdStatusColors } from './atdStatus';

export function AtdQueueScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();

  const dash = useQuery({ queryKey: ['atd', 'dashboard'], queryFn: getAtdDashboard, refetchInterval: config.notifPollMs });
  const jobsQ = useQuery({ queryKey: ['atd', 'jobs'], queryFn: getAtdJobs, refetchInterval: config.notifPollMs });

  const queued = (jobsQ.data ?? []).filter((j: AtdJob) => j.runStatus === 'READY' || j.runStatus === 'CLAIMED');
  const q = dash.data?.queue;

  const reap = useQueuedMutation<void>({
    module: 'atd',
    requireOnline: true,
    path: () => '/reap',
    body: () => ({}),
    label: () => 'ATD reap stale',
    invalidateKeys: () => [['atd', 'jobs'], ['atd', 'dashboard']],
  });

  const doReap = () =>
    Alert.alert(t('atd.queue'), t('atd.confirmReap'), [
      { text: t('common.cancel'), style: 'cancel' },
      {
        text: t('atd.reap'),
        onPress: () =>
          reap.mutate(undefined, {
            onSuccess: () => { void dash.refetch(); void jobsQ.refetch(); Alert.alert(t('atd.queue'), t('atd.done2')); },
            onError: (e: ApiError) => Alert.alert(t('atd.queue'), e.status === 0 ? t('queue.offline') : e.message),
          }),
      },
    ]);

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader title={t('atd.queue')} right={<Button label={t('atd.reap')} variant="ghost" icon="trash-bin" onPress={doReap} />} />
      {jobsQ.isLoading && !jobsQ.data ? (
        <SkeletonList rows={4} />
      ) : (
        <FlashList<AtdJob>
          data={queued}
          keyExtractor={(j: AtdJob) => j.jobName}
          estimatedItemSize={72}
          refreshing={jobsQ.isRefetching}
          onRefresh={() => { void dash.refetch(); void jobsQ.refetch(); }}
          contentContainerStyle={{ padding: spacing.lg }}
          ListHeaderComponent={
            <View style={styles.countRow}>
              <Count label={t('atd.ready')} value={q?.ready ?? 0} color={palette.info} palette={palette} />
              <Count label={t('atd.claimed')} value={q?.claimed ?? 0} color={palette.warning} palette={palette} />
              <Count label={t('atd.done')} value={q?.done ?? 0} color={palette.success} palette={palette} />
              <Count label={t('atd.failed')} value={q?.failed ?? 0} color={palette.danger} palette={palette} />
            </View>
          }
          ListEmptyComponent={<EmptyState icon="layers-outline" title={t('atd.queueEmpty')} />}
          renderItem={({ item }: { item: AtdJob }) => {
            const c = atdStatusColors(palette, item.runStatus);
            return (
              <View style={[styles.row, { backgroundColor: palette.surface, borderColor: palette.border }]}>
                <T variant="title" numberOfLines={1} style={{ flex: 1 }}>
                  {item.jobName}
                </T>
                <T variant="caption" color={palette.textMuted} tabular style={{ marginEnd: spacing.sm }}>
                  #{item.runOrder}
                </T>
                <Badge label={item.runStatus} color={c.fg} bg={c.bg} />
              </View>
            );
          }}
        />
      )}
    </SafeAreaView>
  );
}

function Count({ label, value, color, palette }: { label: string; value: number; color: string; palette: any }) {
  return (
    <View style={[styles.count, { backgroundColor: palette.surface, borderColor: palette.border }]}>
      <T variant="h2" color={color} tabular>{value}</T>
      <T variant="caption" color={palette.textMuted}>{label}</T>
    </View>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  countRow: { flexDirection: 'row', gap: spacing.sm, marginBottom: spacing.md },
  count: { flex: 1, borderWidth: 1, borderRadius: 12, padding: spacing.sm, alignItems: 'center' },
  row: { flexDirection: 'row', alignItems: 'center', borderWidth: 1, borderRadius: 12, padding: spacing.md, marginBottom: spacing.sm, gap: spacing.sm },
});
