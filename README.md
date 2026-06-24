# Paid Candidate Test: Location Permission + Filter Logic

This is a small isolated Flutter test project. It is not GoShopBlack code and does not contain production credentials.

## Context

The real app has had issues around location permission behavior, iOS permission prompts, and filters showing the wrong business results. This test checks whether you can safely diagnose and fix a similar problem in a small sample.

## What to fix

Open `lib/broken_location_filter_screen.dart`.

Fix the location permission flow and filtering logic without rewriting the whole app.

Expected behavior:

1. When location services are disabled, show a clear message and reset loading state.
2. When permission is `denied`, request permission.
3. When permission is still `denied`, stop loading and show a clear message.
4. When permission is `deniedForever`, stop loading and show a dialog with an option to open app settings.
5. Use `mounted` checks before calling `setState`, `showDialog`, or navigation after async calls.
6. The app should never get stuck on `Locating...`.
7. Filters must be strict:
   - If `Verified only` has zero matches, show zero results, not all businesses.
   - If distance filter has zero matches, show zero results, not all businesses.
   - Combining category + verified + distance must not drop existing filters.
8. Keep the UI simple. The goal is correctness, not redesign.

## Deliverables

Please send one of the following:

- A GitHub repo link with your solution and commit history, or
- A zip file containing the fixed project.

Also include:

1. A short written summary of what was broken.
2. A short written summary of what you changed.
3. Testing notes for iOS and Android.
4. A short screen recording showing the fixed app behavior.
5. A 10–15 minute Loom/video walkthrough of one app you personally built. Please explain:
   - folder structure
   - auth flow
   - location/map logic, if applicable
   - one difficult bug you fixed
   - how you test before release
6. GitHub proof without private access:
   - a public GitHub repo you personally contributed to, or
   - screenshots of commit history from a private project with sensitive info hidden, or
   - a recent PR you opened with code review comments if available.
7. A short safe-onboarding plan for a production repo, covering:
   - branches
   - secrets/environment variables
   - build setup
   - iOS/Android testing
   - PR process
   - rollback plan
   - first 48-hour audit checklist

## Rules

- Do not request GoShopBlack production credentials.
- Do not request signing files, keystore files, private keys, or App Store credentials.
- Do not rewrite the whole sample.
- Do not add unnecessary packages unless you explain why.
- Keep the solution focused on the location and filter bugs.

## Estimated time

2–3 hours.
