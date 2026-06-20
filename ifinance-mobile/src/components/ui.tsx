/**
 * ui.tsx — the small reusable component kit (frontend-design / ui-design-system).
 * All components are theme-aware (useTheme) and meet the mobile UX guardrails:
 * 44pt touch targets, press feedback, single vector icon set, tabular figures.
 */
import React from 'react';
import {
  ActivityIndicator,
  Pressable,
  StyleSheet,
  Text,
  TextStyle,
  View,
  ViewStyle,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useTheme } from '@/theme/ThemeProvider';
import { radius, spacing, type } from '@/theme/tokens';

/* ── Button ─────────────────────────────────────────────────────────────── */
type BtnVariant = 'primary' | 'secondary' | 'danger' | 'ghost';

export function Button({
  label,
  onPress,
  variant = 'primary',
  loading,
  disabled,
  icon,
  style,
  color,
}: {
  label: string;
  onPress: () => void;
  variant?: BtnVariant;
  loading?: boolean;
  disabled?: boolean;
  icon?: keyof typeof Ionicons.glyphMap;
  style?: ViewStyle;
  color?: string; // override fill (e.g. module brand)
}) {
  const { palette } = useTheme();
  const fill =
    variant === 'primary'
      ? color ?? palette.brand
      : variant === 'danger'
        ? palette.danger
        : 'transparent';
  const fg =
    variant === 'primary' || variant === 'danger'
      ? '#FFFFFF'
      : variant === 'secondary'
        ? palette.text
        : palette.brand;
  const border = variant === 'secondary' ? palette.border : 'transparent';
  const isOff = disabled || loading;

  return (
    <Pressable
      accessibilityRole="button"
      accessibilityLabel={label}
      disabled={isOff}
      onPress={onPress}
      hitSlop={6}
      style={({ pressed }) => [
        styles.btn,
        { backgroundColor: fill, borderColor: border, opacity: isOff ? 0.5 : pressed ? 0.85 : 1 },
        pressed && { transform: [{ scale: 0.98 }] },
        style,
      ]}
    >
      {loading ? (
        <ActivityIndicator color={fg} />
      ) : (
        <View style={styles.btnInner}>
          {icon ? <Ionicons name={icon} size={18} color={fg} style={{ marginEnd: 6 }} /> : null}
          <Text style={[styles.btnText, { color: fg }]}>{label}</Text>
        </View>
      )}
    </Pressable>
  );
}

/* ── Card ───────────────────────────────────────────────────────────────── */
export function Card({
  children,
  onPress,
  style,
  accentColor,
}: {
  children: React.ReactNode;
  onPress?: () => void;
  style?: ViewStyle;
  accentColor?: string;
}) {
  const { palette } = useTheme();
  const body = (
    <View
      style={[
        styles.card,
        { backgroundColor: palette.surface, borderColor: palette.border },
        accentColor ? { borderStartWidth: 4, borderStartColor: accentColor } : null,
        style,
      ]}
    >
      {children}
    </View>
  );
  if (!onPress) return body;
  return (
    <Pressable onPress={onPress} style={({ pressed }) => (pressed ? { opacity: 0.9 } : null)}>
      {body}
    </Pressable>
  );
}

/* ── Badge ──────────────────────────────────────────────────────────────── */
export function Badge({ label, color, bg }: { label: string; color: string; bg: string }) {
  return (
    <View style={[styles.badge, { backgroundColor: bg }]}>
      <Text style={[styles.badgeText, { color }]} numberOfLines={1}>
        {label}
      </Text>
    </View>
  );
}

/* ── Text helpers ───────────────────────────────────────────────────────── */
export function T({
  children,
  variant = 'body',
  color,
  style,
  numberOfLines,
  tabular,
}: {
  children: React.ReactNode;
  variant?: keyof typeof type;
  color?: string;
  style?: TextStyle;
  numberOfLines?: number;
  tabular?: boolean;
}) {
  const { palette } = useTheme();
  return (
    <Text
      numberOfLines={numberOfLines}
      style={[
        type[variant],
        { color: color ?? palette.text },
        tabular ? { fontVariant: ['tabular-nums'] } : null,
        style,
      ]}
    >
      {children}
    </Text>
  );
}

/* ── EmptyState ─────────────────────────────────────────────────────────── */
export function EmptyState({
  icon,
  title,
  subtitle,
}: {
  icon: keyof typeof Ionicons.glyphMap;
  title: string;
  subtitle?: string;
}) {
  const { palette } = useTheme();
  return (
    <View style={styles.empty}>
      <Ionicons name={icon} size={48} color={palette.textMuted} />
      <T variant="title" style={{ marginTop: spacing.md, textAlign: 'center' }}>
        {title}
      </T>
      {subtitle ? (
        <T variant="body" color={palette.textMuted} style={{ marginTop: 4, textAlign: 'center' }}>
          {subtitle}
        </T>
      ) : null}
    </View>
  );
}

/* ── Skeleton (loading shimmer placeholder) ─────────────────────────────── */
export function SkeletonList({ rows = 5 }: { rows?: number }) {
  const { palette } = useTheme();
  return (
    <View style={{ padding: spacing.lg }}>
      {Array.from({ length: rows }).map((_, i) => (
        <View
          key={i}
          style={[styles.skeleton, { backgroundColor: palette.surfaceAlt, borderColor: palette.border }]}
        />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  btn: {
    minHeight: 48,
    paddingHorizontal: spacing.lg,
    borderRadius: radius.md,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  btnInner: { flexDirection: 'row', alignItems: 'center' },
  btnText: { fontSize: 16, fontWeight: '600' },
  card: {
    borderRadius: radius.md,
    borderWidth: 1,
    padding: spacing.lg,
    marginBottom: spacing.md,
  },
  badge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: 3,
    borderRadius: radius.pill,
    alignSelf: 'flex-start',
  },
  badgeText: { fontSize: 12, fontWeight: '600' },
  empty: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: spacing.xxl },
  skeleton: { height: 84, borderRadius: radius.md, borderWidth: 1, marginBottom: spacing.md },
});
