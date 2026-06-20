/**
 * ApprovalsScreen — unified pending-approvals inbox.
 * FlashList for performance (react-native-best-practices: js-lists).
 * Pull-to-refresh; offline-aware via TanStack Query cache.
 */
import React from 'react';
import { RefreshControl, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { Ionicons } from '@expo/vector-icons';
import { getPending } from '@/api/approvals';
import type { PendingApproval } from '@/api/types';
import type { RootStackParamList } from '@/navigation/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { moduleColor, spacing } from '@/theme/tokens';
import { Badge, Card, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { formatAmount, moduleLabel, relativeDate } from '@/utils/format';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export function ApprovalsScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const nav = useNavigation<Nav>();

  const { data, isLoading, isError, refetch, isRefetching } = useQuery({
    queryKey: ['approvals', 'pending'],
    queryFn: getPending,
  });

  const renderItem = ({ item }: { item: PendingApproval }) => {
    const accent = moduleColor(item.module);
    return (
      <Card accentColor={accent} onPress={() => nav.navigate('ApprovalDetail', { approval: item })}>
        <View style={styles.row}>
          <Badge label={moduleLabel(item.module)} color={accent} bg={`${accent}22`} />
          <T variant="title" tabular>
            {t('common.aed')} {formatAmount(item.amount)}
          </T>
        </View>
        <T variant="body" style={{ marginTop: 6 }} numberOfLines={1}>
          {item.requestRef} · {item.templateName}
        </T>
        <View style={[styles.row, { marginTop: 8 }]}>
          <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ flex: 1 }}>
            {t('appr.requestedBy', [item.requestedBy])} · {relativeDate(item.requestedAt)}
          </T>
          <T variant="caption" color={palette.textMuted}>
            {t('appr.step', [item.currentStep, item.totalSteps])}
          </T>
        </View>
        {item.actingFor ? (
          <View style={[styles.acting, { backgroundColor: palette.warningSoft }]}>
            <Ionicons name="people" size={13} color={palette.warning} />
            <T variant="caption" color={palette.warning} style={{ marginStart: 5 }}>
              {t('appr.actingFor', [item.actingFor])}
            </T>
          </View>
        ) : null}
      </Card>
    );
  };

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader title={t('appr.title')} count={data?.length} />
      {isLoading ? (
        <SkeletonList />
      ) : isError ? (
        <EmptyState icon="cloud-offline" title={t('err.generic')} subtitle={t('offline.banner')} />
      ) : (
        <FlashList
          data={data ?? []}
          keyExtractor={(it) => String(it.instanceId)}
          renderItem={renderItem}
          estimatedItemSize={132}
          contentContainerStyle={{ padding: spacing.lg }}
          ListEmptyComponent={
            <EmptyState icon="checkmark-done-circle" title={t('appr.empty')} subtitle={t('appr.emptySub')} />
          }
          refreshControl={
            <RefreshControl refreshing={isRefetching} onRefresh={refetch} tintColor={palette.brand} />
          }
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  row: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  acting: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 999,
    marginTop: 8,
  },
});
