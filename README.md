# Plot Gremlin Mobile 🧌

![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-blue)
![Flutter](https://img.shields.io/badge/flutter-3.0%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**Your Mischievous D&D Session Assistant - Now on Mobile!**

Plot Gremlin is a mobile application that listens to your Dungeons & Dragons sessions and generates real-time suggestions for quests, encounters, and story developments using AI. Styled with a gothic, mischievous aesthetic, it brings supernatural chaos to your tabletop adventures.

<div align="center">
  <img src="assets/images/gremlin_banner.png" alt="Plot Gremlin Banner" width="600"/>
</div>

---

## ✨ Features

### 🎙️ Audio Recording
- **Live listening mode** - Record session audio in real-time
- **Manual recording control** - Start/stop recording on demand
- **Automatic transcription** - Convert speech to text (configurable)

### 🤖 AI Integration
- **Offline Mode** - Works without internet using local suggestions
- **OpenAI GPT** - Premium AI suggestions with GPT-4o-mini
- **Free API Support** - Connect your own LLM provider
- **Context-aware responses** - Suggestions based on session content

### 🔒 Authentication
- **Email/Password** - Traditional sign-up and login
- **Google Sign-In** - Quick OAuth authentication
- **Apple Sign-In** - Native iOS authentication
- **Secure** - Powered by Firebase Authentication

### 🎨 Gothic Theme
- **Dark atmospheric UI** - Immersive "Gremlin's Lair" interface
- **Animated blood bar** - Visual progress indicator
- **Flickering effects** - Subtle candlelight animations
- **Custom fonts** - Elegant Garamond typography

### ⚙️ Customizable Settings
- **Provider selection** - Choose AI backend
- **Aggregate count** - Set how many snippets before suggestions
- **Idle chatter** - Gremlin messages during inactivity
- **Sound effects** - Optional audio feedback
- **Live listen toggle** - Enable/disable real-time recording

---

## 📱 Screenshots

| Login Screen | Main Interface | Settings Panel |
|--------------|----------------|----------------|
| <img src="screenshots/login.png" width="200"/> | <img src="screenshots/lair.png" width="200"/> | <img src="screenshots/settings.png" width="200"/> |

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Firebase account
- Android Studio or Xcode

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/plot_gremlin_mobile.git
cd plot_gremlin_mobile
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Setup Firebase**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

4. **Run the app**
```bash
flutter run
```

For detailed setup instructions, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

---

## 📂 Project Structure

```
plot_gremlin_mobile/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Firebase configuration
│   │
│   ├── providers/                   # State management
│   │   ├── auth_provider.dart       # Authentication logic
│   │   ├── settings_provider.dart   # App settings
│   │   └── gremlin_provider.dart    # AI suggestion logic
│   │
│   ├── screens/                     # UI screens
│   │   ├── auth/
│   │   │   ├── auth_wrapper.dart    # Auth state router
│   │   │   ├── login_screen.dart    # Login UI
│   │   │   └── register_screen.dart # Registration UI
│   │   └── home/
│   │       └── lair_screen.dart     # Main interface
│   │
│   ├── widgets/                     # Reusable components
│   │   ├── atmospheric_background.dart
│   │   ├── blood_bar.dart
│   │   ├── settings_panel.dart
│   │   └── output_panel.dart
│   │
│   ├── services/                    # Business logic
│   │   └── audio_service.dart       # Audio recording
│   │
│   └── theme/
│       └── app_theme.dart           # Gothic dark theme
│
├── assets/
│   ├── audio/                       # Sound effects
│   ├── images/                      # Graphics
│   ├── fonts/                       # Custom fonts
│   └── animations/                  # Lottie files
│
├── android/                         # Android configuration
├── ios/                             # iOS configuration
├── pubspec.yaml                     # Dependencies
└── README.md
```

---

## 🔧 Configuration

### API Keys

Configure in-app via Settings Panel:

1. **OpenAI API Key** (optional)
   - Get from [OpenAI Platform](https://platform.openai.com/)
   - Used for GPT-4o-mini suggestions
   - Stored securely in device storage

2. **Custom LLM Provider** (optional)
   - Enter your own API endpoint
   - Configure authentication

### Settings Options

- **Provider**: Offline / Free API / OpenAI GPT
- **Aggregate Count**: 1-20 audio snippets before generation
- **Live Listen**: Enable/disable automatic recording
- **Sound Effects**: Toggle audio feedback
- **Idle Chatter**: Gremlin messages during inactivity
- **Idle Interval**: 5-300 seconds between messages

---

## 🎮 Usage

### Basic Workflow

1. **Sign In**
   - Create account or use OAuth (Google/Apple)

2. **Configure Settings**
   - Choose AI provider
   - Enter API key if using OpenAI
   - Set aggregate count (default: 5)

3. **Record Session**
   - Tap "SUMMON" to start listening
   - Speak or let your D&D session play
   - Blood bar fills as audio is collected

4. **Get Suggestions**
   - Once bar is full, Plot Gremlin generates suggestions
   - View mischievous plot twists and story ideas
   - Tap again to record more

### Offline Mode

Works without internet:
- Uses local fallback suggestions
- Context-aware responses
- No API key required

### Live Listen Mode

Continuous recording:
- Automatically captures audio
- Transcribes in background
- Generates suggestions when threshold is met

---

## 🛠️ Development

### Run in debug mode

```bash
flutter run
```

### Build for release

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

### Run tests

```bash
flutter test
```

### Code formatting

```bash
flutter format .
```

### Analyze code

```bash
flutter analyze
```

---

## 🔐 Security

- **Firebase Authentication** - Industry-standard security
- **Secure storage** - API keys stored with encryption
- **No backend storage** - Audio processed locally or via API
- **Minimal permissions** - Only microphone access required

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by the original [Plot Gremlin](https://github.com/yourusername/plot-gremlin) Flask app
- Built with [Flutter](https://flutter.dev/)
- Powered by [Firebase](https://firebase.google.com/)
- AI by [OpenAI](https://openai.com/)

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/plot_gremlin_mobile/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/plot_gremlin_mobile/discussions)
- **Email**: support@plotgremlin.com

---

## 🗺️ Roadmap

- [ ] Cloud storage for session history
- [ ] Share suggestions with party members
- [ ] Campaign management features
- [ ] Character notes and tracking
- [ ] Improved offline transcription
- [ ] Custom AI model training
- [ ] Multi-language support
- [ ] Tablet/iPad optimization

---

## 📊 Changelog

### Version 1.0.0 (Initial Release)
- ✅ Email/password authentication
- ✅ Google and Apple Sign-In
- ✅ Audio recording and transcription
- ✅ AI suggestion generation
- ✅ Offline mode support
- ✅ Gothic dark theme
- ✅ Settings persistence
- ✅ Idle chatter feature
- ✅ Blood bar progress indicator

---

**🧌 May your plots be twisted and your rolls be critical!**

Made with 🗡 by the Plot Gremlin team