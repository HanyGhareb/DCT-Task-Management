# 00 — Create the required accounts (one-time)

Do this **once** before the first build (`dev/02`). These accounts can't be
created from source — a person with org authority must register them. Keep all
credentials in the team password manager, not in the repo.

| # | Account | Needed for | Cost | When |
|---|---|---|---|---|
| 1 | Expo (expo.dev) | EAS builds + Expo Push | Free tier OK | dev + prod |
| 2 | Apple Developer | iOS builds + APNs push | $99/yr (org: Enterprise $299/yr) | iOS only |
| 3 | Google + Firebase | Android FCM push | Free | dev + prod |
| 4 | Apple Business Manager | Private iOS distribution (Custom Apps) | Free | prod (iOS) |
| 5 | Google Play Console | Managed Google Play private app | $25 once | prod (Android) — optional |

> This app is **internal-only** (DCT employees), distributed via **MDM** — not the
> public stores. Android **dev** builds need only #1 and #3; iOS needs #2.
> For production: iOS adds #2 (Organization) + #4 (Apple Business Manager); Android
> needs #5 **only** if using Managed Google Play — a direct AAB push via MDM skips it.

---

## 1. Expo account (required, free)
1. Go to **https://expo.dev** → **Sign Up**. Use a shared org email
   (e.g. a distribution list), not a personal one.
2. Verify the email.
3. (Recommended) Create an **Organization**: Account → **Create Organization**
   → name it e.g. `ifinance` → invite the mobile devs. Builds then belong to the
   org, not one person.
4. Enable **2FA** (Account → Settings → Two-factor auth).
5. CLI login is done later in `dev/02` (`eas login`).

### A personal Expo account is fine
You do **not** need an Expo Organization. A personal/free account gives you EAS
builds, Expo Push, and OTA updates — nothing in this app requires an org. The
Expo account is **not** the app's store identity (that's the bundle/package id
`ae.gov.ifinance.mobile` + the Apple/Google accounts), so using a personal Expo
login locks nothing at the store level.

De-risk it (5 minutes):
- **Sign up with a shared org email** (a distribution list), not a private inbox,
  so the team isn't locked out if you leave.
- **Enable 2FA** and store the login in the **team password manager**.
- **Free-tier note:** there's a monthly cloud-build-minute cap. Usually plenty
  for a small app; if you hit it, wait for the reset or upgrade — no code changes.
- **You can move to an Organization later** with no rebuild: create the org, then
  **Project → Settings → Transfer** the project into it.

> Still prefer **org-owned Apple/Google accounts** (§2–§5) even with a personal
> Expo account — those legally own the published app + push certificates, and
> transferring a *published* app between Apple/Google accounts is far more painful
> than moving an Expo project.

## 2. Apple Developer account (required for iOS)

### Individual vs Organization — which to use when
You can enroll with a **personal Apple ID** (e.g. a yahoo address — it just needs
2FA on). Whether that's OK depends on the stage:

| | Individual (personal Apple ID) | Organization |
|---|---|---|
| Cost | $99/yr | $99/yr ($299/yr Enterprise for MDM) |
| Setup speed | fast, no D-U-N-S | slower (needs legal name + free D-U-N-S) |
| App Store "developer" name | **your personal name** | the **organization** name |
| Team access (App Store Connect roles) | limited | full |
| In-house / MDM distribution (Enterprise) | ❌ not possible | ✅ |
| Good for | **dev + on-device testing now** | **production rollout** |

**Recommendation for this gov app:**
1. **Now (dev/testing):** a personal Apple ID is fine — it unblocks `dev/02`
   immediately.
2. **Before production:** enroll/move to an **Organization** account (the org
   legally owns the app + push certs). Transferring a *published* app between
   Apple accounts is possible but has conditions, so have the org account ready
   **before** the first store/MDM submission.
   - For DCT's **internal-only** distribution, the Org account also unlocks
     **Apple Business Manager → Custom Apps** (the private iOS channel; see
     `prod/02`). Enroll the org in Apple Business Manager (free,
     https://business.apple.com) and link it to this Developer account.
3. Even for the Organization account, log in with a **dedicated org Apple ID**,
   not a personal one, so it isn't tied to an individual who might leave.

### Enrollment steps
1. You need an **Apple ID** with 2FA on. For an org, use a dedicated Apple ID
   owned by the organization.
2. Go to **https://developer.apple.com/programs/enroll**.
3. Choose **Organization** enrollment (needs the org's legal entity name +
   **D-U-N-S number** — request a free D-U-N-S at
   https://developer.apple.com/enroll/duns-lookup if you don't have one). Personal
   enrollment is faster but ties the app to an individual — avoid for a gov app.
4. Pay the **$99/yr** ($299/yr for the Enterprise program if you distribute
   in-house via MDM without the App Store).
5. Wait for approval (hours to a few days for org verification).
6. After approval, accept agreements in **App Store Connect**
   (https://appstoreconnect.apple.com).
7. **APNs key** (push) is created later by EAS in `dev/02` (`eas credentials`) —
   no manual `.p8` work needed, EAS handles it once the account exists.

## 3. Google account + Firebase project (required for Android push)
1. Use/create a shared **Google account** for the org.
2. Go to **https://console.firebase.google.com** → **Add project** → name it
   `ifinance-mobile` → (Analytics optional) → Create.
3. In the project: **Add app → Android**. Set the package name to
   **`ae.gov.ifinance.mobile`** (must match `app.json` → `android.package`).
4. **Download `google-services.json`** — wizard "Download config file" step, OR
   later from **Project Settings (gear) → Your apps → Android app → google-services.json**.
   Save it to **`ifinance-mobile/google-services.json`** and keep
   `"android.googleServicesFile": "./google-services.json"` set in `app.json`.
   This file is REQUIRED so the app can initialize Firebase and obtain a push
   token on Android. (It's the **only** Firebase file we need — you can still
   **skip the "Add Firebase SDK" / Gradle (`build.gradle.kts`, Kotlin DSL vs
   Groovy) steps**; those embed the native SDK, which a managed Expo app doesn't use.)
5. Also get the **FCM V1 service-account JSON** (for Expo's servers to *deliver*):
   **Project Settings → Service accounts → Generate new private key** → download.
   **Treat this as a secret** (password manager); upload it to EAS in `dev/02`
   (`eas credentials` → Android → Google Service Account → FCM V1).
   **Both files are needed:** `google-services.json` (in the build, to *get* a
   token) + the service-account key (in EAS, to *send*).

## 4. Apple Business Manager (free — private iOS distribution)
Needed for production iOS only (DCT's internal Custom App channel). Skip for dev.
1. Enroll the org at **https://business.apple.com** (needs the org legal name +
   the same **D-U-N-S** used for the Apple Developer Org account).
2. After approval, in ABM → **Settings → Apps and Books** (or **Custom Apps**),
   confirm the org can receive Custom Apps.
3. Link ABM to your **MDM** (ABM → Settings → MDM servers / locations) so assigned
   apps flow to devices.
4. The actual app assignment happens in `prod/02` after the build is uploaded as a
   Custom App in App Store Connect.

## 5. Google Play Console (optional — only if using Managed Google Play)
**Skip this if** your MDM pushes the signed `.aab`/`.apk` directly (DCT internal
Path A "Option 2") — no Play Console account is needed at all.

Needed only for **Managed Google Play (private app)** distribution or the public
store path:
1. Go to **https://play.google.com/console** → sign up with the org Google
   account.
2. Choose an **organization** developer account; complete identity verification.
3. Pay the **$25 one-time** fee.
4. Create the app entry (name, default language EN, app/ game = App, free/paid).
   For internal-only, publish to a **private/internal** track restricted to the
   org — never the public production track.

---

## After accounts exist
- Record who owns each account + where the credentials live (password manager).
- Confirm the **package/bundle id** `ae.gov.ifinance.mobile` is reserved/consistent
  across Apple, Firebase, and Play — changing it later means a brand-new app.
- Proceed to **dev/02_eas_dev_build.md** (links these accounts to the project).
