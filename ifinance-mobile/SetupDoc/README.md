# i-Finance Mobile — Setup Documentation

> **Internal app:** distributed only to **DCT employees** via the org's **MDM** —
> it is **not** published on the public App Store / Play Store. Production
> distribution uses Apple Business Manager (Custom Apps) for iOS and Managed
> Google Play / direct AAB for Android (see `prod/02`).

## Background — Expo, Expo Go & EAS

New to the tooling? Read this first.

- **Expo** — a framework + cloud toolchain on top of React Native. It bundles
  ready-made native modules (camera, push notifications, secure store,
  biometrics), a simple `expo` CLI, and **EAS** to build the iOS/Android apps in
  the cloud and push over-the-air (OTA) JS updates. You do **not** need a Mac,
  Xcode, or Android Studio set up locally to ship. Our app is an Expo project.
- **Expo Go** — a free pre-built "sandbox" app you install from the App Store /
  Play Store. Scan a QR code and your JS loads inside it instantly, with **zero
  build step** — great for quick UI iteration.
- **EAS (Expo Application Services)** — Expo's cloud service that produces the
  signed iOS/Android binaries (`eas build`), submits them to the stores
  (`eas submit`), and ships OTA updates (`eas update`).

**Why we still need a real build (not Expo Go):** Expo Go only contains the
native modules Expo bundles into it. Our app uses **push notifications,
biometrics, and secure-store with custom native config** — these require a
**development build** (a custom build of *our* app via EAS), not Expo Go. That is
why `dev/02_eas_dev_build.md` builds with EAS instead of just scanning into
Expo Go.

| Capability | Expo Go | Dev build (EAS) |
|---|---|---|
| Setup effort | none, instant (QR scan) | one cloud build |
| UI / logic testing | ✅ | ✅ |
| Push notifications | ❌ | ✅ |
| Face ID / fingerprint | ❌ | ✅ |
| Secure store (Keychain/Keystore) | ❌ | ✅ |

---

Everything needed to take `ifinance-mobile` (App 209) from source to a running
app, split by stage:

```
SetupDoc/
  00_accounts_setup.md          create the required accounts (Expo / Apple / Google / Play)
  dev/    ← get it running on YOUR test devices (internal dev build)
    01_backend_db_deploy.md     deploy db/v2/28 + exp.host ACL (test ADB)
    02_eas_dev_build.md         Expo account, projectId, push creds, dev build
    03_on_device_test.md        install + end-to-end smoke-test checklist
  prod/   ← ship to the org (production + stores / MDM)
    01_backend_db_deploy.md     deploy db/v2/28 + ACL on PROD ADB
    02_eas_prod_build_submit.md  production build + App Store / Play / MDM
    03_release_checklist.md      pre-flight, signing, rollout, rollback
```

## Who does what
| Task | Owner | Needs |
|---|---|---|
| DB deploy (`28_push_tokens.sql`) | DBA / you | SQLcl `prod_mcp`, ADMIN for the ACL |
| Expo / EAS account + builds | Mobile dev | Expo account |
| iOS signing + APNs | Mobile dev | Apple Developer account ($99/yr) |
| Android signing + FCM | Mobile dev | Google account (+ Play Console $25 once for store) |
| On-device testing | QA / you | 1 physical iPhone + 1 Android phone |

## Order of operations
1. **00_accounts_setup** (one-time — create the Expo / Apple / Google accounts).
2. **dev/01** → **dev/02** → **dev/03** (prove the MVP end-to-end internally).
3. Then **prod/01** → **prod/02** → **prod/03** for the org rollout.

> The app code is already `tsc`- and Metro-clean. These docs cover only the
> environment/account setup that can't be done from source.
