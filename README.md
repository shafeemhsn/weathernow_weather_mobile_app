# WeatherNow

WeatherNow is a Flutter app for checking live weather and a 5-day forecast from OpenWeather. You can search any city, use your current location, save favorites, review recent searches, and pick your preferred units.

## What you can do
- Search by city or tap the location button to fetch weather for your current position.
- See current conditions with temperature, feels-like, humidity, pressure, visibility, and wind (with unit conversions).
- Open a 5-day forecast from any city and toggle it as a favorite for quick access.
- Manage favorites with search/filter, remove, and jump to details or forecast.
- View and clean up a recent-search history (deduped, capped at 10).
- Adjust units (C/F, wind in km/h, m/s, or mph) and clear favorites/recent/all data from Settings.
- Built-in error states for missing/invalid API key, offline mode, and unknown cities.

## Architecture & tech
- Flutter 3.10+ with `flutter_riverpod` + ChangeNotifier view models.
- Networking via `dio` against `api.openweathermap.org/data/2.5`.
- Location via `geolocator`.
- Local persistence with `shared_preferences` (favorites, recents, settings).
- Feature-first folders under `lib/features/**` (data/domain/presentation/state); shared utilities in `lib/core`; routing in `lib/router/app_router.dart`; env config in `lib/config/env.dart`.

## Setup
1) Install Flutter SDK 3.10+ and set up a simulator/device.
2) Install packages: `flutter pub get`
3) Provide an OpenWeather API key (recommended):
   - Dart define: `flutter run --dart-define=OPENWEATHER_API_KEY=YOUR_KEY`
   - Or environment variable before running: `set OPENWEATHER_API_KEY=YOUR_KEY` (Windows) / `export OPENWEATHER_API_KEY=YOUR_KEY` (macOS/Linux)
   - A fallback key lives in `lib/config/env.dart` for local testing; replace it for real use.
4) Run the app: `flutter run` (optionally `-d <deviceId>`)
5) Allow location permissions when prompted to enable the location shortcut and current-location card.

## Tests & quality
- Run tests: `flutter test`
- Static analysis: `flutter analyze`

## Data & behavior notes
- Recent searches are deduplicated and capped at 10 entries.
- Favorites and settings persist locally and can be cleared from Settings.
- Weather requests include the configured units; defaults to metric unless changed in Settings.
