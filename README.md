# Weather App

Flutter mobile app that shows current conditions, 3‑day and hourly forecasts using WeatherAPI. Includes city list browsing, GPS-based weather, map links, and local notifications when rain/snow/storms are expected.

## Requirements Covered
- Current weather with icon, temperature, and condition on the Home screen.
- List of places with filter, live previews, and detail buttons.
- 3‑day forecast screen with visuals and map link.
- Hourly forecast screen.
- Navigation drawer across main flows.
- State management with `provider` and cached city previews.
- GPS-based current location fetch.
- Local notifications for upcoming rain/snow/storm conditions.

## Setup
1) Install Flutter (3.9+ recommended) and an emulator/device with internet access.  
2) Create a WeatherAPI key at https://www.weatherapi.com/.  
3) Copy `.env.example` (or edit `.env`) and set your key:
   ```
   WEATHER_API_KEY=YOUR_API_KEY_HERE
   ```
4) Install dependencies:
   ```
   flutter pub get
   ```
5) Run the app:
   ```
   flutter run
   ```
   - For web (`flutter run -d chrome`), pass the key via dart-define instead of .env:
     ```
     flutter run -d chrome --dart-define=WEATHER_API_KEY=YOUR_API_KEY_HERE
     ```

## Usage Notes
- Allow location permission to use the "Use my location" shortcut on Home.
- Notifications require enabling local notifications on the device/emulator.
- The city list screen supports filtering; tap a city to load its 3‑day forecast, or the info button for detailed view.
- Forecast screens include a link to open the selected location on the map.

## Project Structure
- `lib/main.dart` – App entry, providers, routes, notification init.
- `lib/providers/weather_provider.dart` – Weather data/state, GPS loading, alerts, cache.
- `lib/services/` – API calls, location access, notifications.
- `lib/screens/` – Home, cities list, 3‑day forecast, hourly forecast, detailed forecast.
- `lib/widgets/weather_card.dart` – Reusable city weather tile.

## Testing
- Run analyzer/tests:
  ```
  flutter analyze
  flutter test
  ```
