# CLAUDE.md — TraceMemories

This file provides context for AI assistants working on the TraceMemories codebase.

## Project Overview

TraceMemories is a Flutter mobile app that visualizes daily life through location tracking and photo mapping. It records GPS traces as curves on a dark 3D map, places geotagged photos, and lets users scrub through their day via a timeline slider. A daily summary feature generates poetic reflections on the user's journey.

**Tagline:** あなたの日々を、地図に刻む (Carve your days into a map)

## Tech Stack

- **Language:** Dart (SDK ^3.10.7)
- **Framework:** Flutter with Material Design 3
- **Maps:** mapbox_maps_flutter (native iOS/Android), flutter_map + OpenStreetMap (web fallback)
- **Location:** geolocator + permission_handler
- **Photos:** photo_manager
- **UI/Animation:** flutter_animate, google_fonts (Inter)
- **Env:** flutter_dotenv (.env file for API tokens)
- **Storage:** sqflite, path_provider (prepared for future use)
- **Linting:** flutter_lints (analysis_options.yaml)

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run static analysis / linting
flutter analyze

# Run tests
flutter test

# Deep clean (use when builds break)
flutter clean && flutter pub get

# Run on specific platform
flutter run -d chrome        # Web demo mode
flutter run -d ios            # iOS simulator/device
flutter run -d android        # Android emulator/device
```

## Project Structure

```
lib/
├── main.dart                 # App entry point, initialization
├── screens/
│   ├── map_screen.dart       # Native map screen (iOS/Android via Mapbox)
│   └── web_map_screen.dart   # Web demo mode (OpenStreetMap fallback)
├── widgets/
│   ├── glass_container.dart  # Glassmorphism base component
│   ├── photo_card.dart       # Photo memory card display
│   ├── timeline_bar.dart     # Day timeline scrubber
│   └── summary_dialog.dart   # Daily summary dialog
├── services/
│   ├── location_service.dart # GPS tracking via geolocator streams
│   ├── photo_service.dart    # Photo library integration
│   ├── summary_service.dart  # Template-based poetic summary generation
│   └── demo_data.dart        # Mock data for web demo mode
└── theme/
    └── app_theme.dart        # Design system: colors, glassmorphism, typography
```

### Platform directories

`android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/` — Platform-specific build configurations. Generally don't need changes unless adding native plugins or platform permissions.

## Architecture & Patterns

### State management
- Screens use **StatefulWidget** with local state
- Services are instantiated directly in screens (no DI container)
- Reactive data flow via **Dart Streams** (e.g., `LocationService.pathStream`)

### Widget composition
- Screens use `Stack` for layered UI (map base + overlays)
- Reusable widgets (`GlassContainer`, `PhotoCard`, `TimelineBar`) are pure presentation — no business logic
- Configuration via constructor parameters only

### Map rendering
- Native: `MapboxMap` + `PolylineAnnotationManager` for route drawing
- Web: `FlutterMap` controller + `PolylineLayer` with CartoDB Dark tiles
- Both support animated camera movements (`flyTo()`)

### Timeline system
- Single progress float (0.0–1.0) controls route visibility and photo filtering
- Route polyline redrawn on each frame based on progress
- Photo cards positioned via `pixelForCoordinate()` (lat/lng → screen pixels)

## Design System

### Colors (dark glassmorphism theme)
- Primary dark: `#0F172A` — Secondary dark: `#1E293B` — Surface: `#334155`
- Accent blue: `#38BDF8` — Accent purple: `#818CF8`
- Text: `#FFFFFF` (primary), `#94A3B8` (secondary)

### Glassmorphism constants
- Background: 10% white overlay — Border: 20% white — Blur: 12px
- Corner radii: 20px (containers), 12px (cards), 8px (small elements)

### Typography
- Font family: Inter via google_fonts
- Material Design 3 text scales

## Secrets & Environment

**Critical:** Never hardcode API keys in source code.

- `.env` — Mapbox tokens (`MAPBOX_PUBLIC_TOKEN`, `MAPBOX_SECRET_TOKEN`). Loaded by flutter_dotenv at startup. Listed as a Flutter asset in pubspec.yaml.
- `android/gradle.properties` — `MAPBOX_DOWNLOADS_TOKEN` for Mapbox SDK access
- `ios/MapboxSecrets.plist` — iOS Mapbox authentication
- All secret files are in `.gitignore` and must never be committed

The web demo mode works without `.env` by falling back to OpenStreetMap tiles.

## Code Conventions

- Follow **Flutter/Dart official style guide** (enforced by flutter_lints)
- Use `const` constructors wherever possible for performance
- Null safety enabled (Dart 3.10+)
- File naming: `snake_case.dart`
- Class naming: `PascalCase`
- Private members: underscore prefix (`_currentPath`)

### Folder rules
- `lib/screens/` — Screen-level widgets only
- `lib/widgets/` — Reusable, presentation-only components
- `lib/services/` — Business logic, no UI code
- `lib/theme/` — Design tokens and theme definitions
- `lib/models/` — Data model classes (for future use)

## Git Conventions

### Branching
- `main` — Stable, always working
- `feature/xxx` or `fix/xxx` — Topic branches for development

### Commit messages
Use emoji prefixes:
- `✨` Feature additions
- `🐛` Bug fixes
- `📝` Documentation
- `🚀` Performance / releases
- `🎨` Design changes
- `📖` Documentation overhauls

### Secrets check
Before every commit, verify no `.env`, `gradle.properties`, `key.properties`, or `MapboxSecrets.plist` files are staged.

## Testing

- Framework: `flutter_test` (built-in)
- Test files: `test/` directory
- Run: `flutter test`
- Current coverage is minimal — placeholder test in `test/widget_test.dart`
- `flutter analyze` for static analysis (run before committing)

## Documentation

- `README.md` — Project introduction and setup (Japanese)
- `DEVELOPMENT_RULES.md` — Security and workflow rules (Japanese)
- `DEBUG_GUIDE.md` — Debugging, hot reload, troubleshooting tips
- `SUMMARY_PLAN.md` — Implementation plan for AI summary feature
- `docs/privacy_policy.html` — Privacy policy

## Communication

- Primary language for documentation and commit messages: **Japanese** (the project owner communicates in Japanese)
- Code (variables, comments in source) is in **English**
- When proposing significant technical or design changes, present options and get approval before implementing
