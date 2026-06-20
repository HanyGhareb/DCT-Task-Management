/**
 * LoginScreen — credential sign-in against /dct/auth/login.
 * Uncontrolled inputs via refs to avoid keystroke re-renders
 * (react-native-best-practices: js-uncontrolled-components).
 */
import React, { useRef, useState } from 'react';
import {
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  TextInput,
  View,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useSession } from '@/state/session';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { Button, T } from '@/components/ui';
import { radius, spacing } from '@/theme/tokens';
import type { ApiError } from '@/api/types';

export function LoginScreen() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const signIn = useSession((s) => s.signIn);

  const userRef = useRef('');
  const passRef = useRef('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onSubmit = async () => {
    setError(null);
    if (!userRef.current.trim() || !passRef.current) {
      setError(t('login.error'));
      return;
    }
    setBusy(true);
    try {
      await signIn(userRef.current.trim(), passRef.current);
    } catch (e) {
      const err = e as ApiError;
      setError(err.status === 0 ? t('err.network') : t('login.error'));
    } finally {
      setBusy(false);
    }
  };

  return (
    <SafeAreaView style={[styles.safe, { backgroundColor: palette.chromeBg }]}>
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        style={{ flex: 1 }}
      >
        <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
          <View style={[styles.logo, { backgroundColor: palette.brand }]}>
            <Ionicons name="wallet" size={34} color="#fff" />
          </View>
          <T variant="h1" color="#fff" style={{ textAlign: 'center' }}>
            {t('suite.name')}
          </T>
          <T variant="body" color={palette.chromeText} style={{ textAlign: 'center', marginBottom: spacing.xl }}>
            {t('login.title')}
          </T>

          <View style={[styles.card, { backgroundColor: palette.surface, borderColor: palette.border }]}>
            <T variant="label" color={palette.textMuted}>
              {t('login.username')}
            </T>
            <TextInput
              autoCapitalize="characters"
              autoCorrect={false}
              textContentType="username"
              placeholder={t('login.username')}
              placeholderTextColor={palette.textMuted}
              onChangeText={(v) => (userRef.current = v)}
              style={[styles.input, { color: palette.text, borderColor: palette.border, backgroundColor: palette.bg }]}
            />
            <T variant="label" color={palette.textMuted} style={{ marginTop: spacing.md }}>
              {t('login.password')}
            </T>
            <TextInput
              secureTextEntry
              autoCapitalize="none"
              textContentType="password"
              placeholder={t('login.password')}
              placeholderTextColor={palette.textMuted}
              onChangeText={(v) => (passRef.current = v)}
              onSubmitEditing={onSubmit}
              returnKeyType="go"
              style={[styles.input, { color: palette.text, borderColor: palette.border, backgroundColor: palette.bg }]}
            />

            {error ? (
              <View style={[styles.errBox, { backgroundColor: palette.dangerSoft }]}>
                <Ionicons name="alert-circle" size={16} color={palette.danger} />
                <T variant="caption" color={palette.danger} style={{ marginStart: 6, flex: 1 }}>
                  {error}
                </T>
              </View>
            ) : null}

            <Button label={t('login.submit')} onPress={onSubmit} loading={busy} style={{ marginTop: spacing.lg }} />
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  scroll: { flexGrow: 1, justifyContent: 'center', padding: spacing.xl },
  logo: {
    width: 72,
    height: 72,
    borderRadius: radius.lg,
    alignSelf: 'center',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: spacing.lg,
  },
  card: { borderRadius: radius.lg, borderWidth: 1, padding: spacing.xl },
  input: {
    minHeight: 48,
    borderWidth: 1,
    borderRadius: radius.md,
    paddingHorizontal: spacing.md,
    marginTop: 4,
    fontSize: 16,
  },
  errBox: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: spacing.sm,
    borderRadius: radius.sm,
    marginTop: spacing.md,
  },
});
