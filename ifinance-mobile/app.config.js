/* eslint-env node */
const fs = require('fs');
const path = require('path');

const localGoogleServices = path.join(__dirname, 'google-services.json');
const googleServicesFile = process.env.GOOGLE_SERVICES_JSON
  || (fs.existsSync(localGoogleServices) ? './google-services.json' : undefined);

module.exports = {
  expo: {
    name: 'i-Finance',
    slug: 'ifinance-mobile',
    version: '1.2.0',
    orientation: 'portrait',
    scheme: 'ifinance',
    userInterfaceStyle: 'automatic',
    newArchEnabled: true,
    splash: { backgroundColor: '#0F141B', resizeMode: 'contain' },
    assetBundlePatterns: ['**/*'],
    ios: {
      supportsTablet: true,
      bundleIdentifier: 'ae.gov.ifinance.mobile',
      infoPlist: {
        NSFaceIDUsageDescription: 'Unlock i-Finance with Face ID.',
        NSCameraUsageDescription: 'Take a photo for your profile.',
        NSPhotoLibraryUsageDescription: 'Choose a photo for your profile.',
      },
    },
    android: {
      package: 'ae.gov.ifinance.mobile',
      ...(googleServicesFile ? { googleServicesFile } : {}),
      adaptiveIcon: { backgroundColor: '#0F141B' },
      permissions: [
        'android.permission.USE_BIOMETRIC',
        'android.permission.USE_FINGERPRINT',
        'android.permission.CAMERA',
      ],
      blockedPermissions: ['android.permission.RECORD_AUDIO'],
    },
    plugins: [
      'expo-secure-store',
      'expo-local-authentication',
      ['expo-image-picker', {
        photosPermission: 'Choose a photo for your profile.',
        cameraPermission: 'Take a photo for your profile.',
        microphonePermission: false,
      }],
      ['expo-notifications', { color: '#C74634' }],
      'expo-asset',
      'expo-font',
      '@sentry/react-native/expo',
    ],
    runtimeVersion: { policy: 'appVersion' },
    updates: { url: 'https://u.expo.dev/f5421129-423c-4866-94ec-f726776e3a1e' },
    extra: {
      apiBase: process.env.EXPO_PUBLIC_API_BASE
        || 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/dct',
      sentryDsn: process.env.EXPO_PUBLIC_SENTRY_DSN || '',
      eas: { projectId: 'f5421129-423c-4866-94ec-f726776e3a1e' },
    },
    owner: 'hanyghareb',
  },
};
