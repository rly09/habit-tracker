# 🎯 Habit Tracker

> A beautiful, intuitive habit tracking mobile app built with Flutter. Build better habits, one day at a time.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue?style=flat-square)

---

## ✨ Features

- 📱 **Cross-Platform**: Seamlessly run on Android and iOS
- 🎨 **Beautiful UI**: Clean, modern interface designed for daily use
- 📊 **Progress Tracking**: Visual streak counter and completion statistics
- ⏰ **Daily Reminders**: Get notified to complete your habits
- 🎯 **Goal Management**: Create, edit, and track multiple habits
- 📈 **Analytics**: View your progress over time with detailed charts
- 🌙 **Dark Mode Support**: Easy on the eyes, anytime
- 💾 **Local Storage**: All your data stays on your device

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Latest version)
- [Dart SDK](https://dart.dev/get-dart) (Comes with Flutter)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) (for emulators)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/rly09/habit-tracker.git
   cd habit-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build & Deploy

**For Android:**
```bash
flutter build apk
# or for app bundle
flutter build appbundle
```

**For iOS:**
```bash
flutter build ios
```

---

## 📁 Project Structure

```
habit-tracker/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── habit.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── habit_detail_screen.dart
│   ├── widgets/
│   │   └── habit_card.dart
│   └── services/
│       └── storage_service.dart
├── assets/
│   ├── images/
│   └── fonts/
├── pubspec.yaml
└── README.md
```

---

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider / Riverpod
- **Local Database**: Hive / SQLite
- **UI Components**: Material Design 3
- **Notifications**: Flutter Local Notifications

---

## 📱 Screenshots

<!-- Add screenshots here -->
| Home Screen | Habit Details | Progress | Settings |
|:---:|:---:|:---:|:---:|
| ![Home](assets/screenshots/home.png) | ![Details](assets/screenshots/details.png) | ![Progress](assets/screenshots/progress.png) | ![Settings](assets/screenshots/settings.png) |

---

## 🎮 Usage

### Creating a Habit
1. Tap the **+** button on the home screen
2. Enter habit name, description, and goal frequency
3. Set reminder time (optional)
4. Tap **Create**

### Logging Progress
1. Tap the habit card to mark it as complete for the day
2. View your streak and completion status
3. Track multiple attempts per day if needed

### Viewing Analytics
1. Navigate to the **Progress** tab
2. View your statistics and trends
3. Export data for external analysis

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Dart style guide and Flutter best practices
- Write tests for new features
- Update documentation as needed
- Keep commits atomic and meaningful

---

## 🐛 Bug Reports & Feature Requests

Found a bug or have a feature idea? Please [open an issue](https://github.com/rly09/habit-tracker/issues)!

---

## 📖 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Building a Habit Tracking App - Tutorial](https://medium.com)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Rhythm Arora** ([@rly09](https://github.com/rly09))

- GitHub: [@rly09](https://github.com/rly09)
- Email: [your-email@example.com]

---

## 🙏 Acknowledgments

- Flutter and Dart communities
- All contributors and supporters
- Inspired by popular habit tracking apps

---

## 📞 Support

If you like this project, please give it a ⭐ and share it with others!

Have questions? Feel free to open an issue or start a discussion.

---

**Made with ❤️ by Rhythm Arora**
