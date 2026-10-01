Copy `dev.example.json` to `dev.json` (git-ignored) and run:

```bash
flutter run --dart-define-from-file=env/dev.json
```

- Android emulator reaches the host machine at `http://10.0.2.2:8080/api/v1`.
- iOS simulator and web use `http://localhost:8080/api/v1`.
- Only the Stripe *publishable* key belongs here; the secret key lives on the server.
