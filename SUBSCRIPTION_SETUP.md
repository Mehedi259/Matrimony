# Subscriptions — store setup checklist

## Status (15 Nov 2026)
- Apple: DPLA accepted; group "AMM Premium" (22581587); Annual 6835074608 (£124.99), Monthly
  6835074665 (£14.99), consumable 6835074892 (£4.99); en-US/en-GB localizations; 175 countries;
  review screenshot uploaded; Server Notifications V2 set; shared secret generated
  (backend/iap-secrets.local.env). Products verified loading via StoreKit in Simulator.
  Remaining: attach the 3 products to the next app version and submit with a build containing IAP code.
- Google: app created (4973011861596257645); internal testing release 1 (1.0.0) published (no testers yet).
  Active: amm_premium_monthly (base plan `monthly`, £14.99), amm_premium_annual (base plan `annual`,
  £124.99), one-time amm_topup_3_connections (option `buy`, £4.99). Upload key:
  android/app/upload-keystore.jks + android/key.properties (git-ignored — BACK THEM UP).
  Google Cloud: project `amm-play-billing` (org 264200695553), Play Android Developer API enabled,
  service account amm-play-verifier@amm-play-billing.iam.gserviceaccount.com invited in Play Console
  (view app info, view financial data, manage orders & subscriptions).
  BLOCKED: org policy `iam.disableServiceAccountKeyCreation` forbids creating its JSON key, and
  admin@ has no org-level IAM access. A Workspace super admin must grant Organisation Policy
  Administrator, then override that policy for project amm-play-billing only (or use Workload
  Identity Federation — backend accepts either via GOOGLE_PLAY_SERVICE_ACCOUNT_FILE).
  Also remaining: RTDN (step 7), license testers (step 8).
- iOS build note: `flutter build ios --simulator` fails on this Mac (lipo arch check); use
  `xcodebuild ... -destination id=<sim> ARCHS=arm64` instead.

The app (`in_app_purchase`) and backend (`subscriptions` app) are wired up. These are the
store-side steps that make purchases work. **Product IDs must match exactly.**

| Product | ID | Type | Price |
|---|---|---|---|
| Monthly | `amm_premium_monthly` | Auto-renewable subscription, 1 month | £14.99 / £15 tier |
| Annual | `amm_premium_annual` | Auto-renewable subscription, 1 year | £124.99 / £125 tier |
| Pay as you go | `amm_topup_3_connections` | Consumable / one-time product | £4.99 / £5 tier |

Bundle ID / package name: `com.muslimmatchmaker.app`

---

## Apple — App Store Connect

1. **Business → Agreements**: the *Paid Apps* agreement must be **Active** (account holder
   adds bank + tax info). Products won't load in the app until it is.
2. **App → Monetization → Subscriptions**: create subscription group **"AMM Premium"**.
   - Add `amm_premium_monthly` (1 month) and `amm_premium_annual` (1 year) to the group.
   - For each: price (UK base, auto-equalise other countries), at least one localization
     (display name + description), review screenshot of the paywall, review notes.
   - Group localization: display name "AMM Premium".
3. **App → Monetization → In-App Purchases**: create consumable `amm_topup_3_connections`
   ("3 Extra Connections"), price £4.99/£5, localization, review screenshot.
4. **App → App Information → App-Specific Shared Secret → Manage → Generate** → copy it into
   backend env `APPLE_SHARED_SECRET`.
5. **App → App Information → App Store Server Notifications**: Version 2,
   Production + Sandbox URL: `https://<api-domain>/api/subscriptions/apple/notifications/`
6. **Xcode**: Runner target → Signing & Capabilities → **+ In-App Purchase**.
7. When submitting the next version, attach the 3 products to that version
   ("In-App Purchases and Subscriptions" section) so they're reviewed together.
8. Testing: TestFlight builds use the sandbox automatically (backend falls back to sandbox).

## Google — Play Console

1. **Create app** (none exists yet): name "A Muslim Matchmaker", App, Free, declarations.
2. **Upload a build** containing the billing library to an Internal testing track
   (`flutter build appbundle`). Play won't allow creating products until a billing build is uploaded.
3. **Setup → Payments profile** must be set up for the organisation (merchant account).
4. **Monetize → Products → Subscriptions**:
   - `amm_premium_monthly` → base plan ID `monthly`, auto-renewing, 1 month, £15 → Activate.
   - `amm_premium_annual` → base plan ID `annual`, auto-renewing, 1 year, £125 → Activate.
5. **Monetize → Products → In-app products** (one-time): `amm_topup_3_connections`, £5 → Activate.
6. **Server verification** (Google Cloud):
   - Create a service account in a Google Cloud project, enable *Google Play Android Developer API*,
     create a JSON key.
   - Play Console → **Users and permissions → Invite** the service account email, app access,
     permissions: *View app information*, *View financial data*, *Manage orders and subscriptions*.
   - Put the JSON on the server; set `GOOGLE_PLAY_SERVICE_ACCOUNT_FILE` (or `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`).
   - Permissions can take up to 24–36 h to start working.
7. **Real-time developer notifications** (optional but recommended):
   - Create Pub/Sub topic, grant `google-play-developer-notifications@system.gserviceaccount.com`
     Publisher; push subscription to `https://<api-domain>/api/subscriptions/google/notifications/?token=<GOOGLE_RTDN_TOKEN>`.
   - Monetization setup → set the topic name.
8. **Setup → License testing**: add tester Gmail accounts so they can buy without being charged.

## Backend deploy

```
python manage.py migrate        # users.0005_user_bonus_requests, subscriptions.0001_initial
```
Set env vars (see `.env.production.example`), restart django + celery worker + celery beat
(beat runs `subscriptions.expire_lapsed_subscriptions` hourly).

## Still to confirm

- Privacy policy URL used on the paywall: `IapProducts.privacyPolicyUrl` in
  `lib/core/constants/iap_products.dart` (currently `https://amuslimmatchmaker.com/privacy-policy`).
