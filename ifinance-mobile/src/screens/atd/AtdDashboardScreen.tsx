/**
 * AtdDashboardScreen — Analytics Loader landing (role-gated Analytics tab).
 * KPI cards (queue / 24h runs / success rate), tappable FAILED+WARNING alerts,
 * a recent-runs strip, and quick links to Jobs / Run history. Pull-to-refresh +
 * a light auto-poll while focused.
 */
import React from 'react';
import { RefreshControl, ScrollView, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { Ionicons } from '@expo/vector-icons';
import { getAtdDashboard, type AtdAlert, type AtdRecentRun } from '@/api/atd';
import { config } from '@/config';
import type { RootStackParamList } from '@/navigation/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { moduleColor, spacing } from '@/theme/tokens';
import { Badge, Card, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { formatDateTime } from '@/utils/format';
import { atdStatusColors } from './atdStatus';

const ATD = moduleColor('ATD');

export function AtdDashboardScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();

  const { data, isLoading, isRefetching, refetch } = useQuery({
    queryKey: ['atd', 'dashboard'],
    queryFn: getAtdDashboard,
    refetchInterval: config.notifPollMs,
  });

  const openRun = (runId: number) => nav.navigate('AtdRunDetail', { runId });

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader title={t('atd.title')} />
      {isLoading && !data ? (
        <SkeletonList rows={4} />
      ) : (
        <ScrollView
          contentContainerStyle={{ padding: spacing.lg, paddingBottom: spacing.xxl }}
          refreshControl={<RefreshControl refreshing={isRefetching} onRefresh={() => void refetch()} tintColor={ATD} />}
        >
          {/* KPI row */}
          <View style={styles.kpiRow}>
            <Stat
              label={t('atd.ready')}
              value={data?.queue.ready ?? 0}
              sub={`${data?.queue.claimed ?? 0} ${t('atd.claimed')}`}
              color={ATD}
            />
            <Stat
              label={t('atd.runs24h')}
              value={data?.runs24h ?? 0}
              sub={`${data?.success24h ?? 0} ${t('atd.done')}`}
              color={palette.info}
            />
            <Stat
              label={t('atd.successRate')}
              value={`${data?.successRate ?? 0}%`}
              sub={data?.queue.failed ? `${data.queue.failed} ${t('atd.failed')}` : ''}
              color={data && data.successRate >= 90 ? palette.success : palette.warning}
            />
          </View>

          {/* Quick links */}
          <View style={styles.linksRow}>
            <LinkCard icon="construct" label={t('atd.viewJobs')} onPress={() => nav.navigate('AtdJobs')} color={ATD} />
            <LinkCard icon="time" label={t('atd.viewRuns')} onPress={() => nav.navigate('AtdRuns')} color={palette.info} />
          </View>

          {/* Alerts */}
          <T variant="label" color={palette.textMuted} style={styles.sectionLabel}>
            {t('atd.alerts')}
          </T>
          {data && data.alerts.length ? (
            data.alerts.map((a: AtdAlert) => {
              const c = atdStatusColors(palette, a.kind);
              return (
                <Card key={a.runId} onPress={() => openRun(a.runId)} accentColor={c.fg}>
                  <View style={styles.alertTop}>
                    <T variant="title" numberOfLines={1} style={{ flex: 1 }}>
                      {a.jobName}
                    </T>
                    <Badge label={a.kind} color={c.fg} bg={c.bg} />
                  </View>
                  <T variant="caption" color={palette.textMuted} numberOfLines={2} style={{ marginTop: 4 }}>
                    {a.message}
                  </T>
                  <T variant="caption" color={palette.textMuted} style={{ marginTop: 2 }} tabular>
                    {formatDateTime(a.started)}
                  </T>
                </Card>
              );
            })
          ) : (
            <Card>
              <View style={styles.okRow}>
                <Ionicons name="checkmark-circle" size={18} color={palette.success} />
                <T variant="body" color={palette.textMuted} style={{ marginStart: spacing.sm }}>
                  {t('atd.noAlerts')}
                </T>
              </View>
            </Card>
          )}

          {/* Recent runs */}
          <T variant="label" color={palette.textMuted} style={styles.sectionLabel}>
            {t('atd.recent')}
          </T>
          {(data?.recent ?? []).map((r: AtdRecentRun) => {
            const c = atdStatusColors(palette, r.status);
            return (
              <Card key={r.runId} onPress={() => openRun(r.runId)}>
                <View style={styles.alertTop}>
                  <T variant="title" numberOfLines={1} style={{ flex: 1 }}>
                    {r.jobName}
                  </T>
                  <Badge label={r.status} color={c.fg} bg={c.bg} />
                </View>
                <T variant="caption" color={palette.textMuted} style={{ marginTop: 4 }} tabular>
                  {formatDateTime(r.finished || r.started)} · {r.rowCount.toLocaleString('en-US')} {t('atd.rows')}
                </T>
              </Card>
            );
          })}
        </ScrollView>
      )}
    </SafeAreaView>
  );
}

function Stat({ label, value, sub, color }: { label: string; value: string | number; sub?: string; color: string }) {
  const { palette } = useTheme();
  return (
    <View style={[styles.stat, { backgroundColor: palette.surface, borderColor: palette.border }]}>
      <T variant="h1" color={color} tabular>
        {value}
      </T>
      <T variant="caption" color={palette.text} numberOfLines={1}>
        {label}
      </T>
      {sub ? (
        <T variant="caption" color={palette.textMuted} numberOfLines={1}>
          {sub}
        </T>
      ) : null}
    </View>
  );
}

function LinkCard({ icon, label, onPress, color }: { icon: keyof typeof Ionicons.glyphMap; label: string; onPress: () => void; color: string }) {
  const { palette } = useTheme();
  return (
    <Card onPress={onPress} style={{ flex: 1, marginBottom: 0 }}>
      <View style={styles.linkInner}>
        <Ionicons name={icon} size={22} color={color} />
        <T variant="title" style={{ marginStart: spacing.sm }}>
          {label}
        </T>
      </View>
    </Card>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  kpiRow: { flexDirection: 'row', gap: spacing.sm, marginBottom: spacing.md },
  stat: { flex: 1, borderWidth: 1, borderRadius: 12, padding: spacing.md, alignItems: 'flex-start' },
  linksRow: { flexDirection: 'row', gap: spacing.sm, marginBottom: spacing.md },
  linkInner: { flexDirection: 'row', alignItems: 'center' },
  sectionLabel: { marginTop: spacing.md, marginBottom: spacing.sm, textTransform: 'uppercase', letterSpacing: 0.5 },
  alertTop: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: spacing.sm },
  okRow: { flexDirection: 'row', alignItems: 'center' },
});
