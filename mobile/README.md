
# Fred Soutenance App

This is the Flutter adaptation of the "Fred Soutenance" web project.
It includes a full onboard flow, meeting creation dashboard, schedule view, history, and settings with dark mode persistence.

## Getting Started

1.  **Dependencies**: The project relies on `shared_preferences`, `google_fonts`, and `provider`.
    Run the following command to install them:
    ```bash
    flutter pub get
    ```

2.  **Run the App**:
    ```bash
    flutter run
    ```

## Features

*   **Onboarding Flow**: Voice profile setup and introduction.
*   **Create Meeting**: Dashboard to start video/audio/AI meetings.
*   **Schedule**: view upcoming and daily meetings.
*   **History**: Review past meetings and AI summaries.
*   **Settings**: Toggle Dark Mode (persisted), manage notifications and profile.
*   **Theme**: Custom "Nebula" dark theme with purple/blue accents and glassmorphism effects.

## Platform

Designed for **Android** (and iOS), utilizing `SafeArea` and responsive layouts.
