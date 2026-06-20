/**
 * push.ts — Expo push token + notification channel setup.
 *
 * v1 uses Expo Push (least infra; the DB outbox in db/v2/28 posts to
 * exp.host). The token is registered after login via /dct/devices/register.
 * Notification payloads carry { module, sourceType, sourceId } so a tap can
 * deep-link to the approval — see navigation/linking.ts.
 */
import { Platform } from 'react-native';
import * as Device from 'expo-device';
import * as Notifications from 'expo-notifications';
import Constants from 'expo-constants';

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});

export function platformTag(): 'IOS' | 'ANDROID' {
  return Platform.OS === 'ios' ? 'IOS' : 'ANDROID';
}

let cachedToken: string | null = null;

export async function getPushToken(): Promise<string | null> {
  if (cachedToken) return cachedToken;
  if (!Device.isDevice) return null; // push needs a physical device

  const existing = await Notifications.getPermissionsAsync();
  let status = existing.status;
  if (status !== 'granted') {
    const req = await Notifications.requestPermissionsAsync();
    status = req.status;
  }
  if (status !== 'granted') return null;

  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('default', {
      name: 'i-Finance',
      importance: Notifications.AndroidImportance.HIGH,
      lightColor: '#C74634',
    });
  }

  const projectId = Constants.expoConfig?.extra?.eas?.projectId;
  try {
    const token = await Notifications.getExpoPushTokenAsync(projectId ? { projectId } : undefined);
    cachedToken = token.data;
    return cachedToken;
  } catch {
    return null;
  }
}

export type PushDeepLink = { module?: string; sourceType?: string; sourceId?: string | number };

export function extractDeepLink(
  response: Notifications.NotificationResponse | null,
): PushDeepLink | null {
  const data = response?.notification.request.content.data as PushDeepLink | undefined;
  if (!data) return null;
  return { module: data.module, sourceType: data.sourceType, sourceId: data.sourceId };
}
