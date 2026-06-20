/**
 * AtdTargetsScreen — full CRUD for target databases (list + create/edit modal
 * with enable/disable + delete). All writes `requireOnline`.
 */
import React, { useState } from 'react';
import { Alert, Pressable, ScrollView, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { Ionicons } from '@expo/vector-icons';
import { useQuery } from '@tanstack/react-query';
import { getAtdTargets, TARGET_KINDS, type AtdTarget } from '@/api/atd';
import { useQueuedMutation } from '@/hooks/useQueuedMutation';
import type { ApiError } from '@/api/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Badge, Button, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { TextField, EnumField, ToggleField } from '@/components/form';

const BLANK: AtdTarget = {
  targetName: '',
  description: '',
  dbKind: 'LOCAL_ATP',
  dbLink: '',
  schemaName: '',
  tnsAlias: '',
  enabled: 'Y',
};

export function AtdTargetsScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const [form, setForm] = useState<AtdTarget | null>(null);
  const [isNew, setIsNew] = useState(false);

  const { data, isLoading, isRefetching, refetch } = useQuery({ queryKey: ['atd', 'targets'], queryFn: getAtdTargets });

  const save = useQueuedMutation<{ create: boolean; tgt: AtdTarget }>({
    module: 'atd',
    requireOnline: true,
    method: (v) => (v.create ? 'POST' : 'PUT'),
    path: (v) => (v.create ? '/targets' : `/targets/${encodeURIComponent(v.tgt.targetName)}`),
    body: (v) => v.tgt,
    label: (v) => `ATD target ${v.create ? 'create' : 'update'} · ${v.tgt.targetName}`,
    invalidateKeys: () => [['atd', 'targets'], ['atd', 'lookups']],
  });
  const del = useQueuedMutation<{ name: string }>({
    module: 'atd',
    requireOnline: true,
    method: () => 'DELETE',
    path: (v) => `/targets/${encodeURIComponent(v.name)}`,
    label: (v) => `ATD target delete · ${v.name}`,
    invalidateKeys: () => [['atd', 'targets']],
  });

  const onErr = (e: ApiError) => Alert.alert(t('atd.targets'), e.status === 0 ? t('queue.offline') : e.message);
  const close = () => setForm(null);

  const submit = () => {
    if (!form) return;
    if (!form.targetName.trim()) return Alert.alert(t('atd.targets'), t('atd.targetName'));
    save.mutate(
      { create: isNew, tgt: form },
      { onSuccess: () => { close(); void refetch(); Alert.alert(t('atd.targets'), t('atd.saved')); }, onError: onErr },
    );
  };
  const remove = () => {
    if (!form) return;
    Alert.alert(t('atd.targets'), t('atd.confirmDeleteTarget', [form.targetName]), [
      { text: t('common.cancel'), style: 'cancel' },
      {
        text: t('atd.delete'),
        style: 'destructive',
        onPress: () => del.mutate({ name: form.targetName }, { onSuccess: () => { close(); void refetch(); }, onError: onErr }),
      },
    ]);
  };

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={t('atd.targets')}
        count={data?.length}
        right={<Button label={t('atd.new')} icon="add" onPress={() => { setForm({ ...BLANK }); setIsNew(true); }} />}
      />
      {isLoading && !data ? (
        <SkeletonList rows={3} />
      ) : (
        <FlashList<AtdTarget>
          data={data ?? []}
          keyExtractor={(x: AtdTarget) => x.targetName}
          estimatedItemSize={84}
          refreshing={isRefetching}
          onRefresh={() => void refetch()}
          contentContainerStyle={{ padding: spacing.lg }}
          ListEmptyComponent={<EmptyState icon="server-outline" title={t('atd.emptyTargets')} />}
          renderItem={({ item }: { item: AtdTarget }) => {
            const on = item.enabled === 'Y';
            return (
              <Pressable
                onPress={() => { setForm({ ...item }); setIsNew(false); }}
                style={({ pressed }) => [styles.row, { backgroundColor: pressed ? palette.surfaceAlt : palette.surface, borderColor: palette.border }]}
              >
                <View style={styles.rowTop}>
                  <Ionicons name={on ? 'power' : 'power-outline'} size={16} color={on ? palette.success : palette.textMuted} />
                  <T variant="title" numberOfLines={1} style={{ flex: 1, marginStart: 6 }}>
                    {item.targetName}
                  </T>
                  <Badge label={item.dbKind} color={palette.info} bg={palette.surfaceAlt} />
                </View>
                <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ marginTop: 2 }}>
                  {item.schemaName ? `${item.schemaName} · ` : ''}{on ? t('atd.enabled') : t('atd.disabled')}
                </T>
              </Pressable>
            );
          }}
        />
      )}

      {form ? (
        <SafeAreaView edges={['top']} style={[StyleSheet.absoluteFill, { backgroundColor: palette.bg }]}>
          <ScreenHeader
            title={isNew ? t('atd.newTarget') : t('atd.editTarget')}
            right={
              <View style={{ flexDirection: 'row', gap: spacing.sm }}>
                <Button label={t('common.back')} variant="ghost" onPress={close} />
                <Button label={t('common.save')} loading={save.isPending} onPress={submit} />
              </View>
            }
          />
          <ScrollView contentContainerStyle={{ padding: spacing.lg, paddingBottom: spacing.xxl }} keyboardShouldPersistTaps="handled">
            <TextField label={t('atd.targetName')} value={form.targetName} editable={isNew} onChangeText={(v) => setForm({ ...form, targetName: v })} autoCapitalize="characters" />
            <TextField label={t('atd.description')} value={form.description ?? ''} onChangeText={(v) => setForm({ ...form, description: v })} autoCapitalize="sentences" />
            <EnumField label={t('atd.dbKind')} value={form.dbKind} options={TARGET_KINDS} onChange={(v) => setForm({ ...form, dbKind: v })} />
            <TextField label={t('atd.schema')} value={form.schemaName ?? ''} onChangeText={(v) => setForm({ ...form, schemaName: v })} autoCapitalize="characters" />
            <TextField label={t('atd.dbLink')} value={form.dbLink ?? ''} onChangeText={(v) => setForm({ ...form, dbLink: v })} />
            <TextField label={t('atd.tnsAlias')} value={form.tnsAlias ?? ''} onChangeText={(v) => setForm({ ...form, tnsAlias: v })} />
            <ToggleField label={t('atd.enabled')} value={form.enabled === 'Y'} onChange={(b) => setForm({ ...form, enabled: b ? 'Y' : 'N' })} />
            {!isNew ? (
              <Button label={t('atd.deleteTarget')} variant="danger" icon="trash" loading={del.isPending} onPress={remove} style={{ marginTop: spacing.xl }} />
            ) : null}
          </ScrollView>
        </SafeAreaView>
      ) : null}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  row: { borderWidth: 1, borderRadius: 12, padding: spacing.md, marginBottom: spacing.md },
  rowTop: { flexDirection: 'row', alignItems: 'center', gap: spacing.sm },
});
