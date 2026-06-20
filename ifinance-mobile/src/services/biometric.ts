/**
 * biometric.ts — Face ID / Touch ID / fingerprint unlock on relaunch.
 */
import * as LocalAuthentication from 'expo-local-authentication';

export async function isBiometricAvailable(): Promise<boolean> {
  const hasHardware = await LocalAuthentication.hasHardwareAsync();
  const enrolled = await LocalAuthentication.isEnrolledAsync();
  return hasHardware && enrolled;
}

export async function authenticate(prompt: string): Promise<boolean> {
  const available = await isBiometricAvailable();
  // If no biometrics are enrolled, don't lock the user out — allow through.
  if (!available) return true;
  const result = await LocalAuthentication.authenticateAsync({
    promptMessage: prompt,
    fallbackLabel: '',
    cancelLabel: '',
    disableDeviceFallback: false,
  });
  return result.success;
}
