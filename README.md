# HealthX - Comprehensive Habit Tracker

A beautiful Flutter app for tracking habits, food intake, tasks, and personal growth with gamification elements.

## Features

### 🔥 Core Tracking
- **Streak Tracker**: Track your NoFap/NNN journey with real-time timer
- **Relapse Management**: Record and learn from setbacks
- **Habit System**: Create and manage daily habits with completion tracking

### 🍔 Food Tracker
- Log meals (Breakfast, Lunch, Dinner, Snacks)
- Automatic fasting timer
- Swipe to delete accidental entries
- View meal history by date

### ✅ Task Manager
- Create daily tasks with descriptions
- Built-in stopwatch for each task
- Track time spent on activities
- Mark tasks as complete

### 📊 Analytics & Progress
- Visual streak history with line charts
- Statistics dashboard
- Date-based filtering
- Track improvement over time

### 🏆 Gamification
- **Valorant-Style Ranks**: Progress from Iron to Radiant
- Rank based on streak consistency
- Visual progress indicators
- Unlock achievements

### 📅 History
- Browse data by specific dates
- View all activities for any day
- Delete accidental entries
- Navigate between dates easily

### 🎨 UI/UX
- Beautiful dark and light themes
- Smooth animations throughout
- Material Design 3
- Custom color schemes
- Responsive layouts

## Tech Stack

- **Framework**: Flutter 3.38.3
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **Charts**: fl_chart
- **Animations**: flutter_animate
- **Fonts**: Google Fonts (Outfit)

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android builds)

### Installation

1. Clone the repository:
```bash
git clone git@github.com:S-myth67/Healthx.git
cd Healthx
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

## Project Structure

```
lib/
├── core/
│   └── theme/           # App themes and styling
├── features/
│   ├── analytics/       # Charts and statistics
│   ├── food/           # Food tracking
│   ├── habits/         # Habit management
│   ├── history/        # Date-based data viewing
│   ├── home/           # Dashboard
│   ├── rewards/        # Ranking system
│   ├── tasks/          # Task management
│   └── tracker/        # Streak tracking
└── main.dart           # App entry point
```

## Features in Detail

### Streak Tracking
- Real-time timer showing days, hours, minutes, seconds
- Visual progress card with gradient design
- Relapse button with confirmation dialog
- Persistent data across app restarts

### Food Tracking
- Quick-log buttons for meal types
- Fasting duration calculator
- Dismissible list items for easy deletion
- Recent logs with timestamps

### Task Management
- Create tasks with titles
- Individual stopwatches per task
- Completion tracking
- Swipe to delete

### Ranking System
- 9 rank tiers (Iron → Radiant)
- Progress bar to next rank
- Emoji-based rank icons
- Unlock system based on streak days

### History View
- Calendar date picker
- Navigate with arrow buttons
- Filter all data by selected date
- Delete entries from history

## Customization

### Themes
Edit `lib/core/theme/app_theme.dart` to customize colors and styles.

### Ranks
Modify rank thresholds in `lib/features/rewards/screens/rewards_screen.dart`.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Author

**S-myth67**
- GitHub: [@S-myth67](https://github.com/S-myth67)

## Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI guidelines
- Valorant for rank inspiration

---

**Note**: This app stores all data locally using SharedPreferences. No data is sent to external servers.
