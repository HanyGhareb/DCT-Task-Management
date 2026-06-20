/**
 * AtdJobsScreen — configured loader jobs. Tap a job → Enqueue run / Reset.
 * Header overflow → Enqueue all / Reap stale. All writes use `useQueuedMutation`
 * with `requireOnline: true` (a trigger must not silently queue offline).
 */
import React from 'react';
import { Alert, Pressable, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { Ionicons } from '@expo/vector-icons';
import { getAtdJobs, type AtdJob } from '@/api/atd';
import { useQuery } from '@tanstack/react-query';
import { useQueuedMutation } from '@/hooks/useQueuedMutation';
import type { ApiError } from '@/api/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Badge, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { formatDateTime, formatDuration } from '@/utils/format';
import { atdStatusColors } from './atdStatus';

type Action = { kind: 'enqueue' | 'reset' | 'enqueueAll' | 'reap'; jobName?: string };

const INVALIDATE = [['atd', 'jobs'], ['atd', 'dashboard'], ['atd', 'runs']];

export function AtdJobsScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();

  const { data, isLoading, isRefetching, refetch } = useQuery({
    queryKey: ['atd', 'jobs'],
    queryFn: getAtdJobs,
  });

  const action = useQueuedMutation<Action>({
    module: 'atd',
    requireOnline: true,
    path: (v) =>
      v.kind === 'enqueue'
        ? `/jobs/${encodeURIComponent(v.jobName!)}/enqueue`
        : v.kind === 'reset'
          ? `/jobs/${encodeURIComponent(v.jobName!)}/reset`
          : v.kind === 'enqueueAll'
            ? '/enqueue'
            : '/reap',
    body: () => ({}),
    label: (v) => `ATD ${v.kind}${v.jobName ? ` · ${v.jobName}` : ''}`,
    invalidateKeys: () => INVALIDATE,
  });

  const run = (v: Action) =>
    action.mutate(v, {
      onSuccess: () => {
        void refetch();
        Alert.alert(t('atd.title'), v.kind === 'enqueue' || v.kind === 'enqueueAll' ? t('atd.enqueued') : t('atd.done2'));
      },
      onError: (e: ApiError) =>
        Alert.alert(t('atd.title'), e.status === 0 ? t('queue.offline') : e.message),
    });

  const openJob = (j: AtdJob) =>
    Alert.alert(j.jobName, `${j.envName} → ${j.targetName}`, [
      { text: t('atd.enqueue'), onPress: () => run({ kind: 'enqueue', jobName: j.jobName }) },
      { text: t('atd.reset'), onPress: () => run({ kind: 'reset', jobName: j.jobName }) },
      { text: t('common.cancel'), style: 'cancel' },
    ]);

  const openOverflow = () =>
    Alert.alert(t('atd.jobs'), undefined, [
      { text: t('atd.enqueueAll'), onPress: () => Alert.alert(t('atd.title'), t('atd.confirmEnqueueAll'), [
        { text: t('common.cancel'), style: 'cancel' },
        { text: t('atd.enqueueAll'), onPress: () => run({ kind: 'enqueueAll' }) },
      ]) },
      { text: t('atd.reap'), onPress: () => Alert.alert(t('atd.title'), t('atd.confirmReap'), [
        { text: t('common.cancel'), style: 'cancel' },
        { text: t('atd.reap'), onPress: () => run({ kind: 'reap' }) },
      ]) },
      { text: t('common.cancel'), style: 'cancel' },
    ]);

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={t('atd.jobs')}
        count={data?.length}
        right={
          <Pressable onPress={openOverflow} hitSlop={8} accessibilityLabel={t('atd.jobs')}>
            <Ionicons name="ellipsis-horizontal" size={22} color={palette.text} />
          </Pressable>
        }
      />
      {isLoading && !data ? (
        <SkeletonList rows={5} />
      ) : (
        <FlashList<AtdJob>
          data={data ?? []}
          keyExtractor={(j: AtdJob) => j.jobName}
          estimatedItemSize={96}
          refreshing={isRefetching}
          onRefresh={() => void refetch()}
          contentContainerStyle={{ padding: spacing.lg }}
          ListEmptyComponent={<EmptyState icon="construct-outline" title={t('atd.emptyJobs')} />}
          renderItem={({ item }: { item: AtdJob }) => {
            const c = atdStatusColors(palette, item.lastRunStatus || item.runStatus);
            return (
              <Pressable
                onPress={() => openJob(item)}
                style={({ pressed }) => [
                  styles.row,
                  { backgroundColor: pressed ? palette.surfaceAlt : palette.surface, borderColor: palette.border },
                ]}
              >
                <View style={styles.rowTop}>
                  <T variant="title" numberOfLines={1} style={{ flex: 1 }}>
                    {item.jobName}
                  </T>
                  <Badge
                    label={item.prepared === 'Y' ? t('atd.prepared') : t('atd.notPrepared')}
                    color={item.prepared === 'Y' ? palette.success : palette.textMuted}
                    bg={item.prepared === 'Y' ? palette.successSoft : palette.surfaceAlt}
                  />
                </View>
                <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ marginTop: 2 }}>
                  {item.envName} → {item.targetName} · {item.loadMode}
                </T>
                <View style={styles.rowBottom}>
                  {item.lastRunStatus ? (
                    <Badge label={item.lastRunStatus} color={c.fg} bg={c.bg} />
                  ) : null}
                  <T variant="caption" color={palette.textMuted} tabular>
                    {item.lastFinished ? `${t('atd.lastRun')}: ${formatDateTime(item.lastFinished)}` : ''}
                    {item.lastDurationSec != null ? ` · ${formatDuration(item.lastDurationSec)}` : ''}
                  </T>
                </View>
              </Pressable>
            );
          }}
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  row: { borderWidth: 1, borderRadius: 12, padding: spacing.md, marginBottom: spacing.md },
  rowTop: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: spacing.sm },
  rowBottom: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginTop: spacing.sm, gap: spacing.sm },
});
