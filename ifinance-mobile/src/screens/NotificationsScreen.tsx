/**
 * NotificationsScreen — list + mark-read. Tapping an unread item marks it read
 * and refreshes the badge count.
 */
import React from 'react';
import { RefreshControl, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { Ionicons } from '@expo/vector-icons';
import { getNotifications, markRead } from '@/api/notifications';
import type { AppNotification } from '@/api/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Card, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { relativeDate } from '@/utils/format';

export function NotificationsScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const qc = useQueryClient();

  const { data, isLoading, isError, refetch, isRefetching } = useQuery({
    queryKey: ['notifications', 'list'],
    queryFn: getNotifications,
  });

  const readMutation = useMutation({
    mutationFn: (id: number) => markRead(id),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['notifications'] });
    },
  });

  const renderItem = ({ item }: { item: AppNotification }) => {
    const unread = item.isRead === 'N';
    return (
      <Card onPress={unread ? () => readMutation.mutate(item.notifId) : undefined}>
        <View style={styles.row}>
          {unread ? <View style={[styles.dot, { backgroundColor: palette.brand }]} /> : null}
          <T variant="title" numberOfLines={1} style={{ flex: 1 }}>
            {item.title}
          </T>
          <T variant="caption" color={palette.textMuted}>
            {relativeDate(item.createdAt)}
          </T>
        </View>
        {item.body ? (
          <T variant="body" color={palette.textMuted} style={{ marginTop: 4 }} numberOfLines={3}>
            {item.body}
          </T>
        ) : null}
        {unread ? (
          <View style={styles.markRow}>
            <Ionicons name="checkmark-done" size={14} color={palette.brand} />
            <T variant="caption" color={palette.brand} style={{ marginStart: 4 }}>
              {t('notif.markRead')}
            </T>
          </View>
        ) : null}
      </Card>
    );
  };

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader title={t('notif.title')} />
      {isLoading ? (
        <SkeletonList />
      ) : isError ? (
        <EmptyState icon="cloud-offline" title={t('err.generic')} subtitle={t('offline.banner')} />
      ) : (
        <FlashList
          data={data ?? []}
          keyExtractor={(it) => String(it.notifId)}
          renderItem={renderItem}
          estimatedItemSize={96}
          contentContainerStyle={{ padding: spacing.lg }}
          ListEmptyComponent={<EmptyState icon="notifications-off" title={t('notif.empty')} subtitle={t('notif.emptySub')} />}
          refreshControl={<RefreshControl refreshing={isRefetching} onRefresh={refetch} tintColor={palette.brand} />}
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  row: { flexDirection: 'row', alignItems: 'center' },
  dot: { width: 8, height: 8, borderRadius: 4, marginEnd: 8 },
  markRow: { flexDirection: 'row', alignItems: 'center', marginTop: 8 },
});
