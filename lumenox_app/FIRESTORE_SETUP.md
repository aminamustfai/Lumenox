# Lumenox – Firebase/Firestore Setup Guide

## 1. Create the Firebase project

1. Go to https://console.firebase.google.com → **Add project**.
2. Inside the project, enable:
   - **Authentication** → Sign-in method → enable **Email/Password**.
   - **Firestore Database** → Create database → start in **production mode**.
3. Install tooling once on your machine:
   ```
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   ```
4. From the Flutter project root:
   ```
   flutterfire configure
   ```
   Pick your project, tick Android (and iOS if needed). This **overwrites**
   `lib/firebase_options.dart` with your real keys — don't hand-edit that file.
5. `flutter pub get`, then run the app.

## 2. Firestore data structure (what actually gets saved, and where)

```
users (collection)
  {uid} (document)                <- one doc per registered user
      fullName: "Charlott"
      email: "charlott@mail.com"
      photoUrl: null
      createdAt: "2026-07-07T09:00:00.000Z"

      effects (sub-collection)     <- the cards on the Home screen
        {effectId} (document)
            name: "Evening Chill"
            effectType: "Breathe"
            colors: [4294901760, 4278255360, 4278190335]   // ARGB ints
            zones: ["Front Yard", "Back Yard", "Roofline"]
            upTime: "5:30 PM"
            offTime: "6:30 AM"
            isOn: true
            isFavorite: false
            lastUsedAt: <Timestamp>
```

Why `effects` lives *under* `users/{uid}` and not as a top-level collection:
each person's lighting recipes are private to their own account, and this
shape means your security rules (below) are a single simple line instead of
per-document ownership checks.

## 3. Security rules (Firestore → Rules tab)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;

      match /effects/{effectId} {
        allow read, write: if request.auth != null && request.auth.uid == uid;
      }
    }
  }
}
```

This means: a signed-in user can only ever read/write their **own**
`users/{uid}` document and their own `effects` sub-collection. No one can
read anyone else's data through the app.

## 4. Seeding test data (so Home screen isn't empty)

Easiest way for testing: open **Firestore Console → users/{your uid} →
Start collection → effects**, and add a document by hand with the fields
above. You don't need any code to do this for testing.

## 5. The "Reset your password" screen (image 7) — one important detail

`sendPasswordResetEmail()` (used by the "We've got your back" screen) makes
Firebase email a link that, **by default, opens a Firebase-hosted web page**
in the browser — not your Flutter app. If you want the in-app "Reset your
password" screen (image 7) to actually be reached from that email link, you
have two options:

- **Simplest**: let the Firebase-hosted web page handle the reset (skip
  building image 7 in-app entirely). Most apps do this — zero extra setup.
- **Full in-app flow**: configure `ActionCodeSettings` with your own domain
  and set up **Firebase Dynamic Links** (or Android App Links / iOS
  Universal Links) so the link opens your app and hands you the `oobCode`
  query parameter, which you then pass into `ResetPasswordScreen(oobCode: ..)`.
  This is a real, moderately involved setup step (verified domain +
  intent-filter/associated-domains config) — happy to walk through it
  separately if you want the fully in-app version.

## 6. Do you need a separate "admin panel" website? (your actual question)

Short answer: **no, not to start.** Firestore is just a database — it has no
built-in UI of its own. You have three realistic options, in order of effort:

**Option A — Firebase Console as your admin panel (recommended to start)**
The Firestore Console (console.firebase.google.com → Firestore Database) lets
you manually view, add, edit, and delete any document — users, effects,
anything. This *is* an admin panel, Google already built it for you. For a
solo developer or small MVP, this is genuinely enough. No extra code needed.

**Option B — Cloud Functions for specific automated tasks**
If you need something to happen automatically (e.g. "delete a user's data
when they delete their account", "send a notification when isOn changes"),
write a small Cloud Function instead of a whole admin site.

**Option C — Build a real admin web app (only if you need this)**
You'd need this only if non-technical staff must manage data regularly
(e.g. approving "Community Themes" submissions, moderating content, managing
many users' schedules at once) and the raw Console is too fiddly for them.
In that case, the lightest option is a small **Flutter Web** app that reuses
the exact same `AuthService` / `FirestoreService` classes already in this
project, with a simple `role: "admin"` field checked on the user document
before showing admin screens. This is a separate, smaller project — I can
scaffold it if/when you actually need it, but I'd suggest not building it
until Option A stops being enough.

**Bottom line for now:** wire up the app with the code in this project,
manage/inspect data via the Firebase Console while testing, and only invest
in a custom admin site later if a non-technical person needs to manage data
on an ongoing basis.
