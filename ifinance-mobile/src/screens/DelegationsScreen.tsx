/**
 * DelegationsScreen — list my delegations + cancel; FAB-style header action to
 * create a new one (NewDelegation modal route).
 */
import React from 'react';
import { Alert, RefreshControl, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { cancelDelegation, getMyDelegations } from '@/api/delegations';
import type { Delegation, ApiError } from '@/api/types';
import type { RootStackParamList } from '@/navigation/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Badge, Button, Card, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { relativeDate } from '@/utils/format';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export function DelegationsScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const nav = useNavigation<Nav>();
  const qc = useQueryClient();

  const { data, isLoading, isError, refetch, isRefetching } = useQuery({
    queryKey: ['delegations', 'mine'],
    queryFn: getMyDelegations,
  });

  const cancelMutation = useMutation({
    mutationFn: (id: number) => cancelDelegation(id),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['delegations'] }),
    onError: (e) => Alert.alert(t('err.generic'), (e as unknown as ApiError).message),
  });

  const statusColor = (s: Delegation['status']) =>
    s === 'ACTIVE' ? palette.success : s === 'CANCELLED' ? palette.danger : palette.textMuted;

  const renderItem = ({ item }: { item: Delegation }) => (
    <Card>
      <View style={styles.row}>
        <T variant="title" numberOfLines={1} style={{ flex: 1 }}>
          {item.delegateName}
        </T>
        <Badge label={t(`status.${item.status}` as const)} color={statusColor(item.status)} bg={`${statusColor(item.status)}22`} />
      </View>
      <T variant="caption" color={palette.textMuted} style={{ marginTop: 4 }}>
        {item.scope === 'ALL_ROLES' ? t('deleg.scopeAll') : item.roleName || item.moduleName || item.scope}
      </T>
      <T variant="caption" color={palette.textMuted} style={{ marginTop: 2 }}>
        {t('deleg.from')} {relativeDate(item.startDate)} · {t('deleg.to')} {relativeDate(item.endDate)}
      </T>
      {item.reason ? (
        <T variant="body" style={{ marginTop: 6 }} numberOfLines={2}>
          {item.reason}
        </T>
      ) : null}
      {item.status === 'ACTIVE' ? (
        <Button
          label={t('deleg.cancel')}
          variant="ghost"
          icon="close-circle"
          style={{ alignSelf: 'flex-start', marginTop: 6 }}
          onPress={() =>
            Alert.alert(t('deleg.title'), t('deleg.confirmCancel'), [
              { text: t('common.cancel'), style: 'cancel' },
              { text: t('deleg.cancel'), style: 'destructive', onPress: () => cancelMutation.mutate(item.delegationId) },
            ])
          }
        />
      ) : null}
    </Card>
  );

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={t('deleg.title')}
        right={<Button label={t('deleg.new')} icon="add" onPress={() => nav.navigate('NewDelegation')} />}
      />
      {isLoading ? (
        <SkeletonList />
      ) : isError ? (
        <EmptyState icon="cloud-offline" title={t('err.generic')} subtitle={t('offline.banner')} />
      ) : (
        <FlashList
          data={data ?? []}
          keyExtractor={(it) => String(it.delegationId)}
          renderItem={renderItem}
          estimatedItemSize={140}
          contentContainerStyle={{ padding: spacing.lg }}
          ListEmptyComponent={<EmptyState icon="people-circle" title={t('deleg.empty')} subtitle={t('deleg.emptySub')} />}
          refreshControl={<RefreshControl refreshing={isRefetching} onRefresh={refetch} tintColor={palette.brand} />}
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  row: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
});
