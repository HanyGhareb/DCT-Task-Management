/**
 * AtdRunsScreen — paged run-log (infinite scroll). Tap a row → run detail.
 */
import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { FlashList } from '@shopify/flash-list';
import { useInfiniteQuery } from '@tanstack/react-query';
import { Ionicons } from '@expo/vector-icons';
import { getAtdRuns, type AtdRun } from '@/api/atd';
import type { RootStackParamList } from '@/navigation/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Badge, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { formatDateTime, formatDuration } from '@/utils/format';
import { atdStatusColors } from './atdStatus';

const PAGE = 30;

export function AtdRunsScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();

  const { data, isLoading, isRefetching, refetch, fetchNextPage, hasNextPage, isFetchingNextPage } =
    useInfiniteQuery({
      queryKey: ['atd', 'runs'],
      queryFn: ({ pageParam }) => getAtdRuns(pageParam, PAGE),
      initialPageParam: 0,
      getNextPageParam: (lastPage, all) => (lastPage.length === PAGE ? all.length * PAGE : undefined),
    });

  const runs: AtdRun[] = data?.pages.flat() ?? [];

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader title={t('atd.runs')} />
      {isLoading && !runs.length ? (
        <SkeletonList rows={6} />
      ) : (
        <FlashList<AtdRun>
          data={runs}
          keyExtractor={(r: AtdRun) => String(r.runId)}
          estimatedItemSize={84}
          refreshing={isRefetching}
          onRefresh={() => void refetch()}
          onEndReachedThreshold={0.4}
          onEndReached={() => {
            if (hasNextPage && !isFetchingNextPage) void fetchNextPage();
          }}
          contentContainerStyle={{ padding: spacing.lg }}
          ListEmptyComponent={<EmptyState icon="time-outline" title={t('atd.emptyRuns')} />}
          renderItem={({ item }: { item: AtdRun }) => {
            const c = atdStatusColors(palette, item.status);
            return (
              <Pressable
                onPress={() => nav.navigate('AtdRunDetail', { runId: item.runId })}
                style={({ pressed }) => [
                  styles.row,
                  { backgroundColor: pressed ? palette.surfaceAlt : palette.surface, borderColor: palette.border },
                ]}
              >
                <View style={styles.rowTop}>
                  <T variant="title" numberOfLines={1} style={{ flex: 1 }}>
                    {item.jobName}
                  </T>
                  {item.warn === 'Y' ? (
                    <Ionicons name="warning" size={15} color={palette.warning} style={{ marginEnd: 6 }} />
                  ) : null}
                  <Badge label={item.status} color={c.fg} bg={c.bg} />
                </View>
                <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ marginTop: 4 }} tabular>
                  {formatDateTime(item.started)} · {formatDuration(item.durationSec)} · {item.rowCount.toLocaleString('en-US')} {t('atd.rows')}
                </T>
                {item.message ? (
                  <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ marginTop: 2 }}>
                    {item.message}
                  </T>
                ) : null}
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
});
