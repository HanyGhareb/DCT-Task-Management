/**
 * I18nProvider — EN/AR with RTL. Mirrors the web `t(key, args)` contract:
 * "{0}", "{1}" placeholders, Latin digits everywhere (per the platform rule).
 *
 * Switching language calls I18nManager.forceRTL; on a real device that needs an
 * app reload to fully re-lay-out — we persist the choice and apply it on boot.
 */
import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { DevSettings, I18nManager } from 'react-native';
import * as SecureStore from 'expo-secure-store';
import * as Updates from 'expo-updates';
import { catalogs, Lang, StringKey } from './strings';

const LANG_KEY = 'ifinance_lang';

interface I18nContextValue {
  lang: Lang;
  isRTL: boolean;
  t: (key: StringKey, args?: (string | number)[]) => string;
  setLang: (lang: Lang) => Promise<void>;
}

const I18nContext = createContext<I18nContextValue | null>(null);

function interpolate(template: string, args?: (string | number)[]): string {
  if (!args || args.length === 0) return template;
  return template.replace(/\{(\d+)\}/g, (_m, i) => {
    const v = args[Number(i)];
    return v === undefined || v === null ? '' : String(v);
  });
}

export function I18nProvider({ children }: { children: React.ReactNode }) {
  const [lang, setLangState] = useState<Lang>(I18nManager.isRTL ? 'ar' : 'en');

  useEffect(() => {
    SecureStore.getItemAsync(LANG_KEY).then((stored) => {
      if (stored === 'en' || stored === 'ar') setLangState(stored);
    });
  }, []);

  const setLang = useCallback(async (next: Lang) => {
    setLangState(next);
    await SecureStore.setItemAsync(LANG_KEY, next);
    const shouldRTL = next === 'ar';
    if (I18nManager.isRTL !== shouldRTL) {
      I18nManager.allowRTL(shouldRTL);
      I18nManager.forceRTL(shouldRTL);
      if (__DEV__) DevSettings.reload();
      else await Updates.reloadAsync();
    }
  }, []);

  const t = useCallback(
    (key: StringKey, args?: (string | number)[]) =>
      interpolate(catalogs[lang][key] ?? catalogs.en[key] ?? key, args),
    [lang],
  );

  const value = useMemo<I18nContextValue>(
    () => ({ lang, isRTL: lang === 'ar', t, setLang }),
    [lang, t, setLang],
  );
  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
}

export function useI18n(): I18nContextValue {
  const ctx = useContext(I18nContext);
  if (!ctx) throw new Error('useI18n must be used within I18nProvider');
  return ctx;
}
