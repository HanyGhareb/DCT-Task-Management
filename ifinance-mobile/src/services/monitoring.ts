import Constants from 'expo-constants';
import * as Sentry from '@sentry/react-native';

const dsn = String(Constants.expoConfig?.extra?.sentryDsn || '');

export function initializeMonitoring(): void {
  Sentry.init({
    dsn,
    enabled: Boolean(dsn) && !__DEV__,
    sendDefaultPii: false,
    tracesSampleRate: 0,
    enableNativeFramesTracking: true,
    beforeSend(event) {
      // Financial request values and free-text comments must never become tags.
      delete event.request;
      return event;
    },
  });
}

export function setMonitoringUser(userId?: number): void {
  Sentry.setUser(userId ? { id: String(userId) } : null);
}

export { Sentry };
