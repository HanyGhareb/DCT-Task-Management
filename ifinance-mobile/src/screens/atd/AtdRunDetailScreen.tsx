/**
 * AtdRunDetailScreen — full run-log row: status, track, timing, rows, message,
 * CSV checksum. Reached from the dashboard / runs list.
 */
import React from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useNavigation, useRoute, type RouteProp } from '@react-navigation/native';
import { useQuery } from '@tanstack/react-query';
import { getAtdRun } from '@/api/atd';
import type { RootStackParamList } from '@/navigation/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Badge, Button, Card, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { formatDateTime, formatDuration } from '@/utils/format';
import { atdStatusColors } from './atdStatus';

export function AtdRunDetailScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const nav = useNavigation();
  const { params } = useRoute<RouteProp<RootStackParamList, 'AtdRunDetail'>>();

  const { data, isLoading } = useQuery({
    queryKey: ['atd', 'run', params.runId],
    queryFn: () => getAtdRun(params.runId),
  });

  const c = data ? atdStatusColors(palette, data.status) : { fg: palette.textMuted, bg: palette.surfaceAlt };

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={t('atd.runDetail')}
        right={<Button label={t('common.back')} variant="ghost" onPress={() => nav.goBack()} />}
      />
      {isLoading && !data ? (
        <SkeletonList rows={4} />
      ) : !data ? null : (
        <ScrollView contentContainerStyle={{ padding: spacing.lg }}>
          <Card>
            <View style={styles.headRow}>
              <T variant="h2" numberOfLines={2} style={{ flex: 1 }}>
                {data.jobName}
              </T>
              <Badge label={data.status} color={c.fg} bg={c.bg} />
            </View>
            <Row label={t('atd.track')} value={data.track} />
            <Row label={t('atd.started')} value={formatDateTime(data.started)} />
            <Row label={t('atd.finished')} value={data.finished ? formatDateTime(data.finished) : '—'} />
            <Row label={t('atd.duration')} value={formatDuration(data.durationSec)} />
            <Row label={t('atd.rows')} value={data.rowCount.toLocaleString('en-US')} />
            {data.message ? <Row label={t('atd.message')} value={data.message} /> : null}
            {data.csvChecksum ? <Row label={t('atd.checksum')} value={data.csvChecksum} mono /> : null}
          </Card>
        </ScrollView>
      )}
    </SafeAreaView>
  );
}

function Row({ label, value, mono }: { label: string; value: string; mono?: boolean }) {
  const { palette } = useTheme();
  return (
    <View style={[styles.row, { borderTopColor: palette.border }]}>
      <T variant="label" color={palette.textMuted}>
        {label}
      </T>
      <T variant="body" tabular={!mono} numberOfLines={mono ? 1 : undefined} style={mono ? styles.mono : { flex: 1, textAlign: 'right' }}>
        {value}
      </T>
    </View>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  headRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: spacing.sm, marginBottom: spacing.sm },
  row: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: spacing.md, paddingVertical: spacing.sm, borderTopWidth: 1 },
  mono: { flex: 1, textAlign: 'right', fontSize: 11 },
});
