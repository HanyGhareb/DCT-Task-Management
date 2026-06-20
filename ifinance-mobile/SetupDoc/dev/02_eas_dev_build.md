# dev/02 — EAS dev build (internal)

> New to Expo? Read **"Background — Expo, Expo Go & EAS"** in
> [../README.md](../README.md) first.

Goal: an installable **development build** of the app on a real iPhone + Android
phone. Push, biometrics, and secure-store do **not** work in Expo Go — a dev
build is mandatory.

## Accounts you need (one-time)
> **Create these first** following [../00_accounts_setup.md](../00_accounts_setup.md).
> The steps below assume the accounts already exist and just link them to EAS.

| Account | Why | Cost |
|---|---|---|
| Expo (expo.dev) | EAS builds + Expo Push | Free tier is enough for dev |
| Apple Developer | iOS device builds + APNs push | $99/yr (needed even for dev push) |
| Google + Firebase | Android FCM push | Free |

> No-Apple-account shortcut for iOS: run on the **iOS Simulator** (no push, no
> biometric) via `eas build --profile development --platform ios` with
> `"ios": { "simulator": true }` (already set in `eas.json`). Android can build
> free without any paid account.

## Step 1 — Install tooling + log in
```powershell
npm install -g eas-cli
cd ifinance-mobile
npm install
eas login            # your Expo account
```

## Step 2 — Link the project (sets the real projectId)
```powershell
eas init
```
This writes a real `extra.eas.projectId` + `owner` into `app.json`.

> **Gotcha:** if `app.json` still has the placeholder `projectId`
> (`00000000-0000-…`), `eas init` errors with *"Experience with id … does not
> exist."* Remove the `extra.eas.projectId` line first, then re-run `eas init`
> (it recreates the field with the real id). Already handled in this repo.

## Step 3 — Push credentials
Expo Push routes through FCM (Android) and APNs (iOS). Let EAS manage them:
```powershell
eas credentials
```
- **Android** → "Push Notifications: FCM V1" → upload the Firebase service-account
  JSON (create a free Firebase project, add an Android app with package
  `ae.gov.ifinance.mobile`, download the service account from Project Settings →
  Service accounts).
- **iOS** → "Push Notifications Key (APNs)" → let EAS create/upload the `.p8` key
  (needs the Apple Developer account).

## Step 4 — Build

> **MONOREPO GOTCHA (must set every new terminal):** `ifinance-mobile/` lives
> inside the larger `DCT-Task-Management` git repo. By default EAS packages the
> **whole git repo** (and fails on locked files like `otbi-atd/.otbi_runner.lock`
> → `EBUSY resource busy or locked`). Set this **before** building so EAS archives
> only the app folder:
> ```powershell
> $env:EAS_NO_VCS=1
> ```
> `EAS_NO_VCS=1` makes EAS archive just the `eas.json` directory (still honoring
> `.gitignore`). The env var lasts only for the current terminal session.

```powershell
$env:EAS_NO_VCS=1   # required in this repo (see gotcha above)

# Android dev build (free, no Apple needed):
eas build --profile development --platform android

# iOS dev build (needs Apple Developer account):
eas build --profile development --platform ios
```
- First Android dev build asks **"install expo-dev-client?" → Y** (dev builds run
  in the dev-client launcher, not Expo Go).
- **"Generate a new Android Keystore?" → Yes** (EAS stores + reuses it).
- EAS returns a **download/QR link** per build (also on expo.dev → project →
  Builds). That link **is the installable app** — reusable anytime, no rebuild.

## Step 5 — Install on devices
After the build, the CLI asks **"Install and run on an emulator?"**:
- **`n`** + install on a **real phone** (recommended) — open the build link / scan
  the QR **on the phone** → download → install (allow "install from unknown
  sources" once). Real device = real push + biometrics.
- **`Y`** — only if an Android Studio emulator is set up (needs a Google-Play
  image for push).
- **iOS**: install via the EAS link; the device must be registered in your Apple
  account (`eas device:create` then re-build), or use TestFlight (see prod/02).

> First launch shows the **dev-client** screen briefly; since no local Metro server
> is running it loads the bundled JS and goes straight to the **i-Finance login**.

## Step 6 — Point at the right backend (optional)
`app.json` → `extra.apiBase` defaults to production ADB ORDS. For a separate dev
ORDS, change it and rebuild (or override at runtime via an `.env` if you add one).

## Done when
- The app launches on a physical phone, shows the login screen, and you can sign
  in with a test user.
- Next: **dev/03_on_device_test.md**.
