/**
 * NewDelegationScreen — create an ALL_ROLES delegation. The delegate is chosen
 * from a searchable user picker (GET /dct/users/?search=) instead of typing a
 * raw user ID. Richer role/module scoping stays on the web admin.
 */
import React, { useState } from 'react';
import {
  Alert,
  Modal,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  TextInput,
  View,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useNavigation } from '@react-navigation/native';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { FlashList } from '@shopify/flash-list';
import { Ionicons } from '@expo/vector-icons';
import { createDelegation } from '@/api/delegations';
import { searchUsers, type UserLite } from '@/api/users';
import type { ApiError } from '@/api/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { radius, spacing, type ThemePalette } from '@/theme/tokens';
import { Button, EmptyState, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';

function todayISO(offsetDays = 0): string {
  const d = new Date();
  d.setDate(d.getDate() + offsetDays);
  return d.toISOString().slice(0, 10);
}

/** Module-level field (must NOT live inside the screen render — that remounts
 *  the TextInput on each keystroke and dismisses the keyboard). */
function Field({
  label,
  value,
  onChangeText,
  palette,
  multiline,
  placeholder,
}: {
  label: string;
  value: string;
  onChangeText: (v: string) => void;
  palette: ThemePalette;
  multiline?: boolean;
  placeholder?: string;
}) {
  return (
    <View style={{ marginTop: spacing.md }}>
      <T variant="label" color={palette.textMuted}>
        {label}
      </T>
      <TextInput
        value={value}
        onChangeText={onChangeText}
        multiline={multiline}
        placeholder={placeholder}
        placeholderTextColor={palette.textMuted}
        style={[
          styles.input,
          multiline ? { minHeight: 80, textAlignVertical: 'top' } : null,
          { color: palette.text, borderColor: palette.border, backgroundColor: palette.surface },
        ]}
      />
    </View>
  );
}

export function NewDelegationScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const nav = useNavigation();
  const qc = useQueryClient();

  const [delegate, setDelegate] = useState<UserLite | null>(null);
  const [startDate, setStartDate] = useState(todayISO());
  const [endDate, setEndDate] = useState(todayISO(7));
  const [reason, setReason] = useState('');

  // User picker state
  const [pickerOpen, setPickerOpen] = useState(false);
  const [search, setSearch] = useState('');
  const { data: users, isFetching } = useQuery({
    queryKey: ['users', 'search', search],
    queryFn: () => searchUsers(search),
    enabled: pickerOpen,
  });

  const mutation = useMutation({
    mutationFn: () =>
      createDelegation({
        delegateId: delegate!.userId,
        scope: 'ALL_ROLES',
        startDate,
        endDate,
        reason: reason.trim() || undefined,
      }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['delegations'] });
      nav.goBack();
    },
    onError: (e) => Alert.alert(t('err.generic'), (e as unknown as ApiError).message),
  });

  const submit = () => {
    if (!delegate) {
      Alert.alert(t('err.generic'), t('deleg.selectUser'));
      return;
    }
    if (!endDate) {
      Alert.alert(t('err.generic'), t('deleg.to'));
      return;
    }
    mutation.mutate();
  };

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={t('deleg.new')}
        right={<Button label={t('deleg.create')} loading={mutation.isPending} onPress={submit} />}
      />
      <ScrollView
        contentContainerStyle={{ padding: spacing.lg }}
        keyboardShouldPersistTaps="handled"
        keyboardDismissMode={Platform.OS === 'ios' ? 'interactive' : 'on-drag'}
      >
        {/* Delegate picker (tap to open the searchable user list) */}
        <View style={{ marginTop: spacing.md }}>
          <T variant="label" color={palette.textMuted}>
            {t('deleg.delegate')}
          </T>
          <Pressable
            onPress={() => setPickerOpen(true)}
            style={[styles.input, styles.pickerField, { borderColor: palette.border, backgroundColor: palette.surface }]}
          >
            <T variant="body" color={delegate ? palette.text : palette.textMuted} numberOfLines={1} style={{ flex: 1 }}>
              {delegate ? delegate.displayName : t('deleg.selectUser')}
            </T>
            <Ionicons name="chevron-down" size={18} color={palette.textMuted} />
          </Pressable>
          {delegate ? (
            <T variant="caption" color={palette.textMuted} style={{ marginTop: 4 }}>
              {delegate.username}
              {delegate.orgName ? ` · ${delegate.orgName}` : ''}
            </T>
          ) : null}
        </View>

        <Field label={t('deleg.from')} value={startDate} onChangeText={setStartDate} palette={palette} placeholder="YYYY-MM-DD" />
        <Field label={t('deleg.to')} value={endDate} onChangeText={setEndDate} palette={palette} placeholder="YYYY-MM-DD" />
        <Field label={t('deleg.reason')} value={reason} onChangeText={setReason} palette={palette} multiline />
      </ScrollView>

      {/* User picker modal */}
      <Modal visible={pickerOpen} animationType="slide" onRequestClose={() => setPickerOpen(false)}>
        <SafeAreaView style={{ flex: 1, backgroundColor: palette.bg }}>
          <ScreenHeader
            title={t('deleg.selectUser')}
            right={
              <Button label={t('common.cancel')} variant="ghost" onPress={() => setPickerOpen(false)} />
            }
          />
          <View style={{ paddingHorizontal: spacing.lg, paddingTop: spacing.md }}>
            <View style={[styles.searchRow, { borderColor: palette.border, backgroundColor: palette.surface }]}>
              <Ionicons name="search" size={18} color={palette.textMuted} />
              <TextInput
                autoFocus
                value={search}
                onChangeText={setSearch}
                placeholder={t('deleg.searchUsers')}
                placeholderTextColor={palette.textMuted}
                style={{ flex: 1, marginStart: 8, color: palette.text, fontSize: 16 }}
              />
              {isFetching ? <Ionicons name="sync" size={16} color={palette.textMuted} /> : null}
            </View>
          </View>
          <FlashList<UserLite>
            data={users ?? []}
            keyExtractor={(u: UserLite) => String(u.userId)}
            estimatedItemSize={64}
            keyboardShouldPersistTaps="handled"
            contentContainerStyle={{ padding: spacing.lg }}
            ListEmptyComponent={
              !isFetching ? <EmptyState icon="people-outline" title={t('deleg.noUsers')} /> : null
            }
            renderItem={({ item }: { item: UserLite }) => (
              <Pressable
                onPress={() => {
                  setDelegate(item);
                  setPickerOpen(false);
                }}
                style={({ pressed }) => [
                  styles.userRow,
                  { borderColor: palette.border, backgroundColor: pressed ? palette.surfaceAlt : palette.surface },
                ]}
              >
                <View style={[styles.userAvatar, { backgroundColor: item.color ?? palette.brand }]}>
                  <T variant="label" color="#fff">
                    {(item.displayName || '?').slice(0, 1).toUpperCase()}
                  </T>
                </View>
                <View style={{ flex: 1, marginStart: spacing.md }}>
                  <T variant="title" numberOfLines={1}>
                    {item.displayName}
                  </T>
                  <T variant="caption" color={palette.textMuted} numberOfLines={1}>
                    {item.username}
                    {item.orgName ? ` · ${item.orgName}` : ''}
                  </T>
                </View>
              </Pressable>
            )}
          />
        </SafeAreaView>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  input: {
    minHeight: 48,
    borderWidth: 1,
    borderRadius: radius.md,
    paddingHorizontal: spacing.md,
    marginTop: 4,
    fontSize: 16,
  },
  pickerField: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  searchRow: {
    flexDirection: 'row',
    alignItems: 'center',
    minHeight: 48,
    borderWidth: 1,
    borderRadius: radius.md,
    paddingHorizontal: spacing.md,
  },
  userRow: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: spacing.md,
    borderWidth: 1,
    borderRadius: radius.md,
    marginBottom: spacing.sm,
  },
  userAvatar: { width: 40, height: 40, borderRadius: 20, alignItems: 'center', justifyContent: 'center' },
});
