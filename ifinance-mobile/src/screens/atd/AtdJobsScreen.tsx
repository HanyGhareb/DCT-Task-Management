/**
 * AtdJobsScreen — configured loader jobs with FULL management (parity with the
 * web Jobs page): enqueue, reset, enable/disable, re-map, rebuild, delete; plus
 * header enqueue-all / reap. Actions live in a bottom-sheet (Android Alert caps
 * at 3 buttons). All writes use `useQueuedMutation` with `requireOnline: true`
 * (a trigger/config change must not silently queue offline).
 */
import React, { useState } from 'react';
import { Alert, Modal, Pressable, StyleSheet, View } from 'react-native';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { Ionicons } from '@expo/vector-icons';
import { getAtdJobs, type AtdJob } from '@/api/atd';
import { useQuery } from '@tanstack/react-query';
import { useQueuedMutation } from '@/hooks/useQueuedMutation';
import type { ApiError } from '@/api/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing, type ThemePalette } from '@/theme/tokens';
import { Badge, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { formatDateTime, formatDuration } from '@/utils/format';
import { atdStatusColors } from './atdStatus';

type Kind = 'enqueue' | 'reset' | 'enable' | 'disable' | 'remap' | 'rebuild' | 'delete' | 'enqueueAll' | 'reap';
type Action = { kind: Kind; jobName?: string };

const INVALIDATE = [['atd', 'jobs'], ['atd', 'dashboard'], ['atd', 'runs']];

export function AtdJobsScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const [sheetJob, setSheetJob] = useState<AtdJob | null>(null);

  const { data, isLoading, isRefetching, refetch } = useQuery({
    queryKey: ['atd', 'jobs'],
    queryFn: getAtdJobs,
  });

  const enc = (n: string) => encodeURIComponent(n);
  const action = useQueuedMutation<Action>({
    module: 'atd',
    requireOnline: true,
    method: (v) => (v.kind === 'enable' || v.kind === 'disable' ? 'PUT' : v.kind === 'delete' ? 'DELETE' : 'POST'),
    path: (v) => {
      switch (v.kind) {
        case 'enqueue': return `/jobs/${enc(v.jobName!)}/enqueue`;
        case 'reset': return `/jobs/${enc(v.jobName!)}/reset`;
        case 'enable':
        case 'disable':
        case 'delete': return `/jobs/${enc(v.jobName!)}`;
        case 'remap':
        case 'rebuild': return `/jobs/${enc(v.jobName!)}/reprepare`;
        case 'enqueueAll': return '/enqueue';
        case 'reap': return '/reap';
      }
    },
    body: (v) =>
      v.kind === 'enable' ? { enabled: 'Y' } : v.kind === 'disable' ? { enabled: 'N' } : v.kind === 'rebuild' ? { rebuild: 'Y' } : {},
    label: (v) => `ATD ${v.kind}${v.jobName ? ` · ${v.jobName}` : ''}`,
    invalidateKeys: () => INVALIDATE,
  });

  const successMsg = (k: Kind): string =>
    k === 'enqueue' || k === 'enqueueAll' ? t('atd.enqueued')
      : k === 'enable' || k === 'disable' ? t('atd.updated')
        : k === 'remap' ? t('atd.remapped')
          : k === 'rebuild' ? t('atd.rebuilt')
            : k === 'delete' ? t('atd.deleted')
              : t('atd.done2');

  const run = (v: Action) => {
    setSheetJob(null);
    action.mutate(v, {
      onSuccess: () => {
        void refetch();
        Alert.alert(t('atd.title'), successMsg(v.kind));
      },
      onError: (e: ApiError) => Alert.alert(t('atd.title'), e.status === 0 ? t('queue.offline') : e.message),
    });
  };

  // Destructive actions confirm first (2-button Alert is fine on all platforms).
  const confirm = (msg: string, label: string, v: Action) => {
    setSheetJob(null);
    Alert.alert(t('atd.title'), msg, [
      { text: t('common.cancel'), style: 'cancel' },
      { text: label, style: v.kind === 'delete' ? 'destructive' : 'default', onPress: () => run(v) },
    ]);
  };

  const openOverflow = () =>
    Alert.alert(t('atd.jobs'), undefined, [
      { text: t('atd.enqueueAll'), onPress: () => confirm(t('atd.confirmEnqueueAll'), t('atd.enqueueAll'), { kind: 'enqueueAll' }) },
      { text: t('atd.reap'), onPress: () => confirm(t('atd.confirmReap'), t('atd.reap'), { kind: 'reap' }) },
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
          estimatedItemSize={104}
          refreshing={isRefetching}
          onRefresh={() => void refetch()}
          contentContainerStyle={{ padding: spacing.lg }}
          ListEmptyComponent={<EmptyState icon="construct-outline" title={t('atd.emptyJobs')} />}
          renderItem={({ item }: { item: AtdJob }) => {
            const on = item.enabled === 'Y';
            const c = atdStatusColors(palette, item.lastRunStatus || item.runStatus);
            return (
              <Pressable
                onPress={() => setSheetJob(item)}
                style={({ pressed }) => [
                  styles.row,
                  { backgroundColor: pressed ? palette.surfaceAlt : palette.surface, borderColor: palette.border },
                ]}
              >
                <View style={styles.rowTop}>
                  <Ionicons name={on ? 'power' : 'power-outline'} size={16} color={on ? palette.success : palette.textMuted} />
                  <T variant="title" numberOfLines={1} style={{ flex: 1, marginStart: 6 }}>
                    {item.jobName}
                  </T>
                  <Badge
                    label={item.prepared === 'Y' ? t('atd.prepared') : t('atd.notPrepared')}
                    color={item.prepared === 'Y' ? palette.success : palette.textMuted}
                    bg={item.prepared === 'Y' ? palette.successSoft : palette.surfaceAlt}
                  />
                </View>
                <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ marginTop: 2 }}>
                  {on ? t('atd.enabled') : t('atd.disabled')} · {item.envName} → {item.targetName} · {item.loadMode}
                </T>
                <View style={styles.rowBottom}>
                  {item.lastRunStatus ? <Badge label={item.lastRunStatus} color={c.fg} bg={c.bg} /> : <View />}
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

      <JobActionsSheet
        job={sheetJob}
        palette={palette}
        t={t}
        onClose={() => setSheetJob(null)}
        onAction={(kind, job) => {
          if (kind === 'disable') return confirm(t('atd.confirmDisable', [job.jobName]), t('atd.disable'), { kind, jobName: job.jobName });
          if (kind === 'rebuild') return confirm(t('atd.confirmRebuild', [job.jobName]), t('atd.rebuild'), { kind, jobName: job.jobName });
          if (kind === 'delete') return confirm(t('atd.confirmDelete', [job.jobName]), t('atd.delete'), { kind, jobName: job.jobName });
          return run({ kind, jobName: job.jobName });
        }}
      />
    </SafeAreaView>
  );
}

function JobActionsSheet({
  job,
  palette,
  t,
  onClose,
  onAction,
}: {
  job: AtdJob | null;
  palette: ThemePalette;
  t: (k: any, a?: Array<string | number>) => string;
  onClose: () => void;
  onAction: (kind: Kind, job: AtdJob) => void;
}) {
  const insets = useSafeAreaInsets();
  if (!job) return null;
  const on = job.enabled === 'Y';
  const rows: Array<{ kind: Kind; label: string; icon: keyof typeof Ionicons.glyphMap; danger?: boolean }> = [
    { kind: 'enqueue', label: t('atd.enqueue'), icon: 'play' },
    { kind: 'reset', label: t('atd.reset'), icon: 'refresh' },
    on
      ? { kind: 'disable', label: t('atd.disable'), icon: 'power' }
      : { kind: 'enable', label: t('atd.enable'), icon: 'power' },
    { kind: 'remap', label: t('atd.remap'), icon: 'git-compare' },
    { kind: 'rebuild', label: t('atd.rebuild'), icon: 'build', danger: true },
    { kind: 'delete', label: t('atd.delete'), icon: 'trash', danger: true },
  ];
  return (
    <Modal visible transparent animationType="fade" onRequestClose={onClose}>
      <Pressable style={styles.backdrop} onPress={onClose}>
        <Pressable
          style={[styles.sheet, { backgroundColor: palette.surface, paddingBottom: insets.bottom + spacing.md }]}
          onPress={(e) => e.stopPropagation()}
        >
          <View style={[styles.sheetHandle, { backgroundColor: palette.border }]} />
          <T variant="title" numberOfLines={1} style={{ marginBottom: spacing.xs }}>
            {job.jobName}
          </T>
          <T variant="caption" color={palette.textMuted} style={{ marginBottom: spacing.sm }}>
            {t('atd.actions')}
          </T>
          {rows.map((r) => (
            <Pressable
              key={r.kind}
              onPress={() => onAction(r.kind, job)}
              style={({ pressed }) => [styles.sheetRow, pressed ? { backgroundColor: palette.surfaceAlt } : null]}
            >
              <Ionicons name={r.icon} size={20} color={r.danger ? palette.danger : palette.text} />
              <T variant="body" color={r.danger ? palette.danger : palette.text} style={{ marginStart: spacing.md }}>
                {r.label}
              </T>
            </Pressable>
          ))}
        </Pressable>
      </Pressable>
    </Modal>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  row: { borderWidth: 1, borderRadius: 12, padding: spacing.md, marginBottom: spacing.md },
  rowTop: { flexDirection: 'row', alignItems: 'center', gap: spacing.sm },
  rowBottom: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginTop: spacing.sm, gap: spacing.sm },
  backdrop: { flex: 1, backgroundColor: 'rgba(0,0,0,0.45)', justifyContent: 'flex-end' },
  sheet: { borderTopLeftRadius: 18, borderTopRightRadius: 18, paddingHorizontal: spacing.lg, paddingTop: spacing.sm },
  sheetHandle: { alignSelf: 'center', width: 40, height: 4, borderRadius: 2, marginBottom: spacing.md },
  sheetRow: { flexDirection: 'row', alignItems: 'center', paddingVertical: spacing.md, borderRadius: 10, paddingHorizontal: spacing.sm },
});
