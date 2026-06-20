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
import { useMutation, useQueryClient } from '@tanstack/react-query';
import * as Haptics from 'expo-haptics';
import { Ionicons } from '@expo/vector-icons';
import { actOnApproval } from '@/api/approvals';
import type { ApiError, ApprovalAction } from '@/api/types';
import type { RootStackParamList } from '@/navigation/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { moduleColor, radius, spacing } from '@/theme/tokens';
import { Badge, Button, Card, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';
import { formatAmount, moduleLabel, relativeDate } from '@/utils/format';

type DetailRoute = RouteProp<RootStackParamList, 'ApprovalDetail'>;

export function ApprovalDetailScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const nav = useNavigation();
  const { approval } = useRoute<DetailRoute>().params;
  const qc = useQueryClient();
  const [comment, setComment] = useState('');
  const [commentError, setCommentError] = useState(false);
  const accent = moduleColor(approval.module);

  const mutation = useMutation({
    mutationFn: ({ action, comments }: { action: ApprovalAction; comments: string }) =>
      actOnApproval(approval.instanceId, action, comments),
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

  const submit = (action: ApprovalAction) => {
    if (!comment.trim()) {
      setCommentError(true);
      void Haptics.notificationAsync(Haptics.NotificationFeedbackType.Warning);
      return;
    }
    const msg =
      action === 'APPROVED'
        ? t('appr.confirmApprove')
        : action === 'REJECTED'
          ? t('appr.confirmReject')
          : t('appr.confirmReturn');
    Alert.alert(t('appr.title'), msg, [
      { text: t('common.cancel'), style: 'cancel' },
      {
        text: t(action === 'APPROVED' ? 'appr.approve' : action === 'REJECTED' ? 'appr.reject' : 'appr.return'),
        style: action === 'REJECTED' ? 'destructive' : 'default',
        onPress: () => mutation.mutate({ action, comments: comment.trim() }),
      },
    ]);
  };

  const Field = ({ label, value }: { label: string; value: string }) => (
    <View style={styles.field}>
      <T variant="caption" color={palette.textMuted}>
        {label}
      </T>
      <T variant="body" style={{ marginTop: 2 }}>
        {value}
      </T>
    </View>
  );

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
          <Field label="Reference" value={approval.requestRef} />
          <Field label="Workflow" value={approval.templateName} />
          <Field label={t('appr.requestedBy', ['']).trim()} value={approval.requestedBy} />
          <Field label="Submitted" value={relativeDate(approval.requestedAt)} />
          <Field label="Stage" value={`${approval.currentStepName} · ${t('appr.step', [approval.currentStep, approval.totalSteps])}`} />
          {approval.actingFor ? <Field label="Delegation" value={t('appr.actingFor', [approval.actingFor])} /> : null}
        </Card>

        <T variant="label" style={{ marginTop: spacing.md, marginBottom: 4 }}>
          {t('appr.comments')} <T variant="label" color={palette.danger}>*</T>
        </T>
        <TextInput
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

        <View style={{ marginTop: spacing.lg }}>
          <Button
            label={t('appr.approve')}
            icon="checkmark-circle"
            color={palette.success}
            loading={mutation.isPending}
            onPress={() => submit('APPROVED')}
          />
          <View style={styles.actionRow}>
            <Button
              label={t('appr.return')}
              variant="secondary"
              style={{ flex: 1, marginEnd: spacing.sm }}
              onPress={() => submit('RETURNED')}
            />
            <Button
              label={t('appr.reject')}
              variant="danger"
              style={{ flex: 1 }}
              onPress={() => submit('REJECTED')}
            />
          </View>
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
  actionRow: { flexDirection: 'row', marginTop: spacing.sm },
});
