/**
 * AtdEnvironmentsScreen — full CRUD for OTBI environments (list + create/edit
 * modal with enable/disable toggle + delete). All writes `requireOnline`.
 */
import React, { useState } from 'react';
import { Alert, Pressable, ScrollView, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { FlashList } from '@shopify/flash-list';
import { Ionicons } from '@expo/vector-icons';
import { useQuery } from '@tanstack/react-query';
import {
  getAtdEnvs,
  ENV_AUTH_TYPES,
  ENV_TRACKS,
  type AtdEnv,
} from '@/api/atd';
import { useQueuedMutation } from '@/hooks/useQueuedMutation';
import type { ApiError } from '@/api/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Badge, Button, EmptyState, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { TextField, EnumField, ToggleField } from '@/components/form';

const BLANK: AtdEnv = {
  envName: '',
  description: '',
  analyticsBaseUrl: '',
  xmlpserverBaseUrl: '',
  authType: 'SESSION',
  credentialRef: '',
  extractTrack: 'BROWSER',
  enabled: 'Y',
};

export function AtdEnvironmentsScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const [form, setForm] = useState<AtdEnv | null>(null);
  const [isNew, setIsNew] = useState(false);

  const { data, isLoading, isRefetching, refetch } = useQuery({ queryKey: ['atd', 'envs'], queryFn: getAtdEnvs });

  const save = useQueuedMutation<{ create: boolean; env: AtdEnv }>({
    module: 'atd',
    requireOnline: true,
    method: (v) => (v.create ? 'POST' : 'PUT'),
    path: (v) => (v.create ? '/envs' : `/envs/${encodeURIComponent(v.env.envName)}`),
    body: (v) => v.env,
    label: (v) => `ATD env ${v.create ? 'create' : 'update'} · ${v.env.envName}`,
    invalidateKeys: () => [['atd', 'envs'], ['atd', 'lookups']],
  });
  const del = useQueuedMutation<{ name: string }>({
    module: 'atd',
    requireOnline: true,
    method: () => 'DELETE',
    path: (v) => `/envs/${encodeURIComponent(v.name)}`,
    label: (v) => `ATD env delete · ${v.name}`,
    invalidateKeys: () => [['atd', 'envs']],
  });

  const onErr = (e: ApiError) => Alert.alert(t('atd.environments'), e.status === 0 ? t('queue.offline') : e.message);
  const close = () => setForm(null);

  const submit = () => {
    if (!form) return;
    if (!form.envName.trim()) return Alert.alert(t('atd.environments'), t('atd.envName'));
    save.mutate(
      { create: isNew, env: form },
      { onSuccess: () => { close(); void refetch(); Alert.alert(t('atd.environments'), t('atd.saved')); }, onError: onErr },
    );
  };
  const remove = () => {
    if (!form) return;
    Alert.alert(t('atd.environments'), t('atd.confirmDeleteEnv', [form.envName]), [
      { text: t('common.cancel'), style: 'cancel' },
      {
        text: t('atd.delete'),
        style: 'destructive',
        onPress: () => del.mutate({ name: form.envName }, { onSuccess: () => { close(); void refetch(); }, onError: onErr }),
      },
    ]);
  };

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={t('atd.environments')}
        count={data?.length}
        right={<Button label={t('atd.new')} icon="add" onPress={() => { setForm({ ...BLANK }); setIsNew(true); }} />}
      />
      {isLoading && !data ? (
        <SkeletonList rows={3} />
      ) : (
        <FlashList<AtdEnv>
          data={data ?? []}
          keyExtractor={(e: AtdEnv) => e.envName}
          estimatedItemSize={88}
          refreshing={isRefetching}
          onRefresh={() => void refetch()}
          contentContainerStyle={{ padding: spacing.lg }}
          ListEmptyComponent={<EmptyState icon="cloud-outline" title={t('atd.emptyEnvs')} />}
          renderItem={({ item }: { item: AtdEnv }) => {
            const on = item.enabled === 'Y';
            return (
              <Pressable
                onPress={() => { setForm({ ...item }); setIsNew(false); }}
                style={({ pressed }) => [styles.row, { backgroundColor: pressed ? palette.surfaceAlt : palette.surface, borderColor: palette.border }]}
              >
                <View style={styles.rowTop}>
                  <Ionicons name={on ? 'power' : 'power-outline'} size={16} color={on ? palette.success : palette.textMuted} />
                  <T variant="title" numberOfLines={1} style={{ flex: 1, marginStart: 6 }}>
                    {item.envName}
                  </T>
                  <Badge label={item.extractTrack} color={palette.info} bg={palette.surfaceAlt} />
                </View>
                {item.description ? (
                  <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ marginTop: 2 }}>
                    {item.description}
                  </T>
                ) : null}
                <T variant="caption" color={palette.textMuted} numberOfLines={1} style={{ marginTop: 2 }}>
                  {item.authType} · {on ? t('atd.enabled') : t('atd.disabled')}
                </T>
              </Pressable>
            );
          }}
        />
      )}

      {form ? (
        <SafeAreaView edges={['top']} style={[StyleSheet.absoluteFill, { backgroundColor: palette.bg }]}>
          <ScreenHeader
            title={isNew ? t('atd.newEnv') : t('atd.editEnv')}
            right={
              <View style={{ flexDirection: 'row', gap: spacing.sm }}>
                <Button label={t('common.back')} variant="ghost" onPress={close} />
                <Button label={t('common.save')} loading={save.isPending} onPress={submit} />
              </View>
            }
          />
          <ScrollView contentContainerStyle={{ padding: spacing.lg, paddingBottom: spacing.xxl }} keyboardShouldPersistTaps="handled">
            <TextField label={t('atd.envName')} value={form.envName} editable={isNew} onChangeText={(v) => setForm({ ...form, envName: v })} autoCapitalize="characters" />
            <TextField label={t('atd.description')} value={form.description ?? ''} onChangeText={(v) => setForm({ ...form, description: v })} autoCapitalize="sentences" />
            <TextField label={t('atd.analyticsUrl')} value={form.analyticsBaseUrl ?? ''} onChangeText={(v) => setForm({ ...form, analyticsBaseUrl: v })} keyboardType="url" />
            <TextField label={t('atd.xmlpUrl')} value={form.xmlpserverBaseUrl ?? ''} onChangeText={(v) => setForm({ ...form, xmlpserverBaseUrl: v })} keyboardType="url" />
            <TextField label={t('atd.credentialRef')} value={form.credentialRef ?? ''} onChangeText={(v) => setForm({ ...form, credentialRef: v })} />
            <EnumField label={t('atd.authType')} value={form.authType} options={ENV_AUTH_TYPES} onChange={(v) => setForm({ ...form, authType: v })} />
            <EnumField label={t('atd.track')} value={form.extractTrack} options={ENV_TRACKS} onChange={(v) => setForm({ ...form, extractTrack: v })} />
            <ToggleField label={t('atd.enabled')} value={form.enabled === 'Y'} onChange={(b) => setForm({ ...form, enabled: b ? 'Y' : 'N' })} />
            {!isNew ? (
              <Button label={t('atd.deleteEnv')} variant="danger" icon="trash" loading={del.isPending} onPress={remove} style={{ marginTop: spacing.xl }} />
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
