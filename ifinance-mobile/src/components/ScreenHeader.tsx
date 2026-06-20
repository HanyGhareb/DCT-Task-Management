/**
 * ScreenHeader — page title row with optional count chip and right-aligned
 * action (action buttons sit top-right, per the platform convention).
 */
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { useTheme } from '@/theme/ThemeProvider';
import { spacing } from '@/theme/tokens';
import { T } from './ui';

export function ScreenHeader({
  title,
  count,
  right,
}: {
  title: string;
  count?: number;
  right?: React.ReactNode;
}) {
  const { palette } = useTheme();
  return (
    <View style={[styles.row, { borderBottomColor: palette.border, backgroundColor: palette.bg }]}>
      <View style={styles.titleWrap}>
        <T variant="h2">{title}</T>
        {typeof count === 'number' ? (
          <View style={[styles.chip, { backgroundColor: palette.brand }]}>
            <T variant="caption" color="#fff" tabular>
              {count}
            </T>
          </View>
        ) : null}
      </View>
      {right ? <View>{right}</View> : null}
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    borderBottomWidth: 1,
  },
  titleWrap: { flexDirection: 'row', alignItems: 'center' },
  chip: {
    marginStart: spacing.sm,
    minWidth: 22,
    height: 22,
    borderRadius: 11,
    paddingHorizontal: 6,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
