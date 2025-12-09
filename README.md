# WeatherNow

WeatherNow is a Flutter app that surfaces current conditions and a 5-day forecast from OpenWeather. It supports searching by city, using the device location, saving favorites, and managing recent searches and preferences.

## Features
- Search by city or use the device location to load current weather.
- View rich current conditions (temps, feels-like, humidity, wind, pressure, visibility) with contextual icons.
- 5-day forecast view with quick access from the current weather screen.
- Favorites list with search/filter, quick remove, and one-tap navigation to details or forecast.
- Recent searches (up to 10) on the home screen with swipe-to-remove.
- Settings: toggle °C/°F, wind unit (km/h or mph), auto-location, and notifications toggle; clear favorites/recent/all data.
- Graceful error states for missing API key, offline mode, and unknown cities.

## Tech Stack
- Flutter with Riverpod (`flutter_riverpod`) for state management.
- Networking via `dio` hitting `api.openweathermap.org`.
- Local storage via `shared_preferences` (favorites, recent searches, settings).
- Location via `geolocator`.

## Project Structure
- `lib/app.dart`, `lib/main.dart`: App entry and theming.
- `lib/features/`: Feature folders for weather, favorites, recent_searches, settings, home UI.
- `lib/core/`: Shared constants, networking, database helpers, DI providers, widgets.
- `lib/router/app_router.dart`: Named routes.

## Prerequisites
- Flutter SDK 3.10+.
- OpenWeather API key.

## Setup & Run
1) Install dependencies: `flutter pub get`
2) Provide the API key (preferred):
   - Dart define: `flutter run --dart-define=OPENWEATHER_API_KEY=your_key`
   - Or env var before running: `set OPENWEATHER_API_KEY=your_key` (Windows) / `export OPENWEATHER_API_KEY=your_key` (macOS/Linux)
   - There is a fallback key in `lib/config/env.dart` for local testing; replace it for production.
3) Run on a device/emulator: `flutter run`

Location search requires allowing location services/permissions on the device.

## Testing
- Run the test suite: `flutter test`

## Notes
- Favorites, recent searches, and settings are persisted with `shared_preferences`.
- Weather units default to metric; settings let you switch units.
