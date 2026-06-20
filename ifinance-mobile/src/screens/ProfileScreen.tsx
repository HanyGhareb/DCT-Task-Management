/**
 * ProfileScreen — identity card, camera/library photo upload (raw binary),
 * language toggle (EN/AR), and sign out.
 */
import React, { useState } from 'react';
import { Alert, Pressable, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Image } from 'expo-image';
import * as ImagePicker from 'expo-image-picker';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useSession } from '@/state/session';
import { uploadPhoto } from '@/api/profile';
import type { ApiError } from '@/api/types';
import { useWriteQueue } from '@/state/writeQueue';
import type { RootStackParamList } from '@/navigation/types';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import { radius, spacing } from '@/theme/tokens';
import { Badge, Button, Card, T } from '@/components/ui';
import { ScreenHeader } from '@/components/ScreenHeader';

export function ProfileScreen() {
  const { palette } = useTheme();
  const { t, lang, setLang } = useI18n();
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const session = useSession((s) => s.session);
  const signOut = useSession((s) => s.signOut);
  const patchSession = useSession((s) => s.patchSession);
  const queuedCount = useWriteQueue((s) => s.items.length);
  const [uploading, setUploading] = useState(false);
  const [localPhoto, setLocalPhoto] = useState<string | null>(null);

  const name = (lang === 'ar' && session?.displayNameAr) || session?.displayName || '—';
  const initials = (session?.displayName || '?')
    .split(/\s+/)
    .map((p) => p[0])
    .slice(0, 2)
    .join('')
    .toUpperCase();
  const roles = (session?.rolesCsv || '').split(',').filter(Boolean);

  const pickAndUpload = async () => {
    const perm = await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (!perm.granted) {
      Alert.alert(t('profile.changePhoto'), t('profile.photoPermission'));
      return;
    }
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ['images'],
      allowsEditing: true,
      aspect: [1, 1],
      quality: 0.6,
    });
    if (result.canceled || !result.assets?.length) return;
    if (!session?.userId) {
      Alert.alert(t('err.generic'), t('err.generic'));
      return;
    }
    const asset = result.assets[0];
    // Show the picked image immediately so the user sees it even while the
    // upload runs (or if the upload later fails).
    setLocalPhoto(asset.uri);
    setUploading(true);
    try {
      const res = await fetch(asset.uri);
      const blob = await res.blob();
      const mime = asset.mimeType || 'image/jpeg';
      const fname = asset.fileName || `photo.${mime.split('/')[1] || 'jpg'}`;
      await uploadPhoto(session.userId, blob, fname, mime);
      patchSession({ photoUrl: asset.uri });
    } catch (e) {
      // Keep the local preview; surface the upload failure.
      Alert.alert(t('profile.uploadFailed'), (e as ApiError).message);
    } finally {
      setUploading(false);
    }
  };

  const photo = localPhoto || session?.photoUrl;

  return (
    <SafeAreaView edges={['top']} style={[styles.safe, { backgroundColor: palette.bg }]}>
      <ScreenHeader title={t('profile.title')} />
      <View style={{ padding: spacing.lg }}>
        <Card>
          <View style={styles.idRow}>
            <Pressable onPress={pickAndUpload} hitSlop={8} accessibilityLabel={t('profile.changePhoto')}>
              {photo ? (
                <Image
                  source={{ uri: photo }}
                  style={styles.avatar}
                  contentFit="cover"
                  cachePolicy="none"
                  transition={150}
                />
              ) : (
                <View style={[styles.avatar, styles.avatarFallback, { backgroundColor: palette.brand }]}>
                  <T variant="h2" color="#fff">
                    {initials}
                  </T>
                </View>
              )}
              <View style={[styles.cam, { backgroundColor: palette.surface, borderColor: palette.border }]}>
                <Ionicons name={uploading ? 'hourglass' : 'camera'} size={14} color={palette.text} />
              </View>
            </Pressable>
            <View style={{ flex: 1, marginStart: spacing.lg }}>
              <T variant="title">{name}</T>
              {session?.email ? (
                <T variant="caption" color={palette.textMuted} style={{ marginTop: 2 }}>
                  {session.email}
                </T>
              ) : null}
              {session?.orgName ? (
                <T variant="caption" color={palette.textMuted} style={{ marginTop: 2 }}>
                  {session.orgName}
                </T>
              ) : null}
            </View>
          </View>

          <Button
            label={t('profile.changePhoto')}
            variant="secondary"
            icon="camera"
            loading={uploading}
            onPress={pickAndUpload}
            style={{ marginTop: spacing.md }}
          />
          {/* TEMP diagnostic — confirms the picker returned a URI into state.
              Remove once photo display is confirmed working. */}
          {localPhoto ? (
            <T variant="caption" color={palette.textMuted} style={{ marginTop: 6 }}>
              picked: …{localPhoto.slice(-28)}
            </T>
          ) : null}

          {roles.length ? (
            <View style={styles.roles}>
              {roles.map((r) => (
                <View key={r} style={[styles.rolePill, { backgroundColor: palette.surfaceAlt, borderColor: palette.border }]}>
                  <T variant="caption" color={palette.textMuted}>
                    {r}
                  </T>
                </View>
              ))}
            </View>
          ) : null}
        </Card>

        <Card>
          <T variant="label" color={palette.textMuted} style={{ marginBottom: spacing.sm }}>
            {t('profile.language')}
          </T>
          <View style={styles.langRow}>
            <Button
              label="English"
              variant={lang === 'en' ? 'primary' : 'secondary'}
              style={{ flex: 1, marginEnd: spacing.sm }}
              onPress={() => setLang('en')}
            />
            <Button
              label="العربية"
              variant={lang === 'ar' ? 'primary' : 'secondary'}
              style={{ flex: 1 }}
              onPress={() => setLang('ar')}
            />
          </View>
        </Card>

        <Card onPress={() => nav.navigate('Outbox')}>
          <View style={styles.linkRow}>
            <Ionicons name="cloud-upload-outline" size={20} color={palette.textMuted} />
            <T variant="title" style={{ flex: 1, marginStart: spacing.md }}>
              {t('outbox.link')}
            </T>
            {queuedCount ? (
              <Badge label={String(queuedCount)} color="#fff" bg={palette.brand} />
            ) : null}
            <Ionicons name="chevron-forward" size={18} color={palette.textMuted} style={{ marginStart: spacing.sm }} />
          </View>
        </Card>

        <Button
          label={t('profile.logout')}
          variant="danger"
          icon="log-out"
          onPress={() =>
            Alert.alert(t('profile.title'), t('profile.confirmLogout'), [
              { text: t('common.cancel'), style: 'cancel' },
              { text: t('profile.logout'), style: 'destructive', onPress: () => void signOut() },
            ])
          }
          style={{ marginTop: spacing.sm }}
        />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1 },
  idRow: { flexDirection: 'row', alignItems: 'center' },
  avatar: { width: 64, height: 64, borderRadius: radius.pill },
  avatarFallback: { alignItems: 'center', justifyContent: 'center' },
  cam: {
    position: 'absolute',
    bottom: -2,
    end: -2,
    width: 24,
    height: 24,
    borderRadius: 12,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  linkRow: { flexDirection: 'row', alignItems: 'center' },
  roles: { flexDirection: 'row', flexWrap: 'wrap', marginTop: spacing.md, gap: 6 },
  rolePill: { paddingHorizontal: 8, paddingVertical: 3, borderRadius: 999, borderWidth: 1 },
  langRow: { flexDirection: 'row' },
});
