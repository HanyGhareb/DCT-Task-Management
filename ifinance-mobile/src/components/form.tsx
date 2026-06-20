/**
 * form.tsx — small theme-aware form primitives shared by the ATD admin forms
 * (Environments / Targets / Runner Settings). 44pt touch targets, visible
 * labels (ui-ux-pro-max input-labels), enum pills, and a Y/N toggle.
 */
import React from 'react';
import { Pressable, StyleSheet, TextInput, View } from 'react-native';
import { useTheme } from '@/theme/ThemeProvider';
import { radius, spacing } from '@/theme/tokens';
import { T } from './ui';

export function TextField({
  label,
  value,
  onChangeText,
  placeholder,
  keyboardType,
  secureTextEntry,
  multiline,
  autoCapitalize = 'none',
  helper,
  editable = true,
}: {
  label: string;
  value: string;
  onChangeText: (v: string) => void;
  placeholder?: string;
  keyboardType?: 'default' | 'numeric' | 'email-address' | 'url';
  secureTextEntry?: boolean;
  multiline?: boolean;
  autoCapitalize?: 'none' | 'sentences' | 'words' | 'characters';
  helper?: string;
  editable?: boolean;
}) {
  const { palette } = useTheme();
  return (
    <View style={{ marginTop: spacing.md }}>
      <T variant="label" color={palette.textMuted}>
        {label}
      </T>
      <TextInput
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor={palette.textMuted}
        keyboardType={keyboardType}
        secureTextEntry={secureTextEntry}
        multiline={multiline}
        editable={editable}
        autoCapitalize={autoCapitalize}
        autoCorrect={false}
        style={[
          styles.input,
          multiline ? { minHeight: 76, textAlignVertical: 'top' } : null,
          {
            color: editable ? palette.text : palette.textMuted,
            borderColor: palette.border,
            backgroundColor: editable ? palette.surface : palette.surfaceAlt,
          },
        ]}
      />
      {helper ? (
        <T variant="caption" color={palette.textMuted} style={{ marginTop: 4 }}>
          {helper}
        </T>
      ) : null}
    </View>
  );
}

export function EnumField({
  label,
  value,
  options,
  onChange,
}: {
  label: string;
  value: string;
  options: readonly string[];
  onChange: (v: string) => void;
}) {
  const { palette } = useTheme();
  return (
    <View style={{ marginTop: spacing.md }}>
      <T variant="label" color={palette.textMuted}>
        {label}
      </T>
      <View style={styles.pillRow}>
        {options.map((opt) => {
          const on = opt === value;
          return (
            <Pressable
              key={opt}
              onPress={() => onChange(opt)}
              style={[
                styles.pill,
                {
                  backgroundColor: on ? palette.brand : palette.surface,
                  borderColor: on ? palette.brand : palette.border,
                },
              ]}
            >
              <T variant="caption" color={on ? '#fff' : palette.text}>
                {opt}
              </T>
            </Pressable>
          );
        })}
      </View>
    </View>
  );
}

export function ToggleField({
  label,
  value,
  onChange,
}: {
  label: string;
  value: boolean;
  onChange: (v: boolean) => void;
}) {
  const { palette } = useTheme();
  return (
    <Pressable onPress={() => onChange(!value)} style={styles.toggleRow}>
      <T variant="body" style={{ flex: 1 }}>
        {label}
      </T>
      <View style={[styles.track, { backgroundColor: value ? palette.success : palette.surfaceAlt, borderColor: palette.border }]}>
        <View style={[styles.knob, { backgroundColor: '#fff', alignSelf: value ? 'flex-end' : 'flex-start' }]} />
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  input: {
    minHeight: 48,
    borderWidth: 1,
    borderRadius: radius.md,
    paddingHorizontal: spacing.md,
    marginTop: 4,
    fontSize: 16,
  },
  pillRow: { flexDirection: 'row', flexWrap: 'wrap', gap: spacing.sm, marginTop: 6 },
  pill: { paddingHorizontal: spacing.md, paddingVertical: 8, borderRadius: radius.pill, borderWidth: 1 },
  toggleRow: { flexDirection: 'row', alignItems: 'center', marginTop: spacing.lg },
  track: { width: 46, height: 28, borderRadius: 14, borderWidth: 1, padding: 2, justifyContent: 'center' },
  knob: { width: 22, height: 22, borderRadius: 11 },
});
