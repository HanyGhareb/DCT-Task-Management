# prod/03 — Release checklist

## Pre-flight (must all be true)
- [ ] prod/01 done: `28_push_tokens.sql` deployed on PROD, ACL granted, objects VALID.
- [ ] prod/02 done: signed production iOS + Android builds exist.
- [ ] dev/03 smoke test passed on both platforms (against the dev build).
- [ ] `app.json` `extra.apiBase` points at the **production** ORDS base.
- [ ] `extra.eas.projectId` is the real value (not the `00000000-…` placeholder).
- [ ] Version bumped; release notes written.

## Security / compliance
- [ ] Session token stored only in Keychain/Keystore (expo-secure-store) — verified.
- [ ] No secrets in the bundle (`apiBase` is public; there are no API keys client-side).
- [ ] Network ACL is host-scoped to `exp.host` only.
- [ ] Privacy declarations completed: camera (profile photo), notifications, Face ID.
  - iOS: `NSFaceIDUsageDescription`, `NSCameraUsageDescription`,
    `NSPhotoLibraryUsageDescription` are set in `app.json`.
  - Store privacy form: data collected = account identifiers (for auth); no tracking.

## Store / MDM listing assets (if Path B)
- [ ] App name, short + full description (EN + AR).
- [ ] Icon (1024²) and screenshots (per required device sizes), light + dark.
- [ ] Support URL + privacy policy URL.
- [ ] Category: Business / Finance. Content rating questionnaire.

## Rollout
- [ ] Start staged: TestFlight / Play **internal testing** (or MDM pilot group) first.
- [ ] Verify push, login, and one real approval on a production device.
- [ ] Expand to the full audience after the pilot is clean.

## Post-release monitoring
- [ ] Watch `prod.dct_push_outbox` for a rising `FAILED` count (ACL/token issues).
- [ ] Periodically prune dead tokens: Expo returns `DeviceNotRegistered` for
      uninstalled apps — a future enhancement can auto-call
      `dct_push_pkg.unregister` from the Expo receipt; for now they simply stop
      receiving and can be cleaned manually.
- [ ] Track EAS build health + crash reports (add Sentry/`expo-error-reporter` later).

## Rollback
- App: re-submit the previous build, or `eas update` a JS fix for non-native bugs.
- Backend: prod/01 "Rollback" section (drops are safe; trigger drop stops new pushes).

## Done when
- The app is live to the intended audience, push works on production, and the
  deploy is recorded in `ifinance-mobile/docs/deployment-notes.md` and the
  CLAUDE.md Module Status row is flipped to ✅.
