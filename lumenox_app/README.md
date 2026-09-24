# Lumenox Flutter App

Matches the 9 screens you shared: Onboarding → Register → Registered
Successfully → Login → Forgot Password → Sent Successfully → Reset Password
→ Home Dashboard, wired to Firebase Auth + Cloud Firestore.

## Project structure

```
lib/
  main.dart                       # Firebase init + auth-state routing
  firebase_options.dart           # placeholder — regenerate with flutterfire configure
  app_theme.dart                  # colors/gradients matching your screenshots
  models/
    user_model.dart
    effect_model.dart
  services/
    auth_service.dart             # all FirebaseAuth calls
    firestore_service.dart        # all Firestore reads/writes
  screens/
    onboarding_screen.dart        # image 1
    register_screen.dart          # image 2
    registered_success_screen.dart# image 3
    login_screen.dart             # image 4
    forgot_password_screen.dart   # image 5
    forgot_password_sent_screen.dart # image 6
    reset_password_screen.dart    # image 7
    home_screen.dart              # image 9
  widgets/
    feature_pill.dart
    auth_tab_switcher.dart
    effect_card.dart
```

## Run it

1. `flutter pub get`
2. Read **FIRESTORE_SETUP.md** first — it covers creating the Firebase
   project, running `flutterfire configure`, the Firestore data layout,
   security rules, and (importantly) whether you need a separate admin
   website or not.
3. `flutter run`

## Notes

- All screen text, layout, and copy match your screenshots as closely as
  Flutter's widgets allow. Exact pixel values (font sizes, paddings) are
  close approximations — tweak `app_theme.dart` to fine-tune.
- Image 8 (Welcome Back / Login, second variant) is the same screen as
  image 4 — no separate file needed, it's just the same `login_screen.dart`
  in a different app state.
