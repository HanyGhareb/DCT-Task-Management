/**
 * ApprovalDetailScreen — full request detail + approve / reject / return.
 * Comment is required (server enforces it). Haptic + confirm on action
 * (ui-ux-pro-max: haptic-feedback, confirmation-dialogs). On success the
 * pending list is invalidated and we pop back.
 */
import React, { useState } from 'react';
import { Alert, ScrollView, StyleSheet, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useNavigation, useRoute, type RouteProp } from '@react-navigation/native';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import * as Haptics from 'expo-haptics';
import { Ionicons } from '@expo/vector-icons';
import { actOnApproval, getPending } from '@/api/approvals';
import type { ApiError, WorkflowOutcome } from '@/api/types';
import type { RootStackParamList } from '@/navigation/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { moduleColor, radius, spacing } from '@/theme/tokens';
import { Badge, Button, Card, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { formatAmount, moduleLabel, relativeDate } from '@/utils/format';

type DetailRoute = RouteProp<RootStackParamList, 'ApprovalDetail'>;

function DetailField({ label, value }: { label: string; value: string }) {
  const { palette } = useTheme();
  return (
    <View style={styles.field}>
      <T variant="caption" color={palette.textMuted}>{label}</T>
      <T variant="body" style={{ marginTop: 2 }}>{value}</T>
    </View>
  );
}

export function ApprovalDetailScreen() {
  const { palette } = useTheme();
  const { t, lang } = useI18n();
  const nav = useNavigation();
  const { approval: initialApproval } = useRoute<DetailRoute>().params;
  const qc = useQueryClient();
  const [comment, setComment] = useState('');
  const [commentError, setCommentError] = useState(false);
  const { data: currentItems } = useQuery({ queryKey: ['approvals', 'pending'], queryFn: getPending });
  const approval = currentItems?.find((item: typeof initialApproval) => item.id === initialApproval.id) ?? initialApproval;
  const accent = moduleColor(approval.module);

  const mutation = useMutation({
    mutationFn: ({ outcome, comments }: { outcome: string; comments: string }) =>
      actOnApproval(approval.id, outcome, comments),
    onSuccess: async () => {
      await Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
      qc.invalidateQueries({ queryKey: ['approvals'] });
      qc.invalidateQueries({ queryKey: ['notifications'] });
      nav.goBack();
    },
    onError: (e) => {
      const err = e as unknown as ApiError;
      Alert.alert(t('err.generic'), err.message);
    },
  });

  const submit = (outcome: WorkflowOutcome) => {
    if (outcome.requiresComment === 'Y' && !comment.trim()) {
      setCommentError(true);
      void Haptics.notificationAsync(Haptics.NotificationFeedbackType.Warning);
      return;
    }
    const label = lang === 'ar' ? outcome.labelAr : outcome.labelEn;
    const msg = t('appr.confirmOutcome', [label]);
    Alert.alert(t('appr.title'), msg, [
      { text: t('common.cancel'), style: 'cancel' },
      {
        text: label,
        style: outcome.isPositive === 'N' ? 'destructive' : 'default',
        onPress: () => mutation.mutate({ outcome: outcome.code, comments: comment.trim() }),
      },
    ]);
  };

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader
        title={moduleLabel(approval.module)}
        right={
          <Button label={t('common.back')} variant="ghost" icon="chevron-back" onPress={() => nav.goBack()} />
        }
      />
      <ScrollView contentContainerStyle={{ padding: spacing.lg }} keyboardShouldPersistTaps="handled">
        <Card accentColor={accent}>
          <View style={styles.row}>
            <Badge label={moduleLabel(approval.module)} color={accent} bg={`${accent}22`} />
            <T variant="h2" tabular>
              {t('common.aed')} {formatAmount(approval.amount)}
            </T>
          </View>
          <DetailField label={t('appr.reference')} value={approval.requestRef} />
          <DetailField label={t('appr.workflow')} value={approval.processName} />
          <DetailField label={t('appr.requestedBy', ['']).trim()} value={approval.requestedBy} />
          <DetailField label={t('appr.submitted')} value={relativeDate(approval.requestedAt)} />
          <DetailField label={t('appr.stage')} value={`${approval.currentStepName} · ${t('appr.step', [approval.currentStep, approval.totalSteps])}`} />
          {approval.actingFor ? <DetailField label={t('appr.delegation')} value={t('appr.actingFor', [approval.actingFor])} /> : null}
        </Card>

        <T variant="label" style={{ marginTop: spacing.md, marginBottom: 4 }}>
          {t('appr.comments')} <T variant="label" color={palette.danger}>*</T>
        </T>
        <TextInput
          accessibilityLabel={t('appr.comments')}
          multiline
          value={comment}
          onChangeText={(v) => {
            setComment(v);
            if (commentError && v.trim()) setCommentError(false);
          }}
          placeholder={t('appr.comments')}
          placeholderTextColor={palette.textMuted}
          style={[
            styles.comment,
            {
              color: palette.text,
              backgroundColor: palette.surface,
              borderColor: commentError ? palette.danger : palette.border,
            },
          ]}
        />
        {commentError ? (
          <View style={styles.errRow}>
            <Ionicons name="alert-circle" size={14} color={palette.danger} />
            <T variant="caption" color={palette.danger} style={{ marginStart: 4 }}>
              {t('appr.commentsRequired')}
            </T>
          </View>
        ) : null}

        <View style={styles.actionRow}>
          {approval.outcomes.map((outcome: WorkflowOutcome) => (
            <Button
              key={outcome.code}
              label={lang === 'ar' ? outcome.labelAr : outcome.labelEn}
              variant={outcome.isPositive === 'N' ? 'danger' : 'primary'}
              color={outcome.color}
              loading={mutation.isPending}
              disabled={mutation.isPending}
              style={styles.outcomeButton}
              onPress={() => submit(outcome)}
            />
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  row: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: spacing.sm },
  field: { marginTop: spacing.md },
  comment: {
    minHeight: 96,
    borderWidth: 1,
    borderRadius: radius.md,
    padding: spacing.md,
    fontSize: 16,
    textAlignVertical: 'top',
  },
  errRow: { flexDirection: 'row', alignItems: 'center', marginTop: 6 },
  actionRow: { flexDirection: 'row', flexWrap: 'wrap', gap: spacing.sm, marginTop: spacing.lg },
  outcomeButton: { flexGrow: 1, minWidth: '46%' },
});
