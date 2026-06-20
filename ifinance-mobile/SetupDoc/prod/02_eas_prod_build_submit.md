# prod/02 — Production build & distribution

> **This app is internal-only — distributed to DCT employees, NOT on the public
> App Store / Play Store.** ⇒ **Path A (MDM / private) is the chosen path for
> DCT.** Path B (public stores) is kept below for reference only.

Two distribution paths:
- **A. MDM / private (CHOSEN)** — distribute the signed binary to enrolled employee
  devices via the org's MDM, using **Apple Business Manager Custom Apps** (iOS) and
  **Managed Google Play private app** or a direct AAB push (Android). No public
  listing; the app is never publicly searchable.
- **B. Public stores** — Apple App Store + Google Play. Not used for DCT; reference only.

## Accounts (one-time)
> Create accounts per [../00_accounts_setup.md](../00_accounts_setup.md).

| Path | Apple | Google |
|---|---|---|
| **A. MDM/private (CHOSEN)** | Apple Developer **Organization** ($99/yr) + **Apple Business Manager** (free) for Custom Apps | **Managed Google Play** (via your MDM) **or** direct AAB push (no Play Console needed) |
| B. Public store (ref only) | Apple Developer ($99/yr) | Play Console ($25 once) |

> The MDM platform isn't confirmed yet (Intune / Jamf / Android Enterprise / other).
> Steps below are MDM-agnostic — the final "upload the app into the MDM" action is
> done in your MDM's admin console; fill in the exact clicks once the MDM is known.

## Step 1 — Bump version
In `app.json`: raise `expo.version` (e.g. `1.0.0`). EAS auto-increments the
native build number (`autoIncrement` is on in the `production` profile).

## Step 2 — Production build
```powershell
eas build --profile production --platform ios
eas build --profile production --platform android
```
Outputs a signed `.ipa` and `.aab`. EAS manages signing keys (keep them in EAS;
back up via `eas credentials`).

## Step 3a — Distribute privately (Path A — CHOSEN)

### iOS — Apple Business Manager (ABM) Custom App
1. **Enroll the org in Apple Business Manager** (free): https://business.apple.com
   (needs the org's D-U-N-S; link it to the Organization Apple Developer account).
2. In **App Store Connect**, create the app record for `ae.gov.ifinance.mobile`,
   set its availability to **Custom App / unlisted — distribute to your org only**.
3. `eas submit --profile production --platform ios` uploads the build to App Store
   Connect. Submit it as a **Custom App** (light Apple review; never publicly listed).
4. In **ABM → Apps**, the Custom App appears → assign it to your **MDM** (Content
   token / location).
5. In the **MDM admin console**, push the app to the employees' device groups.

### Android — Managed Google Play (private) OR direct AAB via MDM
- **Option 1 — Managed Google Play (private app):** in Play Console publish the
  app to the **private/internal** track restricted to the org, then link it in your
  MDM's Managed Google Play and assign to device groups.
- **Option 2 — Direct push (no Play Console):** download the signed `.aab`/`.apk`
  from the EAS build page and upload it straight into the MDM as a line-of-business
  app. Simplest if you don't want a Play Console account.

> Push (APNs/FCM) works either way — the credentials are baked into the build by
> EAS, independent of the distribution channel.

## Step 3b — Submit to stores (Path B)
```powershell
eas submit --profile production --platform ios       # to App Store Connect / TestFlight
eas submit --profile production --platform android    # to Play Console
```
Then in each console: complete the store listing (see prod/03), attach privacy
details, and roll out (start with TestFlight / Play internal testing).

## Step 4 — Production push sanity
After install on a production device, confirm a real notification arrives
(repeat dev/03 §F against PROD). Watch `prod.dct_push_outbox` for `SENT`.

## Notes
- **OTA updates**: small JS-only changes can ship via `eas update` without a new
  store build (configure `expo-updates` first). Native/permission changes still
  need a full build.
- Keep `bundleIdentifier`/`package` = `ae.gov.ifinance.mobile` stable forever
  (changing it = a brand-new app + lost installs/push tokens).

## Done when
- Signed production builds exist and are distributed (MDM or store).
- Next: **prod/03_release_checklist.md**.
