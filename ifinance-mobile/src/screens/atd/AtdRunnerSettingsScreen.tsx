/**
 * AtdRunnerSettingsScreen — editor for ATD_RUNNER_CONFIG (GET/PUT /config).
 * Renders each setting by valueType (STRING / NUMBER / ENUM / BOOL / secret) and
 * PUTs only the keys the user changed, so write-only secrets are never clobbered.
 */
import React, { useMemo, useState } from 'react';
import { Alert, ScrollView, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import { getAtdConfig, type AtdConfigItem } from '@/api/atd';
import { useQueuedMutation } from '@/hooks/useQueuedMutation';
import type { ApiError } from '@/api/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { spacing } from '@/theme/tokens';
import { Button, SkeletonList, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { TextField, EnumField, ToggleField } from '@/components/form';

const isTrue = (v: string) => v === 'Y' || v === 'true' || v === '1';

export function AtdRunnerSettingsScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const [edits, setEdits] = useState<Record<string, string>>({});

  const { data, isLoading, refetch } = useQuery({ queryKey: ['atd', 'config'], queryFn: getAtdConfig });

  const items = data ?? [];
  const valueOf = (it: AtdConfigItem): string => (it.key in edits ? edits[it.key] : it.value);
  const changedKeys = useMemo(() => Object.keys(edits), [edits]);

  const set = (key: string, v: string) => setEdits((e) => ({ ...e, [key]: v }));

  const save = useQueuedMutation<{ items: Array<{ key: string; value: string }> }>({
    module: 'atd',
    requireOnline: true,
    method: () => 'PUT',
    path: () => '/config',
    body: (v) => ({ items: v.items }),
    label: () => 'ATD runner settings',
    invalidateKeys: () => [['atd', 'config']],
  });

  const submit = () => {
    if (!changedKeys.length) return Alert.alert(t('atd.runnerSettings'), t('atd.noChanges'));
    const payload = changedKeys.map((key) => ({ key, value: edits[key] }));
    save.mutate(
      { items: payload },
      {
        onSuccess: () => { setEdits({}); void refetch(); Alert.alert(t('atd.runnerSettings'), t('atd.settingsSaved')); },
        onError: (e: ApiError) => Alert.alert(t('atd.runnerSettings'), e.status === 0 ? t('queue.offline') : e.message),
      },
    );
  };

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={t('atd.runnerSettings')}
        count={changedKeys.length || undefined}
        right={<Button label={t('common.save')} loading={save.isPending} onPress={submit} />}
      />
      {isLoading && !data ? (
        <SkeletonList rows={6} />
      ) : (
        <ScrollView contentContainerStyle={{ padding: spacing.lg, paddingBottom: spacing.xxl }} keyboardShouldPersistTaps="handled">
          {items.map((it: AtdConfigItem) => {
            const val = valueOf(it);
            if (it.isSecret === 'Y') {
              return (
                <TextField
                  key={it.key}
                  label={it.key}
                  value={it.key in edits ? edits[it.key] : ''}
                  onChangeText={(v) => set(it.key, v)}
                  secureTextEntry
                  placeholder={it.secretSet === 'Y' ? '•••••• (set)' : ''}
                  helper={it.description || (it.secretSet === 'Y' ? t('atd.secretSet') : undefined)}
                />
              );
            }
            if (it.valueType === 'BOOL') {
              return (
                <View key={it.key} style={{ marginTop: spacing.sm }}>
                  <ToggleField label={it.key} value={isTrue(val)} onChange={(b) => set(it.key, b ? 'Y' : 'N')} />
                  {it.description ? <T variant="caption" color={palette.textMuted} style={{ marginTop: 4 }}>{it.description}</T> : null}
                </View>
              );
            }
            if (it.valueType === 'ENUM' && it.enumValues) {
              return (
                <EnumFieldWithHelp
                  key={it.key}
                  label={it.key}
                  value={val}
                  options={it.enumValues.split(',').map((s: string) => s.trim()).filter(Boolean)}
                  helper={it.description}
                  onChange={(v) => set(it.key, v)}
                />
              );
            }
            return (
              <TextField
                key={it.key}
                label={it.key}
                value={val}
                onChangeText={(v) => set(it.key, v)}
                keyboardType={it.valueType === 'NUMBER' ? 'numeric' : 'default'}
                multiline={it.valueType === 'STRING' && (val.length > 40 || val.includes('{'))}
                helper={it.description}
              />
            );
          })}
        </ScrollView>
      )}
    </SafeAreaView>
  );
}

function EnumFieldWithHelp({ label, value, options, helper, onChange }: { label: string; value: string; options: string[]; helper?: string; onChange: (v: string) => void }) {
  const { palette } = useTheme();
  return (
    <View>
      <EnumField label={label} value={value} options={options} onChange={onChange} />
      {helper ? <T variant="caption" color={palette.textMuted} style={{ marginTop: 4 }}>{helper}</T> : null}
    </View>
  );
}

const styles = StyleSheet.create({ safe: { flex: 1 } });
