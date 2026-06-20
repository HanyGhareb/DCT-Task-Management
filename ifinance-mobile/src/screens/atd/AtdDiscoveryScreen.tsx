/**
 * AtdDiscoveryScreen — OTBI subject-area discovery: list discovered subject
 * areas (status + folder/column counts), trigger a (re)discovery scrape, and
 * view discovery run history. (The deep column-picker / AI analysis builder
 * stays on the web app — it is inherently a wide desktop interaction.)
 */
import React, { useState } from 'react';
import { Alert, Modal, Pressable, StyleSheet, View } from 'react-native';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { useInfiniteQuery, useQuery } from '@tanstack/react-query';
import { Ionicons } from '@expo/vector-icons';
import {
  getAtdSubjectAreas,
  getAtdDiscoveryRuns,
  type AtdSubjectArea,
  type AtdDiscoveryRun,
} from '@/api/atd';
import { useQueuedMutation } from '@/hooks/useQueuedMutation';
import type { ApiError } from '@/api/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Badge, Button, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { TextField } from '@/components/form';
import { formatDateTime, formatDuration } from '@/utils/format';
import { atdStatusColors } from './atdStatus';

const PAGE = 30;

export function AtdDiscoveryScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const insets = useSafeAreaInsets();
  const [tab, setTab] = useState<'areas' | 'history'>('areas');
  const [promptOpen, setPromptOpen] = useState(false);
  const [saName, setSaName] = useState('');

  const areasQ = useQuery({ queryKey: ['atd', 'subjectAreas'], queryFn: getAtdSubjectAreas });
  const histQ = useInfiniteQuery({
    queryKey: ['atd', 'discoveryRuns'],
    queryFn: ({ pageParam }) => getAtdDiscoveryRuns(pageParam, PAGE),
    initialPageParam: 0,
    getNextPageParam: (last, all) => (last.length === PAGE ? all.length * PAGE : undefined),
  });
  const runs: AtdDiscoveryRun[] = histQ.data?.pages.flat() ?? [];

  const discover = useQueuedMutation<{ subjectArea: string }>({
    module: 'atd',
    requireOnline: true,
    path: () => '/subject-areas/discover',
    body: (v) => ({ subjectArea: v.subjectArea }),
    label: (v) => `ATD discover · ${v.subjectArea}`,
    invalidateKeys: () => [['atd', 'subjectAreas'], ['atd', 'discoveryRuns'], ['atd', 'dashboard']],
  });

  const fire = (subjectArea: string) =>
    discover.mutate(
      { subjectArea },
      {
        onSuccess: () => { void areasQ.refetch(); Alert.alert(t('atd.discovery'), t('atd.discoverQueued')); },
        onError: (e: ApiError) => Alert.alert(t('atd.discovery'), e.status === 0 ? t('queue.offline') : e.message),
      },
    );

  const rediscover = (sa: AtdSubjectArea) =>
    Alert.alert(sa.subjectArea, t('atd.rediscover') + '?', [
      { text: t('common.cancel'), style: 'cancel' },
      { text: t('atd.rediscover'), onPress: () => fire(sa.subjectArea) },
    ]);

  const submitPrompt = () => {
    const name = saName.trim();
    if (!name) return;
    setPromptOpen(false);
    setSaName('');
    fire(name);
  };

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={t('atd.discovery')}
        right={<Button label={t('atd.discover')} icon="add" onPress={() => setPromptOpen(true)} />}
      />

      <View style={styles.segWrap}>
        {(['areas', 'history'] as const).map((k) => {
          const on = tab === k;
          return (
            <Pressable
              key={k}
              onPress={() => setTab(k)}
              style={[styles.seg, { borderColor: palette.border, backgroundColor: on ? palette.brand : palette.surface }]}
            >
              <T variant="label" color={on ? '#fff' : palette.text}>
                {k === 'areas' ? t('atd.subjectAreas') : t('atd.discoveryRuns')}
              </T>
            </Pressable>
          );
        })}
      </View>

      {tab === 'areas' ? (
        areasQ.isLoading && !areasQ.data ? (
          <SkeletonList rows={4} />
        ) : (
          <FlashList<AtdSubjectArea>
            data={areasQ.data ?? []}
            keyExtractor={(s: AtdSubjectArea) => s.subjectArea}
            estimatedItemSize={84}
            refreshing={areasQ.isRefetching}
            onRefresh={() => void areasQ.refetch()}
            contentContainerStyle={{ padding: spacing.lg }}
            ListEmptyComponent={<EmptyState icon="albums-outline" title={t('atd.emptySubjectAreas')} />}
            renderItem={({ item }: { item: AtdSubjectArea }) => {
              const c = atdStatusColors(palette, item.status);
              return (
                <Pressable
                  onPress={() => rediscover(item)}
                  style={({ pressed }) => [styles.row, { backgroundColor: pressed ? palette.surfaceAlt : palette.surface, borderColor: palette.border }]}
                >
                  <View style={styles.rowTop}>
                    <T variant="title" numberOfLines={2} style={{ flex: 1 }}>{item.subjectArea}</T>
                    <Badge label={item.status} color={c.fg} bg={c.bg} />
                  </View>
                  <T variant="caption" color={palette.textMuted} style={{ marginTop: 4 }} tabular>
                    {item.folderCount} {t('atd.folders')} · {item.columnCount} {t('atd.columns')}
                    {item.scrapedAt ? ` · ${formatDateTime(item.scrapedAt)}` : ''}
                  </T>
                  {item.message ? (
                    <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ marginTop: 2 }}>{item.message}</T>
                  ) : null}
                </Pressable>
              );
            }}
          />
        )
      ) : histQ.isLoading && !runs.length ? (
        <SkeletonList rows={5} />
      ) : (
        <FlashList<AtdDiscoveryRun>
          data={runs}
          keyExtractor={(r: AtdDiscoveryRun) => String(r.runId)}
          estimatedItemSize={76}
          refreshing={histQ.isRefetching}
          onRefresh={() => void histQ.refetch()}
          onEndReachedThreshold={0.4}
          onEndReached={() => { if (histQ.hasNextPage && !histQ.isFetchingNextPage) void histQ.fetchNextPage(); }}
          contentContainerStyle={{ padding: spacing.lg }}
          ListEmptyComponent={<EmptyState icon="time-outline" title={t('atd.emptyRuns')} />}
          renderItem={({ item }: { item: AtdDiscoveryRun }) => {
            const c = atdStatusColors(palette, item.status);
            return (
              <View style={[styles.row, { backgroundColor: palette.surface, borderColor: palette.border }]}>
                <View style={styles.rowTop}>
                  <T variant="title" numberOfLines={2} style={{ flex: 1 }}>{item.subjectArea}</T>
                  <Badge label={item.status} color={c.fg} bg={c.bg} />
                </View>
                <T variant="caption" color={palette.textMuted} style={{ marginTop: 4 }} tabular>
                  {formatDateTime(item.started)} · {item.durationSec != null ? formatDuration(item.durationSec) : '—'} · {item.columnCount} {t('atd.columns')}
                </T>
                {item.message ? (
                  <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ marginTop: 2 }}>{item.message}</T>
                ) : null}
              </View>
            );
          }}
        />
      )}

      {/* New-discovery prompt */}
      <Modal visible={promptOpen} transparent animationType="fade" onRequestClose={() => setPromptOpen(false)}>
        <Pressable style={styles.backdrop} onPress={() => setPromptOpen(false)}>
          <Pressable style={[styles.promptBox, { backgroundColor: palette.surface, marginBottom: insets.bottom }]} onPress={(e) => e.stopPropagation()}>
            <T variant="title">{t('atd.discover')}</T>
            <TextField label={t('atd.discoverPrompt')} value={saName} onChangeText={setSaName} autoCapitalize="characters" />
            <View style={styles.promptActions}>
              <Button label={t('common.cancel')} variant="ghost" onPress={() => setPromptOpen(false)} />
              <Button label={t('atd.discover')} loading={discover.isPending} onPress={submitPrompt} />
            </View>
          </Pressable>
        </Pressable>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  segWrap: { flexDirection: 'row', gap: spacing.sm, paddingHorizontal: spacing.lg, paddingTop: spacing.sm },
  seg: { flex: 1, alignItems: 'center', paddingVertical: spacing.sm, borderRadius: 10, borderWidth: 1 },
  row: { borderWidth: 1, borderRadius: 12, padding: spacing.md, marginBottom: spacing.md },
  rowTop: { flexDirection: 'row', alignItems: 'flex-start', justifyContent: 'space-between', gap: spacing.sm },
  backdrop: { flex: 1, backgroundColor: 'rgba(0,0,0,0.45)', justifyContent: 'center', padding: spacing.xl },
  promptBox: { borderRadius: 16, padding: spacing.lg },
  promptActions: { flexDirection: 'row', justifyContent: 'flex-end', gap: spacing.sm, marginTop: spacing.lg },
});
